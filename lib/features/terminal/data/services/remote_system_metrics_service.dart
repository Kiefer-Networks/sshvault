import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';

class RemoteDiskMetrics {
  final String mountPoint;
  final String? filesystem;

  /// Filesystem type (`ext4`, `zfs`, `nfs4`, `cifs`, `tmpfs`, ...), from
  /// `df -PT`'s Type column on Unix or `Win32_LogicalDisk.FileSystem` on
  /// Windows. Null for metrics collected before this field existed —
  /// `isPseudo`/`isNetworkMount` simply can't classify those, they fall
  /// back to being treated as a real disk (the old, only behavior).
  final String? fsType;
  final int totalBytes;
  final int usedBytes;
  final int freeBytes;
  const RemoteDiskMetrics({
    required this.mountPoint,
    required this.filesystem,
    this.fsType,
    required this.totalBytes,
    required this.usedBytes,
    required this.freeBytes,
  });
  Map<String, Object?> toJson() => {
    'mountPoint': mountPoint,
    'filesystem': filesystem,
    'fsType': fsType,
    'totalBytes': totalBytes,
    'usedBytes': usedBytes,
    'freeBytes': freeBytes,
  };
  factory RemoteDiskMetrics.fromJson(Map<String, Object?> json) =>
      RemoteDiskMetrics(
        mountPoint: json['mountPoint'] as String? ?? '',
        filesystem: json['filesystem'] as String?,
        fsType: json['fsType'] as String?,
        totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
        usedBytes: (json['usedBytes'] as num?)?.toInt() ?? 0,
        freeBytes: (json['freeBytes'] as num?)?.toInt() ?? 0,
      );

  /// True for a container-overlay mount (Docker/Podman `overlay2` storage,
  /// bind mounts under `/var/lib/docker/`). These are not a separate disk —
  /// there is one per running container — so every UI that lists disks
  /// groups them into a single "Docker" line instead of listing each one.
  bool get isDockerMount =>
      mountPoint.contains('overlay2') || mountPoint.contains('/docker/');

  /// True for network filesystems (NFS/CIFS/SMB/SSHFS/...) — shown in
  /// their own "Network Mounts" section rather than mixed in with local
  /// disks, since they represent a remote server, not local storage.
  bool get isNetworkMount =>
      fsType != null && _networkFsTypes.contains(fsType!.toLowerCase());

  /// True for kernel/virtual pseudo-filesystems (`proc`, `tmpfs`, `overlay`
  /// from snapd, `squashfs` snap loop mounts, ...) that `df` always lists
  /// but that aren't a disk a user manages or cares about seeing. This is
  /// what actually caused hosts with several real disks to have some of
  /// them silently pushed out of the UI's row cap: on a typical Linux
  /// desktop `df` reports a dozen+ of these before it gets to real storage.
  bool get isPseudo =>
      !isDockerMount &&
      fsType != null &&
      _pseudoFsTypes.contains(fsType!.toLowerCase());

  static const _networkFsTypes = {
    'nfs',
    'nfs4',
    'cifs',
    'smb3',
    'smbfs',
    'smb',
    'fuse.sshfs',
    'sshfs',
    'davfs',
    '9p',
    'glusterfs',
    'ceph',
    'afs',
  };

  static const _pseudoFsTypes = {
    'proc',
    'sysfs',
    'cgroup',
    'cgroup2',
    'tmpfs',
    'devtmpfs',
    'devpts',
    'securityfs',
    'pstore',
    'bpf',
    'tracefs',
    'debugfs',
    'configfs',
    'mqueue',
    'autofs',
    'none',
    'efivarfs',
    'fusectl',
    'binfmt_misc',
    'hugetlbfs',
    'rpc_pipefs',
    'squashfs',
    'overlay',
    'ramfs',
    'nsfs',
  };
}

/// Splits a disk list into real filesystems, container-overlay mounts,
/// network shares and kernel pseudo-filesystems, so every UI that renders
/// [RemoteSystemMetrics.disks] groups them the same way.
extension RemoteDiskGrouping on List<RemoteDiskMetrics> {
  List<RemoteDiskMetrics> get excludingDockerMounts =>
      where((d) => !d.isDockerMount).toList(growable: false);

  List<RemoteDiskMetrics> get dockerMountsOnly =>
      where((d) => d.isDockerMount).toList(growable: false);

