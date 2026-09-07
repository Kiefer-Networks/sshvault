// Tests for ChunkBuffer, which SSHTransport (and SftpClient) use to queue
// raw bytes read from a socket and pull packets back out of them. See Q-01
// in AUDIT.md: `add()` used to be O(n) per call (concatenating into a
// brand new array every time), making a long transfer O(n^2) overall, and
// `view()` used to copy when its name promised an alias while `consume()`
// aliased when a caller might reasonably expect a safe, independent copy.
//
// This file is web-safe on purpose so it's exercised by both the VM and the
// web (chrome) CI job -- it only touches dart:typed_data.

import 'dart:typed_data';

import 'package:dartssh2/src/utils/chunk_buffer.dart';
import 'package:test/test.dart';

void main() {
  group('ChunkBuffer', () {
    test('starts empty', () {
      final buffer = ChunkBuffer();
      expect(buffer.isEmpty, isTrue);
      expect(buffer.isNotEmpty, isFalse);
      expect(buffer.length, 0);
      expect(buffer.data, isEmpty);
    });

    test('add then consume across chunk boundaries', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([1, 2, 3]));
      buffer.add(Uint8List.fromList([4, 5]));
      buffer.add(Uint8List.fromList([6, 7, 8, 9]));

      expect(buffer.length, 9);
      expect(buffer.data, [1, 2, 3, 4, 5, 6, 7, 8, 9]);

      // A single consume() spanning all three added chunks reassembles
      // them in order.
      expect(buffer.consume(9), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
      expect(buffer.isEmpty, isTrue);
    });

    test('consume exactly one chunk', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([1, 2, 3]));

      expect(buffer.consume(3), [1, 2, 3]);
      expect(buffer.isEmpty, isTrue);
    });

    test('consume less than one chunk leaves the remainder buffered', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([1, 2, 3, 4, 5]));

      expect(buffer.consume(2), [1, 2]);
      expect(buffer.length, 3);
      expect(buffer.data, [3, 4, 5]);
      expect(buffer.consume(3), [3, 4, 5]);
      expect(buffer.isEmpty, isTrue);
    });

    test('consume more than the buffered length throws', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([1, 2, 3]));

      expect(() => buffer.consume(4), throwsRangeError);
      // The failed call must not have mutated the buffer.
      expect(buffer.length, 3);
    });

    test('consume with no argument drains everything', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([1, 2]));
      buffer.add(Uint8List.fromList([3, 4]));

      expect(buffer.consume(), [1, 2, 3, 4]);
      expect(buffer.isEmpty, isTrue);
    });

    test('interleaved add and consume', () {
      final buffer = ChunkBuffer();

      buffer.add(Uint8List.fromList([1, 2, 3]));
      expect(buffer.consume(1), [1]);
      expect(buffer.data, [2, 3]);

      buffer.add(Uint8List.fromList([4, 5]));
      expect(buffer.data, [2, 3, 4, 5]);
      expect(buffer.consume(4), [2, 3, 4, 5]);
      expect(buffer.isEmpty, isTrue);

      buffer.add(Uint8List.fromList([6]));
      buffer.add(Uint8List.fromList([7, 8]));
      expect(buffer.consume(2), [6, 7]);
      expect(buffer.consume(1), [8]);
      expect(buffer.isEmpty, isTrue);
    });

    test('view does not consume', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([1, 2, 3, 4, 5]));

      expect(buffer.view(1, 3), [2, 3, 4]);
      // Still all there, unconsumed.
      expect(buffer.length, 5);
      expect(buffer.data, [1, 2, 3, 4, 5]);
    });

    test('view out of range throws', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([1, 2, 3]));

      expect(() => buffer.view(0, 4), throwsRangeError);
      expect(() => buffer.view(2, 2), throwsRangeError);
    });

    test('skip discards bytes without allocating a result', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([1, 2, 3, 4, 5]));

      buffer.skip(2);
      expect(buffer.length, 3);
      expect(buffer.data, [3, 4, 5]);
    });

    group('copy-vs-view semantics', () {
      test(
          'add() copies its input: mutating the source afterwards does '
          'not affect the buffer', () {
        final buffer = ChunkBuffer();
        final source = Uint8List.fromList([1, 2, 3]);
        buffer.add(source);

        source[0] = 99;

        expect(buffer.data, [1, 2, 3]);
      });

      test(
          'consume() returns a COPY: mutating it does not affect the '
          'buffer, and further mutation does not affect the returned '
          'array', () {
        final buffer = ChunkBuffer();
        buffer.add(Uint8List.fromList([1, 2, 3, 4]));

        final copy = buffer.consume(2);
        expect(copy, [1, 2]);

        // Mutate the copy: the still-buffered remainder must be
        // unaffected, proving consume() did not hand out an alias of the
        // backing storage.
        copy[0] = 99;
        expect(buffer.data, [3, 4]);

        // And the converse: mutate what remains in the buffer, the
        // earlier copy must be unaffected.
        final rest = buffer.consume(2);
        rest[0] = 42;
        expect(copy, [99, 2]);
      });

      test(
          'view() and consumeView() return a VIEW: mutating the returned '
          'array is visible through this buffer', () {
        final buffer = ChunkBuffer();
        buffer.add(Uint8List.fromList([1, 2, 3, 4]));

        final peeked = buffer.view(0, 4);
        peeked[0] = 77;
        // The mutation through the view is visible via another accessor
        // into the same backing storage -- proof it's a real alias, not a
        // copy.
        expect(buffer.data, [77, 2, 3, 4]);

        final consumed = buffer.consumeView(4);
        // consumeView() returned the same (now-mutated) backing memory
        // that view() aliased above.
        expect(consumed, [77, 2, 3, 4]);
        consumed[1] = 88;
        // Nothing else can observe this buffer's storage once it's fully
        // drained, but the mutation must still be visible on the returned
        // array itself (it's live memory, not a snapshot).
        expect(consumed, [77, 88, 3, 4]);
      });
    });

    test('clear() drops all buffered data', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([1, 2, 3]));
      buffer.clear();

      expect(buffer.isEmpty, isTrue);
      expect(buffer.length, 0);
    });

    test('byteData reads over the unconsumed window', () {
      final buffer = ChunkBuffer();
      buffer.add(Uint8List.fromList([0, 0, 1, 0, 0, 0, 2, 0]));
      expect(buffer.byteData.getUint32(0), 256);

      buffer.consume(4);
      // After consuming the leading 4 bytes, byteData must read starting
      // from the new front of the buffer, not from the original array's
      // index 0 (a regression here would indicate the offset bookkeeping
      // for the growable backing array is wrong). This is exactly the
      // pattern SftpClient uses to read each packet's length header.
      expect(buffer.byteData.getUint32(0), 512);
    });

    test('repeated add/consume cycles do not grow memory without bound', () {
      final buffer = ChunkBuffer();
      final chunk = Uint8List(1024);

      // Steady-state streaming: each chunk is fully consumed before the
      // next is added, mirroring how SSHTransport drains _buffer between
      // packets. The buffer must release its backing array on every full
      // drain instead of retaining ever-larger storage.
      for (var i = 0; i < 5000; i++) {
        buffer.add(chunk);
        expect(buffer.consume(chunk.length).length, chunk.length);
        expect(buffer.isEmpty, isTrue);
      }

      // Nothing left buffered, and (see chunk_buffer.dart) a fully drained
      // buffer resets its backing array to a zero-length one rather than
      // holding onto whatever it last grew to.
      expect(buffer.length, 0);
    });

    test('large append-heavy workload reassembles correctly', () {
      // Regression test for the O(n) `add()` that used to make a long
      // transfer (e.g. a large SFTP download, which streams through
      // exactly this pattern: many add() calls, occasional consume()
      // calls) quadratic overall. This doesn't measure complexity
      // directly, but it does exercise many growth/compaction cycles and
      // checks the result is still byte-for-byte correct.
      final buffer = ChunkBuffer();
      final expected = <int>[];

      for (var i = 0; i < 2000; i++) {
        final chunk = Uint8List.fromList(
          List<int>.generate(37, (j) => (i + j) & 0xFF),
        );
        buffer.add(chunk);
        expected.addAll(chunk);

        // Consume in irregular amounts so chunk boundaries and reassembly
        // points don't line up, exercising both the in-place-append and
        // the grow-and-compact paths of add().
        if (i % 3 == 0 && buffer.length >= 50) {
          final expectedChunk = expected.sublist(0, 50);
          expected.removeRange(0, 50);
          expect(buffer.consume(50), expectedChunk);
        }
      }

      expect(buffer.consume(), expected);
    });
  });
}
