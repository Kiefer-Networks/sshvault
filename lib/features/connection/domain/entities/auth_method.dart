enum AuthMethod {
  password,
  key,
  both;

  String get displayName => switch (this) {
        password => 'Password',
        key => 'SSH Key',
        both => 'Password + Key',
      };
}