  List<RemoteDiskMetrics> get networkMounts =>
      where((d) => d.isNetworkMount).toList(growable: false);

  /// Local, non-Docker, non-pseudo, non-network disks — what a user
  /// actually means by "my disks". This is what the detail pane's main
  /// disk list should render.
  List<RemoteDiskMetrics> get realDisks => where(
    (d) => !d.isDockerMount && !d.isPseudo && !d.isNetworkMount,
  ).toList(growable: false);
}

/// One Proxmox VE guest (`qm list` VM or `pct list` container) detected on
/// a host that has Proxmox tooling installed. Absent on every other host —
/// `qm`/`pct` simply aren't found, so the probe commands produce no `PVE|`
/// lines and this list stays empty.
class ProxmoxGuest {
  final String vmid;
  final String name;
  final bool running;

  /// `'vm'` (from `qm list`) or `'lxc'` (from `pct list`).
  final String type;

  const ProxmoxGuest({
    required this.vmid,
    required this.name,
    required this.running,
    required this.type,
  });

  Map<String, Object?> toJson() => {
    'vmid': vmid,
    'name': name,
    'running': running,
    'type': type,
  };

  factory ProxmoxGuest.fromJson(Map<String, Object?> json) => ProxmoxGuest(
    vmid: json['vmid'] as String? ?? '',
    name: json['name'] as String? ?? '',
    running: json['running'] as bool? ?? false,
    type: json['type'] as String? ?? 'vm',
  );
}

/// Technical metadata collected after SSH authentication. No file contents or credentials.
class RemoteSystemMetrics {
  final String osFamily;
  final String? osName,
      osVersion,
      osPrettyName,
      kernelName,
      kernelVersion,
      cpuModel;
  final int? cpuCores, cpuPhysicalCores, ramBytes;
  final String? cpuVendor, serialNumber;
  final bool? isVirtualMachine;
  final List<RemoteDiskMetrics> disks;

