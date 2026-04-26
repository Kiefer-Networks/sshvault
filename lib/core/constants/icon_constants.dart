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
    ServerIcon('android', FontAwesomeIcons.android),
    ServerIcon('docker', FontAwesomeIcons.docker),
    ServerIcon('aws', FontAwesomeIcons.aws),
    ServerIcon('digitalocean', FontAwesomeIcons.digitalOcean),
    ServerIcon('github', FontAwesomeIcons.github),
    ServerIcon('gitlab', FontAwesomeIcons.gitlab),
    ServerIcon('bitbucket', FontAwesomeIcons.bitbucket),

    // Finance & business
    ServerIcon('money', Icons.attach_money),
    ServerIcon('euro', Icons.euro),
    ServerIcon('payment', Icons.payments),
    ServerIcon('wallet', Icons.account_balance_wallet),
    ServerIcon('bank', Icons.account_balance),
    ServerIcon('shopping', Icons.shopping_cart),
    ServerIcon('store', Icons.store),
    ServerIcon('crypto', FontAwesomeIcons.bitcoin),
    ServerIcon('chart', Icons.show_chart),
    ServerIcon('analytics', Icons.analytics),
    ServerIcon('receipt', Icons.receipt_long),

    // Communication & social
    ServerIcon('chat', Icons.chat),
    ServerIcon('forum', Icons.forum),
    ServerIcon('phone', Icons.phone),
    ServerIcon('video', Icons.videocam),
    ServerIcon('voip', Icons.headset_mic),
    ServerIcon('calendar', Icons.calendar_today),
    ServerIcon('notes', Icons.note),
    ServerIcon('contacts', Icons.contacts),

    // Storage & files
    ServerIcon('files', Icons.folder),
    ServerIcon('archive', Icons.archive),
    ServerIcon('photos', Icons.photo_library),
    ServerIcon('music', Icons.library_music),
    ServerIcon('movie', Icons.movie),
    ServerIcon('book', Icons.menu_book),
    ServerIcon('document', Icons.description),
    ServerIcon('cloud_upload', Icons.cloud_upload),

    // Security & admin
    ServerIcon('lock', Icons.lock),
    ServerIcon('shield_alt', Icons.security),
    ServerIcon('admin', Icons.admin_panel_settings),
    ServerIcon('key', Icons.key),
    ServerIcon('fingerprint', Icons.fingerprint),
    ServerIcon('verified', Icons.verified_user),
    ServerIcon('bug', Icons.bug_report),

    // Hardware & infra
    ServerIcon('memory', Icons.memory),
    ServerIcon('hard_drive', Icons.storage),
    ServerIcon('print', Icons.print),
    ServerIcon('camera', Icons.videocam_outlined),
    ServerIcon('sensor', Icons.sensors),
    ServerIcon('power', Icons.power),
    ServerIcon('battery', Icons.battery_charging_full),
    ServerIcon('lightbulb', Icons.lightbulb),
    ServerIcon('thermostat', Icons.thermostat),
    ServerIcon('wifi', Icons.wifi),
    ServerIcon('bluetooth', Icons.bluetooth),

    // Misc
    ServerIcon('star', Icons.star),
    ServerIcon('flag', Icons.flag),
    ServerIcon('bookmark', Icons.bookmark),
    ServerIcon('tag', Icons.local_offer),
    ServerIcon('label', Icons.label),
    ServerIcon('school', Icons.school),
    ServerIcon('work', Icons.work),
    ServerIcon('person', Icons.person),
    ServerIcon('group', Icons.group),
    ServerIcon('public', Icons.public),
    ServerIcon('lab', Icons.biotech),
    ServerIcon('build', Icons.build),
    ServerIcon('extension', Icons.extension),
    ServerIcon('bolt', Icons.bolt),
    ServerIcon('rocket', Icons.rocket),
    ServerIcon('park', Icons.park),
    ServerIcon('pets', Icons.pets),
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
