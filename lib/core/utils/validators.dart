abstract final class Validators {
  static final _hostnameRegex = RegExp(
    r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z]{2,}$',
  );

  static final _ipv4Regex = RegExp(
    r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$',
  );

  static final _usernameRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_\-\.]{0,31}$');

  static String? validateHostname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Hostname is required';
    }
    final trimmed = value.trim();
    if (_hostnameRegex.hasMatch(trimmed)) return null;
    if (_ipv4Regex.hasMatch(trimmed)) {
      final parts = trimmed.split('.').map(int.parse);
      if (parts.every((p) => p >= 0 && p <= 255)) return null;
    }
    // Allow IPv6
    if (trimmed.contains(':') && !trimmed.contains(' ')) return null;
    return 'Invalid hostname or IP address';
  }

  static String? validatePort(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Port is required';
    }
    final port = int.tryParse(value.trim());
    if (port == null || port < 1 || port > 65535) {
      return 'Port must be between 1 and 65535';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (!_usernameRegex.hasMatch(value.trim())) {
      return 'Invalid username format';
    }
    return null;
  }

  static String? validateServerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Server name is required';
    }
    if (value.trim().length > 100) {
      return 'Server name must be 100 characters or less';
    }
    return null;
  }

  static String? validateSshKey(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    // Check for common SSH key prefixes
    const validPrefixes = [
      '-----BEGIN',
      'ssh-rsa',
      'ssh-ed25519',
      'ecdsa-sha2',
      'ssh-dss',
    ];
    if (!validPrefixes.any((p) => trimmed.startsWith(p))) {
      return 'Invalid SSH key format';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateExportPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
