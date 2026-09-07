# Archived optional post-quantum extension

These text files preserve SSHVault's previous liboqs-backed ML-KEM-768/X25519
and sntrup761/X25519 implementation. They are **not compiled, exported, or
advertised** by the dartssh2 4.1.0 transport. Their old KEX factory and shared
secret integration interfaces do not exist in the upstream transport.

A future rebase needs transcript/secret encoding tests, malformed peer key
validation, native library packaging checks, and real OpenSSH interoperability
before these algorithms can be enabled again. The active client retains the
modern classical upstream KEX algorithms; it does not silently claim PQ support.
