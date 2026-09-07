/// Formats a byte count as a human-readable string (`4.1 GB`, `812.4 MB`).
String formatBytes(int bytes) {
  const tb = 1024 * 1024 * 1024 * 1024;
  const gb = 1024 * 1024 * 1024;
  const mb = 1024 * 1024;
  if (bytes >= tb) return '${(bytes / tb).toStringAsFixed(1)} TB';
  if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(1)} GB';
  return '${(bytes / mb).toStringAsFixed(1)} MB';
}
