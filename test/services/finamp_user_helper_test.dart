import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isMediaControlMixesLibrary', () {
    test('recognizes MediaControl mix music libraries', () {
      final view = BaseItemDto(id: const BaseItemId('mixes'), name: 'Music Mixes', collectionType: 'music');

      expect(isMediaControlMixesLibrary(view), isTrue);
    });

    test('recognizes a Mixes folder configured as mixed content', () {
      final view = BaseItemDto(id: const BaseItemId('mixes'), name: 'Mixes', collectionType: 'mixed');

      expect(isMediaControlMixesLibrary(view), isTrue);
    });

    test('does not enroll a non-music library', () {
      final view = BaseItemDto(id: const BaseItemId('mixes'), name: 'Mixes', collectionType: 'homevideos');

      expect(isMediaControlMixesLibrary(view), isFalse);
    });
  });
}
