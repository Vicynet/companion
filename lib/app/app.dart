import 'package:companion/ui/views/home/home_view.dart';
import 'package:companion/ui/views/startup/startup_view.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:companion/services/bible_data_service.dart';
import 'package:companion/ui/bottom_sheets/bible/bible_sheet.dart';
import 'package:companion/ui/dialogs/summary/summary_dialog.dart';
import 'package:companion/services/gemini_service.dart';
import 'package:companion/ui/views/bible_chat/bible_chat_view.dart';
import 'package:companion/services/database_service.dart';
import 'package:companion/ui/dialogs/chat_history/chat_history_dialog.dart';
import 'package:companion/ui/dialogs/bible_data/bible_data_dialog.dart';
import 'package:companion/ui/bottom_sheets/podcast/podcast_sheet.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: BibleChatView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BibleDataService),
    LazySingleton(classType: GeminiService),
    LazySingleton(classType: DatabaseMigrationService),
    InitializableSingleton(classType: DatabaseService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: BibleSheet),
    StackedBottomsheet(classType: PodcastSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: SummaryDialog),
    StackedDialog(classType: ChatHistoryDialog),
    StackedDialog(classType: BibleDataDialog),
// @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
