import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class SearchableSettingItem {
  final String key;
  final String title;
  final String? subtitle;
  final String category;
  final String route;
  final IconData icon;
  final Color iconColor;
  final List<String> keywords;

  const SearchableSettingItem({
    required this.key,
    required this.title,
    this.subtitle,
    required this.category,
    required this.route,
    required this.icon,
    required this.iconColor,
    this.keywords = const [],
  });
}

final settingsSearchQueryProvider = StateProvider<String>((ref) => '');

final settingsSearchIndexProvider = Provider<List<SearchableSettingItem>>((
  ref,
) {
  return const [
    // Security
    SearchableSettingItem(
      key: 'auto_lock',
      title: 'Auto-Lock Timeout',
      category: 'Security',
      route: '/settings/security',
      icon: Icons.lock_clock_outlined,
      iconColor: Colors.red,
      keywords: ['lock', 'timeout', 'auto', 'sperre', 'bloqueo'],
    ),
    SearchableSettingItem(
      key: 'biometric',
      title: 'Biometric Unlock',
      category: 'Security',
      route: '/settings/security',
      icon: Icons.fingerprint,
      iconColor: Colors.green,
      keywords: ['fingerprint', 'face', 'biometric', 'biometrie'],
    ),
    SearchableSettingItem(
      key: 'pin',
      title: 'PIN Code',
      category: 'Security',
      route: '/settings/security',
      icon: Icons.pin,
      iconColor: Colors.indigo,
      keywords: ['pin', 'code', 'passcode'],
    ),
    SearchableSettingItem(
      key: 'screenshots',
      title: 'Prevent Screenshots',
      category: 'Security',
      route: '/settings/security',
      icon: Icons.screenshot_monitor_outlined,
      iconColor: Colors.amber,
      keywords: ['screenshot', 'screen', 'capture', 'recording'],
    ),
    // SSH Defaults
    SearchableSettingItem(
      key: 'default_port',
      title: 'Default Port',
      category: 'SSH Defaults',
      route: '/settings/ssh',
      icon: Icons.numbers,
      iconColor: Colors.orange,
      keywords: ['port', 'ssh', '22'],
    ),
    SearchableSettingItem(
      key: 'default_username',
      title: 'Default Username',
      category: 'SSH Defaults',
      route: '/settings/ssh',
      icon: Icons.person_outline,
      iconColor: Colors.blue,
      keywords: ['username', 'user', 'root', 'benutzer'],
    ),
    // Appearance
    SearchableSettingItem(
      key: 'theme',
      title: 'Theme',
      category: 'Appearance',
      route: '/settings/appearance',
      icon: Icons.palette_outlined,
      iconColor: Colors.purple,
      keywords: ['theme', 'dark', 'light', 'design', 'dunkel', 'hell'],
    ),
    SearchableSettingItem(
      key: 'language',
      title: 'Language',
      category: 'Appearance',
      route: '/settings/appearance',
      icon: Icons.language,
      iconColor: Colors.teal,
      keywords: [
        'language',
        'locale',
        'sprache',
        'idioma',
        'english',
        'deutsch',
      ],
    ),
    SearchableSettingItem(
      key: 'terminal_theme',
      title: 'Terminal Theme',
      category: 'Appearance',
      route: '/settings/appearance',
      icon: Icons.color_lens_outlined,
      iconColor: Colors.deepPurple,
      keywords: ['terminal', 'theme', 'color'],
    ),
    SearchableSettingItem(
      key: 'font_size',
      title: 'Font Size',
      category: 'Appearance',
      route: '/settings/appearance',
      icon: Icons.text_fields_outlined,
      iconColor: Colors.teal,
      keywords: ['font', 'size', 'text', 'schrift'],
    ),
    // Network
    SearchableSettingItem(
      key: 'dns',
      title: 'DNS-over-HTTPS Servers',
      category: 'Network & DNS',
      route: '/settings/network',
      icon: Icons.dns_outlined,
      iconColor: Colors.cyan,
      keywords: ['dns', 'doh', 'network', 'netzwerk'],
    ),
    // Export
    SearchableSettingItem(
      key: 'encrypt_export',
      title: 'Encrypt Exports by Default',
      category: 'Export',
      route: '/settings/export',
      icon: Icons.enhanced_encryption_outlined,
      iconColor: Colors.deepOrange,
      keywords: ['export', 'encrypt', 'verschlüsseln'],
    ),
    // Support
    SearchableSettingItem(
      key: 'download_logs',
      title: 'Download Logs',
      category: 'Support',
      route: '/settings/support',
      icon: Icons.download_outlined,
      iconColor: Colors.brown,
      keywords: ['logs', 'download', 'protokoll'],
    ),
    SearchableSettingItem(
      key: 'send_logs',
      title: 'Send Logs to Support',
      category: 'Support',
      route: '/settings/support',
      icon: Icons.email_outlined,
      iconColor: Colors.pink,
      keywords: ['logs', 'support', 'email', 'send'],
    ),
  ];
});

final settingsSearchResultsProvider = Provider<List<SearchableSettingItem>>((
  ref,
) {
  final query = ref.watch(settingsSearchQueryProvider).toLowerCase().trim();
  if (query.isEmpty) return [];

  final index = ref.watch(settingsSearchIndexProvider);
  return index.where((item) {
    if (item.title.toLowerCase().contains(query)) return true;
    if (item.category.toLowerCase().contains(query)) return true;
    if (item.subtitle?.toLowerCase().contains(query) ?? false) return true;
    return item.keywords.any((kw) => kw.toLowerCase().contains(query));
  }).toList();
});
