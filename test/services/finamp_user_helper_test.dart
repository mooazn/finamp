import 'package:finamp/models/finamp_models.dart';
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

  group('visibleMusicTabsForLibrary', () {
    test('turns a Mixes library into a standalone Songs browser', () {
      final view = BaseItemDto(id: const BaseItemId('mixes'), name: 'Mixes', collectionType: 'music');

      final tabs = visibleMusicTabsForLibrary(const [
        ContentType.home,
        ContentType.albums,
        ContentType.genericArtists,
        ContentType.playlists,
      ], view);

      expect(tabs, [ContentType.home, ContentType.tracks]);
    });

    test('leaves regular music library tabs unchanged', () {
      final view = BaseItemDto(id: const BaseItemId('music'), name: 'Music', collectionType: 'music');
      const enabledTabs = [ContentType.home, ContentType.albums, ContentType.tracks];

      expect(visibleMusicTabsForLibrary(enabledTabs, view), enabledTabs);
    });
  });
}
