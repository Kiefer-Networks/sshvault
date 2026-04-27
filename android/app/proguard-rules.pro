# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep dartssh2 native bindings
-keep class com.example.dartssh2.** { *; }

# Keep notification channel metadata
-keep class androidx.core.app.NotificationCompat { *; }

# Play Core deferred components (referenced by Flutter engine)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Drift (sqlite ORM) — generated DAOs and table classes are reflected over
-keep class drift.** { *; }

# SQLCipher / Zetetic native bindings (loaded via reflection from Dart FFI)
-keep class net.zetetic.** { *; }
-keep class net.sqlcipher.** { *; }

# BouncyCastle — backwards-compat surface for dartssh2 / liboqs FFI
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# liboqs FFI symbols — application namespace also hosts JNI entry points
# for the post-quantum KEX (.so files under src/main/jniLibs/<abi>/)
-keep class de.kiefer_networks.** { *; }

# flutter_local_notifications — receivers + Gson model classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.** { *; }
