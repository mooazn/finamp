import 'package:finamp/components/album_image.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows default artwork when an item has no image', (tester) async {
    final item = BaseItemDto(id: const BaseItemId('track-without-art'), type: 'Audio', name: 'No Cover');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox.square(dimension: 120, child: AlbumImage(item: item)),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(DefaultArtwork), findsOneWidget);
    expect(find.byIcon(Icons.music_note_rounded), findsOneWidget);
  });
}
