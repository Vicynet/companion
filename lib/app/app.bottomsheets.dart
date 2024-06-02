// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/bible/bible_sheet.dart';
import '../ui/bottom_sheets/podcast/podcast_sheet.dart';

enum BottomSheetType {
  bible,
  podcast,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.bible: (context, request, completer) =>
        BibleSheet(request: request, completer: completer),
    BottomSheetType.podcast: (context, request, completer) =>
        PodcastSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
