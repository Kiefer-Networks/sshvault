// Tests for FileChooser — verify backend detection per environment and
// that calls route through the injected FilePicker mock with the right
// MIME-type → extension translation.
//
// We never hit the real platform plugins: FileChooser exposes
// @visibleForTesting hooks that swap `Platform.environment`,
// `File.existsSync`, `defaultTargetPlatform`, and `FilePicker.platform`
// for in-memory stubs.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/utils/file_chooser.dart';

// We never assign to FilePicker.platform — the wrapper exposes its own
// `picker` slot — so PlatformInterface registration is not needed.
class _MockFilePicker extends Mock implements FilePicker {}

void main() {
  setUpAll(() {
    registerFallbackValue(FileType.any);
  });

  tearDown(() {
    FileChooser.resetForTesting();
  });

  group('detectBackend', () {
    void install({
      required TargetPlatform platform,
      Map<String, String> env = const {},
      Set<String> existingFiles = const {},
    }) {
      FileChooser.platformReader = () => platform;
      FileChooser.environmentReader = (k) => env[k];
      FileChooser.fileExistsReader = existingFiles.contains;
    }

    test('non-Linux platforms route to platform default', () {
      for (final p in [
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.android,
        TargetPlatform.iOS,
      ]) {
        install(platform: p);
        expect(
          FileChooser.detectBackend(),
          FileChooserBackend.platformDefault,
          reason: '$p should bypass Linux detection',
        );
      }
    });

    test('Flatpak forces XDG portal regardless of desktop', () {
      install(
        platform: TargetPlatform.linux,
        env: {'XDG_CURRENT_DESKTOP': 'GNOME'},
        existingFiles: {'/.flatpak-info'},
      );
      expect(FileChooser.detectBackend(), FileChooserBackend.xdgPortal);
    });

    test('Plasma session via KDE_FULL_SESSION uses XDG portal', () {
      install(
        platform: TargetPlatform.linux,
        env: {'KDE_FULL_SESSION': 'true'},
      );
      expect(FileChooser.detectBackend(), FileChooserBackend.xdgPortal);
    });

    test('Plasma session via XDG_CURRENT_DESKTOP=KDE uses XDG portal', () {
      install(
        platform: TargetPlatform.linux,
        env: {'XDG_CURRENT_DESKTOP': 'KDE'},
      );
      expect(FileChooser.detectBackend(), FileChooserBackend.xdgPortal);
    });

    test('Plasma session with composite XDG_CURRENT_DESKTOP detects KDE', () {
      install(
        platform: TargetPlatform.linux,
        env: {'XDG_CURRENT_DESKTOP': 'KDE:Plasma'},
      );
      expect(FileChooser.detectBackend(), FileChooserBackend.xdgPortal);
    });

    test('GNOME / generic Linux desktop uses GTK native chooser', () {
      install(
        platform: TargetPlatform.linux,
        env: {'XDG_CURRENT_DESKTOP': 'GNOME'},
      );
      expect(FileChooser.detectBackend(), FileChooserBackend.gtkNative);
    });

    test('Linux with no env hints defaults to GTK native', () {
      install(platform: TargetPlatform.linux);
      expect(FileChooser.detectBackend(), FileChooserBackend.gtkNative);
    });

    test('KDE_FULL_SESSION=false does not trigger portal', () {
      install(
        platform: TargetPlatform.linux,
        env: {'KDE_FULL_SESSION': 'false', 'XDG_CURRENT_DESKTOP': 'GNOME'},
      );
      expect(FileChooser.detectBackend(), FileChooserBackend.gtkNative);
    });
  });

  group('openFile', () {
    late _MockFilePicker mock;

    setUp(() {
      mock = _MockFilePicker();
      FileChooser.picker = mock;
    });

    test('passes localized title through to FilePicker', () async {
      when(
        () => mock.pickFiles(
          dialogTitle: any(named: 'dialogTitle'),
          type: any(named: 'type'),
          allowedExtensions: any(named: 'allowedExtensions'),
          withData: any(named: 'withData'),
        ),
      ).thenAnswer((_) async => null);

      await FileChooser.openFile(dialogTitle: 'L10N TITLE');

      verify(
        () => mock.pickFiles(
          dialogTitle: 'L10N TITLE',
          type: FileType.any,
          allowedExtensions: null,
          withData: false,
        ),
      ).called(1);
    });

    test(
      'translates MIME filters to FileType.custom + allowedExtensions',
      () async {
        when(
          () => mock.pickFiles(
            dialogTitle: any(named: 'dialogTitle'),
            type: any(named: 'type'),
            allowedExtensions: any(named: 'allowedExtensions'),
            withData: any(named: 'withData'),
          ),
        ).thenAnswer((_) async => null);

        await FileChooser.openFile(
          dialogTitle: 'pick',
          filters: const [FileTypeFilter.pem, FileTypeFilter.plainText],
        );

        final captured = verify(
          () => mock.pickFiles(
            dialogTitle: 'pick',
            type: captureAny(named: 'type'),
            allowedExtensions: captureAny(named: 'allowedExtensions'),
            withData: false,
          ),
        ).captured;
        expect(captured[0], FileType.custom);
        final exts = (captured[1] as List<String>).toSet();
        expect(
          exts,
          containsAll(<String>{'pem', 'key', 'pub', 'txt', 'conf', 'config'}),
        );
      },
    );

    test('any-only filter list resolves to FileType.any', () async {
      when(
        () => mock.pickFiles(
          dialogTitle: any(named: 'dialogTitle'),
          type: any(named: 'type'),
          allowedExtensions: any(named: 'allowedExtensions'),
          withData: any(named: 'withData'),
        ),
      ).thenAnswer((_) async => null);

      await FileChooser.openFile(
        dialogTitle: 't',
        filters: const [FileTypeFilter.any],
      );

      verify(
        () => mock.pickFiles(
          dialogTitle: 't',
          type: FileType.any,
          allowedExtensions: null,
          withData: false,
        ),
      ).called(1);
    });

    test(
      'returns FileChooserResult with name + path + bytes from result',
      () async {
        final pf = PlatformFile(
          name: 'id_ed25519',
          size: 4,
          path: '/tmp/id_ed25519',
          bytes: Uint8List.fromList([1, 2, 3, 4]),
        );
        when(
          () => mock.pickFiles(
            dialogTitle: any(named: 'dialogTitle'),
            type: any(named: 'type'),
            allowedExtensions: any(named: 'allowedExtensions'),
            withData: any(named: 'withData'),
          ),
        ).thenAnswer((_) async => FilePickerResult([pf]));

        final result = await FileChooser.openFile(dialogTitle: 't');
        expect(result, isNotNull);
        expect(result!.name, 'id_ed25519');
        expect(result.path, '/tmp/id_ed25519');
        expect(result.bytes, Uint8List.fromList([1, 2, 3, 4]));
      },
    );

    test('returns null when user cancels', () async {
      when(
        () => mock.pickFiles(
          dialogTitle: any(named: 'dialogTitle'),
          type: any(named: 'type'),
          allowedExtensions: any(named: 'allowedExtensions'),
          withData: any(named: 'withData'),
        ),
      ).thenAnswer((_) async => null);

      final result = await FileChooser.openFile(dialogTitle: 't');
      expect(result, isNull);
    });
  });

  group('saveFile', () {
    test('forwards dialog title, file name, bytes and filters', () async {
      final mock = _MockFilePicker();
      FileChooser.picker = mock;
      final bytes = Uint8List.fromList([9, 9, 9]);

      when(
        () => mock.saveFile(
          dialogTitle: any(named: 'dialogTitle'),
          fileName: any(named: 'fileName'),
          bytes: any(named: 'bytes'),
          type: any(named: 'type'),
          allowedExtensions: any(named: 'allowedExtensions'),
        ),
      ).thenAnswer((_) async => '/out/x.json');

      final saved = await FileChooser.saveFile(
        dialogTitle: 'Save settings',
        fileName: 'x.json',
        bytes: bytes,
        filters: const [FileTypeFilter.json],
      );

      expect(saved, '/out/x.json');
      verify(
        () => mock.saveFile(
          dialogTitle: 'Save settings',
          fileName: 'x.json',
          bytes: bytes,
          type: FileType.custom,
          allowedExtensions: ['json'],
        ),
      ).called(1);
    });
  });

  group('openDir', () {
    test('forwards dialog title to getDirectoryPath', () async {
      final mock = _MockFilePicker();
      FileChooser.picker = mock;

      when(
        () => mock.getDirectoryPath(dialogTitle: any(named: 'dialogTitle')),
      ).thenAnswer((_) async => '/home/u/work');

      final dir = await FileChooser.openDir(dialogTitle: 'pick folder');
      expect(dir, '/home/u/work');
      verify(() => mock.getDirectoryPath(dialogTitle: 'pick folder')).called(1);
    });
  });

  group('openFiles', () {
    test('returns empty list on cancel and forwards allowMultiple', () async {
      final mock = _MockFilePicker();
      FileChooser.picker = mock;

      when(
        () => mock.pickFiles(
          dialogTitle: any(named: 'dialogTitle'),
          type: any(named: 'type'),
          allowedExtensions: any(named: 'allowedExtensions'),
          withData: any(named: 'withData'),
          allowMultiple: any(named: 'allowMultiple'),
        ),
      ).thenAnswer((_) async => null);

      final files = await FileChooser.openFiles(dialogTitle: 'upload');
      expect(files, isEmpty);
      verify(
        () => mock.pickFiles(
          dialogTitle: 'upload',
          type: FileType.any,
          allowedExtensions: null,
          withData: false,
          allowMultiple: true,
        ),
      ).called(1);
    });
  });
}
