package de.kiefer_networks.sshvault

import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyInfo
import android.security.keystore.KeyProperties
import android.security.keystore.StrongBoxUnavailableException
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.GCMParameterSpec

/**
 * Bridges the Flutter side ([KeyringService] on Android) to a hardware-backed
 * AndroidKeyStore-managed AES-256-GCM master key.
 *
 * Goals over `flutter_secure_storage`'s `EncryptedSharedPreferences`:
 *   * Explicit key generation with [KeyProperties.PURPOSE_ENCRYPT] /
 *     [KeyProperties.PURPOSE_DECRYPT] only — no signing surface.
 *   * Prefer StrongBox (Pixel 3+, Samsung S20+, hardened-element-backed
 *     devices) and degrade gracefully to TEE on devices without one.
 *   * Surface the actual security level to the UI so the user can verify
 *     where their key lives ("Hardware Security (StrongBox)" /
 *     "Hardware Security (TEE)" / "Software Keystore").
 *
 * The channel is kept stateless: each method call performs the syscall and
 * returns. Cipher state is not retained between calls because the Flutter
 * side serialises its own usage.
 */
class AndroidKeystoreHelper(messenger: BinaryMessenger) {
    companion object {
        const val CHANNEL_NAME = "de.kiefer_networks.sshvault/keystore"
        private const val KEYSTORE_PROVIDER = "AndroidKeyStore"

        // AES-GCM authentication tag length. 128 is the maximum and the
        // value mandated by NIST SP 800-38D for security-sensitive contexts.
        private const val GCM_TAG_BITS = 128

        // Standard AES-GCM IV length in bytes. The keystore-provided IV is
        // serialised in front of the ciphertext on encrypt and consumed on
        // decrypt so we don't need a separate IV channel.
        private const val GCM_IV_BYTES = 12

        // Security level constants surfaced to the Dart side. Kept as
        // strings (rather than ints) so the Flutter UI can switch on them
        // without depending on AOSP-internal enum values that change
        // between API levels.
        const val SECURITY_LEVEL_STRONGBOX = "strongbox"
        const val SECURITY_LEVEL_TEE = "tee"
        const val SECURITY_LEVEL_SOFTWARE = "software"
    }

