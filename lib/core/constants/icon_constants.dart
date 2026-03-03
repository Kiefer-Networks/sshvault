import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract final class IconConstants {
  static const List<ServerIcon> serverIcons = [
    ServerIcon('server', Icons.dns),
    ServerIcon('cloud', Icons.cloud),
    ServerIcon('database', Icons.storage),
    ServerIcon('web', Icons.language),
    ServerIcon('api', Icons.api),
    ServerIcon('container', Icons.inventory_2),
    ServerIcon('kubernetes', Icons.hub),
    ServerIcon('monitoring', Icons.monitor_heart),
    ServerIcon('firewall', Icons.shield),
    ServerIcon('loadbalancer', Icons.balance),
    ServerIcon('mail', Icons.email),
    ServerIcon('git', Icons.merge_type),
    ServerIcon('ci', Icons.loop),
    ServerIcon('desktop', Icons.computer),
    ServerIcon('laptop', Icons.laptop),
    ServerIcon('raspberry', Icons.developer_board),
    ServerIcon('router', Icons.router),
    ServerIcon('nas', Icons.sd_storage),
    ServerIcon('gaming', Icons.sports_esports),
    ServerIcon('home', Icons.home),
    ServerIcon('office', Icons.business),
    ServerIcon('dev', Icons.code),
    ServerIcon('staging', Icons.science),
    ServerIcon('production', Icons.rocket_launch),
    ServerIcon('backup', Icons.backup),
    ServerIcon('proxy', Icons.swap_horiz),
    ServerIcon('vpn', Icons.vpn_key),
    ServerIcon('dns', Icons.dns_outlined),
    ServerIcon('logging', Icons.article),
    ServerIcon('queue', Icons.queue),
    ServerIcon('cache', Icons.cached),
    ServerIcon('search', Icons.search),
    ServerIcon('media', Icons.perm_media),
    ServerIcon('iot', Icons.settings_remote),
    ServerIcon('terminal', Icons.terminal),

    // Distro & Platform icons
    ServerIcon('linux', FontAwesomeIcons.linux),
    ServerIcon('ubuntu', FontAwesomeIcons.ubuntu),
    ServerIcon('debian', FontAwesomeIcons.debian),
    ServerIcon('fedora', FontAwesomeIcons.fedora),
    ServerIcon('centos', FontAwesomeIcons.centos),
    ServerIcon('redhat', FontAwesomeIcons.redhat),
    ServerIcon('suse', FontAwesomeIcons.suse),
    ServerIcon('freebsd', FontAwesomeIcons.freebsd),
    ServerIcon('windows', FontAwesomeIcons.windows),
    ServerIcon('apple', FontAwesomeIcons.apple),
  ];

  static const String defaultIconName = 'server';

  static IconData getIcon(String name) {
    return serverIcons
        .firstWhere((i) => i.name == name, orElse: () => serverIcons.first)
        .icon;
  }
}

class ServerIcon {
  final String name;
  final IconData icon;

  const ServerIcon(this.name, this.icon);
}
