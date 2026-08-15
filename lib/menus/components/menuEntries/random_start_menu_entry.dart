import 'dart:math';

import 'package:finamp/menus/components/menuEntries/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

const randomStartMinimumDuration = Duration(minutes: 30);
const randomStartEndBuffer = Duration(minutes: 1);

Duration randomStartPosition(Duration duration, {Random? random}) {
  final latestStart = duration - randomStartEndBuffer;
  if (latestStart <= Duration.zero) return Duration.zero;

  final generator = random ?? Random();
  return Duration(milliseconds: generator.nextInt(latestStart.inMilliseconds + 1));
}

/// Starts a long-form audio item at a random timestamp.
class RandomStartMenuEntry extends StatelessWidget implements HideableMenuEntry {
  const RandomStartMenuEntry({super.key, required this.baseItem});

  final BaseItemDto baseItem;

  @override
  bool get isVisible => (baseItem.runTimeTicksDuration() ?? Duration.zero) >= randomStartMinimumDuration;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: MenuEntry(
        icon: TablerIcons.dice,
        title: "Random start",
        tooltip: "Play from a random point in this track",
        onTap: () async {
          Navigator.pop(context);
          final duration = baseItem.runTimeTicksDuration() ?? Duration.zero;
          await GetIt.instance<QueueService>().startPlayback(
            items: [baseItem],
            source: QueueItemSource.fromBaseItem(baseItem),
            initialSeekPosition: randomStartPosition(duration),
          );
        },
      ),
    );
  }
}