  /// Proxmox VE VMs/containers found via `qm list`/`pct list`. Empty on
  /// every host without Proxmox tooling installed — the probe commands
  /// are cheap enough (a `command -v` guard, then a fast CLI call) to run
  /// unconditionally rather than needing a separate "is this a Proxmox
  /// host" step first.
  final List<ProxmoxGuest> proxmoxGuests;
  final DateTime collectedAt;
  const RemoteSystemMetrics({
    required this.osFamily,
    this.osName,
    this.osVersion,
    this.osPrettyName,
    this.kernelName,
    this.kernelVersion,
    this.cpuModel,
    this.cpuCores,
    this.cpuPhysicalCores,
    this.cpuVendor,
    this.isVirtualMachine,
    this.serialNumber,
    this.ramBytes,
    this.disks = const [],
    this.proxmoxGuests = const [],
    required this.collectedAt,
  });
  Map<String, Object?> toJson() => {
    'osFamily': osFamily,
    'osName': osName,
    'osVersion': osVersion,
    'osPrettyName': osPrettyName,
    'kernelName': kernelName,
    'kernelVersion': kernelVersion,
    'cpuModel': cpuModel,
    'cpuCores': cpuCores,
    'cpuPhysicalCores': cpuPhysicalCores,
    'cpuVendor': cpuVendor,
    'isVirtualMachine': isVirtualMachine,
    'serialNumber': serialNumber,
    'ramBytes': ramBytes,
    'disks': disks.map((d) => d.toJson()).toList(growable: false),
    'proxmoxGuests': proxmoxGuests
        .map((g) => g.toJson())
        .toList(growable: false),
    'collectedAt': collectedAt.toUtc().toIso8601String(),
  };
  factory RemoteSystemMetrics.fromJson(Map<String, Object?> json) =>
      RemoteSystemMetrics(
        osFamily: json['osFamily'] as String? ?? 'unknown',
        osName: json['osName'] as String?,
        osVersion: json['osVersion'] as String?,
        osPrettyName: json['osPrettyName'] as String?,
        kernelName: json['kernelName'] as String?,
        kernelVersion: json['kernelVersion'] as String?,
        cpuModel: json['cpuModel'] as String?,
        cpuCores: (json['cpuCores'] as num?)?.toInt(),
        cpuPhysicalCores: (json['cpuPhysicalCores'] as num?)?.toInt(),
        cpuVendor: json['cpuVendor'] as String?,
        isVirtualMachine: json['isVirtualMachine'] as bool?,
        serialNumber: json['serialNumber'] as String?,
        ramBytes: (json['ramBytes'] as num?)?.toInt(),
        disks: ((json['disks'] as List?) ?? const [])
            .whereType<Map>()
            .map(
              (item) =>
                  RemoteDiskMetrics.fromJson(Map<String, Object?>.from(item)),
            )
            .toList(growable: false),
        proxmoxGuests: ((json['proxmoxGuests'] as List?) ?? const [])
            .whereType<Map>()
            .map(
              (item) => ProxmoxGuest.fromJson(Map<String, Object?>.from(item)),
            )
            .toList(growable: false),
        collectedAt:
            DateTime.tryParse(json['collectedAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

class RemoteSystemMetricsParser {
  static RemoteSystemMetrics parse(String osFamily, String output) {
    final values = <String, String>{};
    final disks = <RemoteDiskMetrics>[];
    final guests = <ProxmoxGuest>[];
    for (final raw in output.split(RegExp(r'\r?\n'))) {
      final line = raw.trim();
      if (line.startsWith('DISK|')) {
        final p = line.split('|');
        // 7 fields: DISK|mount|device|fsType|total|used|free (current
        // format). 6 fields: DISK|mount|device|total|used|free (format
        // used before fsType existed) — accepted too so a stray old-format
        // line can never crash parsing; fsType just stays null for it.
        if (p.length == 7) {
          final n = p.skip(4).map(int.tryParse).toList();
          if (n.any((v) => v == null || v < 0)) continue;
          disks.add(
            RemoteDiskMetrics(
              mountPoint: p[1],
              filesystem: p[2].isEmpty ? null : p[2],
              fsType: p[3].isEmpty ? null : p[3],
              totalBytes: n[0]!,
              usedBytes: n[1]!,
              freeBytes: n[2]!,
            ),
          );
        } else if (p.length == 6) {
          final n = p.skip(3).map(int.tryParse).toList();
          if (n.any((v) => v == null || v < 0)) continue;
          disks.add(
            RemoteDiskMetrics(
              mountPoint: p[1],
              filesystem: p[2].isEmpty ? null : p[2],
              totalBytes: n[0]!,
              usedBytes: n[1]!,
              freeBytes: n[2]!,
            ),
          );
        }
      } else if (line.startsWith('PVE|')) {
        final p = line.split('|');
        if (p.length != 5) continue;
        guests.add(
          ProxmoxGuest(
            type: p[1],
            vmid: p[2],
            name: p[3],
            running: p[4].trim().toLowerCase() == 'running',
          ),
        );
      } else {
        final i = line.indexOf('=');
        if (i > 0) values[line.substring(0, i)] = line.substring(i + 1);
      }
    }
    String? text(String key) =>
        values[key]?.trim().isNotEmpty == true ? values[key]!.trim() : null;
    int? positive(String key) {
      final n = int.tryParse(values[key] ?? '');
      return n != null && n > 0 ? n : null;
    }

    return RemoteSystemMetrics(
      osFamily: osFamily,
      osName: text('OS_NAME'),
      osVersion: text('OS_VERSION'),
      osPrettyName: text('OS_PRETTY_NAME'),
      kernelName: text('KERNEL_NAME'),
      kernelVersion: text('KERNEL_VERSION'),
      cpuModel: text('CPU_MODEL'),
      cpuCores: positive('CPU_CORES'),
      cpuPhysicalCores: positive('CPU_PHYSICAL_CORES'),
      cpuVendor: text('CPU_VENDOR'),
      isVirtualMachine: values['IS_VM'] == 'true'
          ? true
          : values['IS_VM'] == 'false'
          ? false
          : null,
      serialNumber: text('SERIAL_NUMBER'),
      ramBytes: positive('RAM_BYTES'),
      disks: List.unmodifiable(disks),
      proxmoxGuests: List.unmodifiable(guests),
      collectedAt: DateTime.now(),
    );
  }

  static RemoteSystemMetrics parseCpuInfo(
    String cpuInfo, {
    String? machine,
    String? serial,
  }) {
    final values = <String, String>{};
    for (final line in cpuInfo.split(RegExp(r'\r?\n'))) {
      final i = line.indexOf(':');
      if (i > 0)
        values[line.substring(0, i).trim().toLowerCase()] = line
            .substring(i + 1)
            .trim();
    }
    final flags = values['flags'] ?? '';
    final vm =
        flags.split(' ').contains('hypervisor') ||
        (machine ?? '').toLowerCase().contains(
          RegExp(r'vm|virtual|qemu|kvm|xen|bhyve'),
        );
    return RemoteSystemMetrics(
      osFamily: 'linux',
      cpuModel: values['model name'],
      cpuVendor: values['vendor_id'],
      cpuPhysicalCores: int.tryParse(values['cpu cores'] ?? ''),
      isVirtualMachine: vm,
      serialNumber: serial,
      collectedAt: DateTime.now(),
    );
  }
}

/// Collects metadata from an authenticated SSH client. Safe to call optionally after connect.
class RemoteSystemMetricsService {
  static const commandTimeout = Duration(seconds: 5);
  static const maxOutputBytes = 64 * 1024;
  Future<RemoteSystemMetrics> collect(SSHClient client) async {
    // Probe Unix first. On Unix hosts `cmd` is absent and may return a
    // non-zero exit status, which must not abort the entire collection.
    final probe = await _tryRun(client, 'uname -s');
    final windowsProbe = probe.trim().isEmpty
        ? await _tryRun(client, 'cmd /c ver')
        : '';
    final isWindows =
        windowsProbe.toLowerCase().contains('windows') ||
        probe.trim().toLowerCase().contains('windows');
    final family = isWindows ? 'windows' : _family(probe);
    if (!isWindows)
      return RemoteSystemMetricsParser.parse(
        family,
        await _collectUnix(client),
      );
    // Do not discard all metrics when one optional utility (PowerShell,
    // awk, getconf, or df) is unavailable. SSH servers often expose a
    // restricted login shell. Parsing the partial output still gives us the
    // values that are available and keeps the collection useful.
    var output = await _tryRun(
      client,
      isWindows ? _windowsCommand : _unixCommand,
    );
    // A restricted shell can execute the OS part and still reject one of the
    // hardware utilities. In that case run the small fallback as well and
    // let the parser keep the union of all key/value lines.
    if (output.trim().isEmpty ||
        (!output.contains('CPU_') &&
            !output.contains('RAM_BYTES=') &&
            !output.contains('DISK|'))) {
      final fallback = await _tryRun(
        client,
        isWindows ? _windowsFallbackCommand : _unixFallbackCommand,
      );
      if (fallback.isNotEmpty) output = '$output\n$fallback';
    }
    return RemoteSystemMetricsParser.parse(family, output);
  }

  String _family(String p) {
    final v = p.trim().toLowerCase();
    if (v.contains('darwin')) return 'macos';
    if (v.contains('freebsd') || v.contains('openbsd')) return 'bsd';
    return 'linux';
  }

  Future<String> _run(SSHClient client, String command) async {
    final bytes = await client.run(command).timeout(commandTimeout);
    return utf8.decode(
      bytes.length > maxOutputBytes ? bytes.sublist(0, maxOutputBytes) : bytes,
      allowMalformed: true,
    );
  }

  Future<String> _tryRun(SSHClient client, String command) async {
    try {
      return await _run(client, command);
    } catch (_) {
      return '';
    }
  }

  Future<String> _collectUnix(SSHClient client) async {
    final results = <String>[];
    for (final command in [
      'cat /etc/os-release',
      'uname -s',
      'uname -r',
      'uname -p',
      'getconf _NPROCESSORS_ONLN',
      'cat /proc/meminfo',
      'sysctl -n hw.ncpu hw.memsize machdep.cpu.brand_string',
      'df -PTk',
      'cat /proc/cpuinfo',
      'cat /sys/class/dmi/id/product_name',
      'cat /sys/class/dmi/id/product_serial',
      'command -v qm >/dev/null 2>&1 && qm list 2>/dev/null',
      'command -v pct >/dev/null 2>&1 && pct list 2>/dev/null',
    ]) {
      results.add(await _tryRun(client, command));
    }
    final os = <String, String>{};
    for (final line in results[0].split(RegExp(r'\r?\n'))) {
      final i = line.indexOf('=');
      if (i > 0)
        os[line.substring(0, i)] = line.substring(i + 1).replaceAll('"', '');
    }
    final uname = results[1].trim();
    final kernel = results[2].trim();
    final cpu = results[3].trim();
    final cores = results[4].trim();
    final mem = RegExp(r'MemTotal:\s+(\d+)').firstMatch(results[5])?.group(1);
    final sysctl = results[6]
        .split(RegExp(r'\r?\n'))
        .map((v) => v.trim())
        .where((v) => v.isNotEmpty)
        .toList();
    final isMac = uname.toLowerCase().contains('darwin');
    final cpuInfo = RemoteSystemMetricsParser.parseCpuInfo(
      results[8],
      machine: results[9],
      serial: results[10].trim(),
    );
    final lines = <String>[
      'OS_NAME=${isMac ? (await _tryRun(client, 'sw_vers -productName')).trim() : (os['NAME'] ?? '')}',
      'OS_VERSION=${isMac ? (await _tryRun(client, 'sw_vers -productVersion')).trim() : (os['VERSION_ID'] ?? '')}',
      'OS_PRETTY_NAME=${os['PRETTY_NAME'] ?? ''}',
      'KERNEL_NAME=$uname',
      'KERNEL_VERSION=$kernel',
      'CPU_MODEL=${cpuInfo.cpuModel ?? (cpu.isNotEmpty ? cpu : '')}',
      'CPU_VENDOR=${cpuInfo.cpuVendor ?? ''}',
      'CPU_PHYSICAL_CORES=${cpuInfo.cpuPhysicalCores ?? ''}',
      'IS_VM=${cpuInfo.isVirtualMachine == true}',
      'SERIAL_NUMBER=${cpuInfo.serialNumber ?? ''}',
      'CPU_CORES=${cores.isNotEmpty ? cores : (isMac && sysctl.isNotEmpty ? sysctl.first : '')}',
      'RAM_BYTES=${mem == null && isMac && sysctl.length > 1 ? sysctl[1] : (mem == null ? '' : int.parse(mem) * 1024)}',
    ];
    // df -PTk columns: Filesystem Type 1024-blocks Used Available Capacity
    // Mounted-on — Type (index 1) is what makes pseudo/network
    // classification possible; plain `df -Pk` has no such column.
    final df = results[7].split(RegExp(r'\r?\n'));
    for (final row in df.skip(1)) {
      final p = row.trim().split(RegExp(r'\s+'));
      if (p.length >= 7) {
        final n = p.sublist(2, 5).map(int.tryParse).toList();
        if (n.every((v) => v != null))
          lines.add(
            'DISK|${p.last}|${p.first}|${p[1]}|${n[0]! * 1024}|${n[1]! * 1024}|${n[2]! * 1024}',
          );
      }
    }
    _appendProxmoxLines(lines, qmList: results[11], pctList: results[12]);
    return lines.join('\n');
  }

  /// Parses `qm list`/`pct list` output into `PVE|` lines. Both accept
  /// whatever runs successfully — a host with only one of the two tools
  /// (unusual, but not impossible on a partial Proxmox install) still
  /// reports what it has instead of being dropped for lacking the other.
  void _appendProxmoxLines(
    List<String> lines, {
    required String qmList,
    required String pctList,
  }) {
    // qm list: "VMID NAME STATUS MEM(MB) BOOTDISK(GB) PID" — name never
    // contains spaces in Proxmox's own VM-name validation, so a plain
    // whitespace split is safe.
    for (final row in qmList.split(RegExp(r'\r?\n')).skip(1)) {
      final p = row.trim().split(RegExp(r'\s+'));
      if (p.length < 3) continue;
      lines.add('PVE|vm|${p[0]}|${p[1]}|${p[2]}');
    }
    // pct list: "VMID Status Lock Name" — Lock is often blank, so take the
    // name from the END of the row rather than assuming a fixed column
    // count.
    for (final row in pctList.split(RegExp(r'\r?\n')).skip(1)) {
      final p = row.trim().split(RegExp(r'\s+'));
      if (p.length < 3) continue;
      lines.add('PVE|lxc|${p[0]}|${p.last}|${p[1]}');
    }
  }

  static const _unixCommand = r'''sh -c '
if [ -r /etc/os-release ]; then . /etc/os-release; fi
printf "OS_NAME=%s\nOS_VERSION=%s\nOS_PRETTY_NAME=%s\n" "${NAME:-}" "${VERSION_ID:-}" "${PRETTY_NAME:-}"
printf "KERNEL_NAME=%s\nKERNEL_VERSION=%s\nCPU_MODEL=%s\nCPU_CORES=%s\n" "$(uname -s)" "$(uname -r)" "$(uname -p 2>/dev/null)" "$(getconf _NPROCESSORS_ONLN 2>/dev/null)"
if [ "$(uname -s)" = "Darwin" ]; then
  printf "OS_NAME=%s\nOS_VERSION=%s\nOS_PRETTY_NAME=%s\n" "$(sw_vers -productName 2>/dev/null)" "$(sw_vers -productVersion 2>/dev/null)" "$(sw_vers -productName 2>/dev/null) $(sw_vers -productVersion 2>/dev/null)"
  printf "CPU_MODEL=%s\nCPU_CORES=%s\nRAM_BYTES=%s\n" "$(sysctl -n machdep.cpu.brand_string 2>/dev/null)" "$(sysctl -n hw.ncpu 2>/dev/null)" "$(sysctl -n hw.memsize 2>/dev/null)"
else
  awk "/MemTotal/ {print \"RAM_BYTES=\" \$2 * 1024; exit}" /proc/meminfo 2>/dev/null
fi
df -PTk 2>/dev/null | awk "NR>1 {printf \"DISK|%s|%s|%s|%s|%s|%s\\n\", \$7, \$1, \$2, \$3*1024, \$4*1024, \$5*1024}"
if command -v qm >/dev/null 2>&1; then qm list 2>/dev/null | awk "NR>1 {print \"PVE|vm|\" \$1 \"|\" \$2 \"|\" \$3}"; fi
if command -v pct >/dev/null 2>&1; then pct list 2>/dev/null | awk "NR>1 {print \"PVE|lxc|\" \$1 \"|\" \$NF \"|\" \$2}"; fi
''';
  static const _windowsCommand =
      r'''powershell -NoProfile -NonInteractive -Command "$os=Get-CimInstance Win32_OperatingSystem; $cpu=Get-CimInstance Win32_Processor | Select-Object -First 1; $cs=Get-CimInstance Win32_ComputerSystem; Write-Output ('OS_NAME='+$os.Caption); Write-Output ('OS_VERSION='+$os.Version); Write-Output 'KERNEL_NAME=Windows NT'; Write-Output ('KERNEL_VERSION='+$os.Version); Write-Output ('CPU_MODEL='+$cpu.Name); Write-Output ('CPU_CORES='+$cpu.NumberOfLogicalProcessors); Write-Output ('RAM_BYTES='+$cs.TotalPhysicalMemory); Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object { Write-Output ('DISK|'+$_.DeviceID+'|'+$_.DeviceID+'|'+$_.FileSystem+'|'+$_.Size+'|'+($_.Size-$_.FreeSpace)+'|'+$_.FreeSpace) }"''';
  static const _windowsFallbackCommand =
      r'''powershell.exe -NoProfile -NonInteractive -Command "$os=Get-CimInstance Win32_OperatingSystem; $cpu=Get-CimInstance Win32_Processor | Select-Object -First 1; Write-Output ('OS_NAME='+$os.Caption); Write-Output ('OS_VERSION='+$os.Version); Write-Output ('KERNEL_NAME=Windows NT'); Write-Output ('KERNEL_VERSION='+$os.Version); Write-Output ('CPU_MODEL='+$cpu.Name); Write-Output ('CPU_CORES='+$cpu.NumberOfLogicalProcessors); Write-Output ('RAM_BYTES='+$os.TotalVisibleMemorySize*1024)"''';
  static const _unixFallbackCommand =
      r'''printf "KERNEL_NAME=%s\nKERNEL_VERSION=%s\nCPU_MODEL=%s\nCPU_CORES=%s\n" "$(uname -s)" "$(uname -r)" "$(uname -p 2>/dev/null || true)" "$(getconf _NPROCESSORS_ONLN 2>/dev/null || true)"; if [ -r /proc/meminfo ]; then awk '/MemTotal/ {print "RAM_BYTES=" $2 * 1024; exit}' /proc/meminfo; fi; df -PTk 2>/dev/null | awk 'NR>1 {printf "DISK|%s|%s|%s|%s|%s|%s\n", $7, $1, $2, $3*1024, $4*1024, $5*1024}' || true''';
}
