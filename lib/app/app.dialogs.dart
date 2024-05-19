// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/bible_data/bible_data_dialog.dart';
import '../ui/dialogs/chat_history/chat_history_dialog.dart';
import '../ui/dialogs/summary/summary_dialog.dart';

enum DialogType {
  summary,
  chatHistory,
  bibleData,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.summary: (context, request, completer) =>
        SummaryDialog(request: request, completer: completer),
    DialogType.chatHistory: (context, request, completer) =>
        ChatHistoryDialog(request: request, completer: completer),
    DialogType.bibleData: (context, request, completer) =>
        BibleDataDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
