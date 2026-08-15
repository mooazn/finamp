import 'dart:math';

import 'package:finamp/menus/components/menuEntries/random_start_menu_entry.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('random start stays inside the playable range', () {
    const duration = Duration(hours: 5);

    final position = randomStartPosition(duration, random: Random(42));

    expect(position, greaterThanOrEqualTo(Duration.zero));
    expect(position, lessThanOrEqualTo(duration - randomStartEndBuffer));
  });

  test('short input never produces a negative timestamp', () {
    expect(randomStartPosition(const Duration(seconds: 20), random: Random(42)), Duration.zero);
  });

  test('the action is only offered for long-form tracks', () {
    final longTrack = BaseItemDto(
      id: const BaseItemId('long'),
      type: 'Audio',
      runTimeTicks: const Duration(hours: 5).inMicroseconds * 10,
    );
    final shortTrack = BaseItemDto(
      id: const BaseItemId('short'),
      type: 'Audio',
      runTimeTicks: const Duration(minutes: 4).inMicroseconds * 10,
    );

    expect(RandomStartMenuEntry(baseItem: longTrack).isVisible, isTrue);
    expect(RandomStartMenuEntry(baseItem: shortTrack).isVisible, isFalse);
  });
}