    private val channel = MethodChannel(messenger, CHANNEL_NAME).apply {
        setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "createMasterKey" -> {
                        val alias = call.argument<String>("alias")
                        val requireBiometric =
                            call.argument<Boolean>("requireBiometric") ?: false
                        if (alias.isNullOrBlank()) {
                            result.error(
                                "INVALID_ARGUMENT",
                                "alias must be a non-empty string",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        result.success(createMasterKey(alias, requireBiometric))
                    }
                    "securityLevel" -> {
                        val alias = call.argument<String>("alias")
                        if (alias.isNullOrBlank()) {
                            result.error(
                                "INVALID_ARGUMENT",
                                "alias must be a non-empty string",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        result.success(securityLevel(alias))
                    }
                    "delete" -> {
                        val alias = call.argument<String>("alias")
                        if (alias.isNullOrBlank()) {
                            result.error(
                                "INVALID_ARGUMENT",
                                "alias must be a non-empty string",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        delete(alias)
                        result.success(null)
                    }
                    "encrypt" -> {
                        val alias = call.argument<String>("alias")
                        val plaintext = call.argument<ByteArray>("plaintext")
                        if (alias.isNullOrBlank() || plaintext == null) {
                            result.error(
                                "INVALID_ARGUMENT",
                                "alias and plaintext are required",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        result.success(encrypt(alias, plaintext))
                    }
                    "decrypt" -> {
                        val alias = call.argument<String>("alias")
                        val ciphertext = call.argument<ByteArray>("ciphertext")
                        if (alias.isNullOrBlank() || ciphertext == null) {
                            result.error(
                                "INVALID_ARGUMENT",
                                "alias and ciphertext are required",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        result.success(decrypt(alias, ciphertext))
                    }
                    "exists" -> {
                        val alias = call.argument<String>("alias")
                        if (alias.isNullOrBlank()) {
                            result.error(
                                "INVALID_ARGUMENT",
                                "alias must be a non-empty string",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        result.success(exists(alias))
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error(
                    "KEYSTORE_ERROR",
                    e.message ?: e.javaClass.simpleName,
                    e.stackTraceToString()
                )
            }
        }
    }

    /**
     * Generate a new AES-256-GCM key under [alias] in the AndroidKeyStore.
     * StrongBox is preferred on API 28+ and the call falls back to a regular
     * TEE-backed key when the device does not expose a StrongBox.
     *
     * Returns `true` when the key already existed (no-op) or when a fresh
     * key was successfully provisioned. Throws on unrecoverable errors so
     * the channel handler can surface a structured `KEYSTORE_ERROR`.
     */
    fun createMasterKey(alias: String, requireBiometric: Boolean): Boolean {
        if (exists(alias)) return true

        val keyGen = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES,
            KEYSTORE_PROVIDER
        )

        // Prefer StrongBox where available. Anything pre-P does not know
        // about setIsStrongBoxBacked; we set the flag conditionally so the
        // builder remains compilable against older minSdk values.
        val tryStrongBox = Build.VERSION.SDK_INT >= Build.VERSION_CODES.P

        val primarySpec = baseSpecBuilder(alias, requireBiometric).apply {
            if (tryStrongBox) setIsStrongBoxBacked(true)
        }.build()

        try {
            keyGen.init(primarySpec)
            keyGen.generateKey()
            return true
        } catch (e: Exception) {
            // StrongBoxUnavailableException only exists on API 28+, so we
            // also catch the generic case for older devices that throw a
            // plain ProviderException with the same root cause.
            if (tryStrongBox && isStrongBoxUnavailable(e)) {
                val fallbackSpec = baseSpecBuilder(alias, requireBiometric)
                    .setIsStrongBoxBacked(false)
                    .build()
                keyGen.init(fallbackSpec)
                keyGen.generateKey()
                return true
            }
            throw e
        }
    }

    /**
     * Inspects the existing key under [alias] and reports whether it lives
     * in StrongBox, the TEE, or in software. Returns `null` when no such
     * key exists.
     */
    fun securityLevel(alias: String): String? {
        val keyStore = loadKeyStore()
        if (!keyStore.containsAlias(alias)) return null

        val key = keyStore.getKey(alias, null) as? SecretKey ?: return null
        val factory = SecretKeyFactory.getInstance(key.algorithm, KEYSTORE_PROVIDER)
        val info = factory.getKeySpec(key, KeyInfo::class.java) as KeyInfo

        // Android S (API 31) introduced KeyInfo.getSecurityLevel which
        // returns granular SECURITY_LEVEL_STRONGBOX / TRUSTED_ENVIRONMENT
        // / SOFTWARE values. Older releases only expose
        // isInsideSecureHardware which lumps StrongBox and TEE together,
        // so on those devices we conservatively report "tee" when the key
        // is hardware-backed.
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            when (info.securityLevel) {
                KeyProperties.SECURITY_LEVEL_STRONGBOX ->
                    SECURITY_LEVEL_STRONGBOX
                KeyProperties.SECURITY_LEVEL_TRUSTED_ENVIRONMENT ->
                    SECURITY_LEVEL_TEE
                KeyProperties.SECURITY_LEVEL_SOFTWARE ->
                    SECURITY_LEVEL_SOFTWARE
                else -> SECURITY_LEVEL_SOFTWARE
            }
        } else {
            @Suppress("DEPRECATION")
            if (info.isInsideSecureHardware) SECURITY_LEVEL_TEE
            else SECURITY_LEVEL_SOFTWARE
        }
    }

    /** Removes [alias] from the keystore. No-op when the alias is unknown. */
    fun delete(alias: String) {
        val keyStore = loadKeyStore()
        if (keyStore.containsAlias(alias)) {
            keyStore.deleteEntry(alias)
        }
    }

    /**
     * Encrypts [plaintext] under [alias]. The IV is randomly generated by
     * the keystore on Cipher.init and prepended to the ciphertext so the
     * caller only stores a single blob.
     */
    fun encrypt(alias: String, plaintext: ByteArray): ByteArray {
        val key = loadSecretKey(alias)
            ?: throw IllegalStateException("No key under alias '$alias'")
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, key)
        val iv = cipher.iv
        require(iv.size == GCM_IV_BYTES) {
            "Unexpected IV length ${iv.size}; expected $GCM_IV_BYTES"
        }
        val ct = cipher.doFinal(plaintext)
        // [iv | ciphertext+tag]
        val out = ByteArray(iv.size + ct.size)
        System.arraycopy(iv, 0, out, 0, iv.size)
        System.arraycopy(ct, 0, out, iv.size, ct.size)
        return out
    }

    /** Reverse of [encrypt]. Splits the IV prefix and authenticates the tag. */
    fun decrypt(alias: String, ciphertext: ByteArray): ByteArray {
        require(ciphertext.size > GCM_IV_BYTES) {
            "Ciphertext shorter than IV header"
        }
        val key = loadSecretKey(alias)
            ?: throw IllegalStateException("No key under alias '$alias'")
        val iv = ciphertext.copyOfRange(0, GCM_IV_BYTES)
        val body = ciphertext.copyOfRange(GCM_IV_BYTES, ciphertext.size)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.DECRYPT_MODE, key, GCMParameterSpec(GCM_TAG_BITS, iv))
        return cipher.doFinal(body)
    }

    /** Returns true when [alias] is present in the AndroidKeyStore. */
    fun exists(alias: String): Boolean = loadKeyStore().containsAlias(alias)

    // -- internals ------------------------------------------------------

    private fun baseSpecBuilder(
        alias: String,
        requireBiometric: Boolean
    ): KeyGenParameterSpec.Builder {
        return KeyGenParameterSpec.Builder(
            alias,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
        )
            .setKeySize(256)
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setRandomizedEncryptionRequired(true)
            .setUserAuthenticationRequired(requireBiometric)
    }

    private fun loadKeyStore(): KeyStore =
        KeyStore.getInstance(KEYSTORE_PROVIDER).apply { load(null) }

    private fun loadSecretKey(alias: String): SecretKey? {
        val ks = loadKeyStore()
        if (!ks.containsAlias(alias)) return null
        return ks.getKey(alias, null) as? SecretKey
    }

    /**
     * StrongBoxUnavailableException is API 28+. We branch on the runtime
     * version so the app remains compilable against older platform jars
     * and gracefully tolerates devices that surface the same condition as
     * a generic `ProviderException` with a chained `StrongBoxUnavailable`
     * cause.
     */
    private fun isStrongBoxUnavailable(e: Throwable): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P &&
            e is StrongBoxUnavailableException
        ) return true
        var cause: Throwable? = e
        while (cause != null) {
            if (cause.javaClass.simpleName == "StrongBoxUnavailableException") {
                return true
            }
            cause = cause.cause
        }
        return false
    }
}
