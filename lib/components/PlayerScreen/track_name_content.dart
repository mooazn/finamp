import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_button.dart';
import 'package:finamp/components/PlayerScreen/album_chip.dart';
import 'package:finamp/components/PlayerScreen/artist_chip.dart';
import 'package:finamp/components/PlayerScreen/player_buttons_more.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/screens/player_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:finamp/services/scrolling_text_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackNameContent extends ConsumerWidget {
  const TrackNameContent(this.controller, {super.key});

  final PlayerHideableController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(QueueService.queueProvider);

    if (queue?.currentTrack == null) {
      return const CircularProgressIndicator();
    }
    final currentTrack = queue!.currentTrack!;

    final jellyfin_models.BaseItemDto trackBaseItemDto = currentTrack.baseItem;

    Widget getContent(BoxConstraints constraints, double padding) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Semantics.fromProperties(
            properties: SemanticsProperties(
              label: "${currentTrack.item.title} (${AppLocalizations.of(context)!.title})",
            ),
            excludeSemantics: true,
            container: true,
            child: Consumer(
              builder: (context, ref, _) {
                final text = currentTrack.item.title;
                // TODO properly scale in player screen controller?
                final isTwoLineMode =
                    controller.shouldShow(PlayerHideable.twoLineTitle) &&
                    !(MediaQuery.textScalerOf(context).scale(18) > 18 * 1.11);

                final textStyle = TextStyle(
                  fontSize: 24,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.45,
                  color: Colors.white,
                );

                final textSpan = TextSpan(text: text, style: textStyle);
                final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, maxLines: 2)
                  ..layout(maxWidth: 280);

                final wouldOverflow = textPainter.didExceedMaxLines;
                textPainter.dispose();

                if (!isTwoLineMode) {
                  return Text(
                    text,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  );
                } else {
                  if (wouldOverflow && ref.watch(finampSettingsProvider.oneLineMarqueeTextButton)) {
                    return SizedBox(
                      width: 280,
                      height: 30,
                      child: ScrollingTextHelper(
                        id: ValueKey(currentTrack.item.id),
                        text: text,
                        style: textStyle,
                        alignment: TextAlign.start,
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 46.0,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          text,
                          style: textStyle,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: ArtistChips(
                baseItem: trackBaseItemDto,
                backgroundColor: Colors.transparent,
                color: Colors.white.withValues(alpha: 0.76),
              ),
            ),
            const Spacer(),
            AddToPlaylistButton(item: trackBaseItemDto, queueItem: currentTrack),
            PlayerButtonsMore(item: trackBaseItemDto, queueItem: currentTrack),
          ],
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AlbumChips(
            baseItem: trackBaseItemDto,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            color: Colors.white.withValues(alpha: 0.7),
            key: trackBaseItemDto.album == null ? null : ValueKey("${trackBaseItemDto.album}-album"),
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = ((constraints.maxWidth - 260) / 4).clamp(0, 20);
        return Padding(
          padding: EdgeInsets.only(left: padding + 12, right: padding + 12, bottom: 4.0),
          child: getContent(constraints, padding),
        );
      },
    );
  }
}
