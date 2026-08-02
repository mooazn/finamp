import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldEnableAlbumAutoplay', () {
    test('enables autoplay for newly played online albums', () {
      expect(
        shouldEnableAlbumAutoplay(
          sourceType: QueueItemSourceType.album,
          hasSourceItem: true,
          beginPlaying: true,
          isRestoredQueue: false,
          isOffline: false,
        ),
        isTrue,
      );
    });

    test('does not alter restored, offline, or non-album queues', () {
      for (final input in [
        (QueueItemSourceType.album, true, true, true, false),
        (QueueItemSourceType.album, true, true, false, true),
        (QueueItemSourceType.playlist, true, true, false, false),
        (QueueItemSourceType.album, false, true, false, false),
      ]) {
        expect(
          shouldEnableAlbumAutoplay(
            sourceType: input.$1,
            hasSourceItem: input.$2,
            beginPlaying: input.$3,
            isRestoredQueue: input.$4,
            isOffline: input.$5,
          ),
          isFalse,
        );
      }
    });
  });
}
