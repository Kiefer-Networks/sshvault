import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/features/terminal/data/services/remote_system_metrics_service.dart';

void main() {
  test('parses Linux system, kernel, cpu, memory and disks', () {
    final metrics = RemoteSystemMetricsParser.parse('linux', '''
OS_NAME=Ubuntu
OS_VERSION=24.04
OS_PRETTY_NAME=Ubuntu 24.04 LTS
KERNEL_NAME=Linux
KERNEL_VERSION=6.8.0-31-generic
CPU_MODEL=Intel(R) Xeon(R) CPU
CPU_CORES=8
RAM_BYTES=17179869184
DISK|/|ext4|100000|40000|60000
DISK|/data|xfs|200000|100000|100000
''');

    expect(metrics.osName, 'Ubuntu');
    expect(metrics.osVersion, '24.04');
    expect(metrics.kernelVersion, '6.8.0-31-generic');
    expect(metrics.cpuModel, contains('Intel'));
    expect(metrics.cpuCores, 8);
    expect(metrics.ramBytes, 17179869184);
    expect(metrics.disks, hasLength(2));
    expect(metrics.disks.first.mountPoint, '/');
    expect(metrics.disks.first.freeBytes, 60000);
  });

  test('parses Windows values and ignores malformed disk rows', () {
    final metrics = RemoteSystemMetricsParser.parse('windows', '''
OS_NAME=Microsoft Windows 11 Pro
OS_VERSION=10.0.26100
KERNEL_NAME=Windows NT
KERNEL_VERSION=10.0.26100
CPU_MODEL=AMD Ryzen
CPU_CORES=16
RAM_BYTES=34359738368
DISK|C:|NTFS|500000|200000|300000
DISK|bad
''');

    expect(metrics.osFamily, 'windows');
    expect(metrics.cpuCores, 16);
    expect(metrics.disks, hasLength(1));
    expect(metrics.disks.single.mountPoint, 'C:');
  });

  test('caps unsafe values and accepts missing optional values', () {
    final metrics = RemoteSystemMetricsParser.parse('macos', '''
CPU_CORES=0
RAM_BYTES=-1
DISK|/|apfs|not-a-number|2|3
''');

    expect(metrics.osFamily, 'macos');
    expect(metrics.cpuCores, isNull);
    expect(metrics.ramBytes, isNull);
    expect(metrics.disks, isEmpty);
  });

  test('round trips the encrypted-vault JSON representation', () {
    final original = RemoteSystemMetricsParser.parse(
      'macos',
      'OS_NAME=macOS\nRAM_BYTES=100\nDISK|/|apfs|100|40|60',
    );
    final restored = RemoteSystemMetrics.fromJson(original.toJson());
    expect(restored.osFamily, 'macos');
    expect(restored.osName, 'macOS');
    expect(restored.ramBytes, 100);
    expect(restored.disks.single.filesystem, 'apfs');
  });

  test('extracts CPU, virtualization and serial data from Linux probes', () {
    final metrics = RemoteSystemMetricsParser.parseCpuInfo('''
model name : AMD EPYC 9634 84-Core Processor
vendor_id : AuthenticAMD
cpu cores : 8
flags : fpu hypervisor avx2
''', machine: 'QEMU Virtual Machine', serial: 'SER-123');

    expect(metrics.cpuModel, contains('AMD EPYC'));
    expect(metrics.cpuVendor, 'AuthenticAMD');
    expect(metrics.cpuPhysicalCores, 8);
    expect(metrics.isVirtualMachine, isTrue);
    expect(metrics.serialNumber, 'SER-123');
  });
}
