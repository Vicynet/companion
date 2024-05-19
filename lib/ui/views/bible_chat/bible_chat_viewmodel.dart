import 'package:companion/app/app.dialogs.dart';
import 'package:companion/app/app.locator.dart';
import 'package:companion/app/app.logger.dart';
import 'package:companion/app/app.router.dart';
import 'package:companion/enums/role_type.dart';
import 'package:companion/model/bible_query.dart';
import 'package:companion/model/conversation.dart';
import 'package:companion/model/session_conversations.dart';
import 'package:companion/services/bible_data_service.dart';
import 'package:companion/services/gemini_service.dart';
import 'package:companion/ui/views/components/chat_box_component.form.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BibleChatViewModel extends FormViewModel {
  final _geminiService = locator<GeminiService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _bibleDataService = locator<BibleDataService>();
  final _logger = getLogger('BibleChatViewModel');

  SessionConversations? get sessionConversation => _sessionConversations;
  static SessionConversations? _sessionConversations;

  List<SessionConversations>? get allSessionsWithConversations =>
      _allSessionsWithConversations;
  static List<SessionConversations>? _allSessionsWithConversations = [];

  List<String> get books => _books;
  List<String> _books = [];

  int get historyIndex => _historyIndex;
  final int _historyIndex = -1;

  String get text => _text;
  final String _text = '';

  Future<void> bibleChat(BibleQuery bibleQuery) async {
    setBusy(true);
    _sessionConversations = await _geminiService.bibleAIChat(bibleQuery);
    // await fetchLocalSessionsWithConversations();
    setBusy(false);
  }

  Future<void> fetchLocalSessionsWithConversations() async {
    setBusy(true);
    _allSessionsWithConversations =
        await _geminiService.getAllSessionsWithConversations();
    rebuildUi();
    setBusy(false);
  }

  Future<void> fetchLocalConversationsById(String conversationId) async {
    _sessionConversations =
        await _geminiService.getConversations(conversationId);
    rebuildUi();
  }

  void fetchBibleBooks() {
    _books = _bibleDataService.getBooks();
    _logger.i(_books);
    rebuildUi();
  }

  Future<void> continousBibleChat() async {
    _logger.i(queryInputValue);
    newChatConversation();
    navigateToChat();
    rebuildUi();
    _sessionConversations = await _geminiService.continousAIConversation(
        queryInputValue!.trim(),
        _sessionConversations!.session!.sessionId!,
        _sessionConversations!.session!.conversationId!);
    rebuildUi();
    navigateToChat();
  }

  void newChatConversation() {
    List<Conversation> newConversation = [];
    newConversation = [
      ...newConversation,
      Conversation(
          conversationId: _sessionConversations!.session!.conversationId!,
          role: RoleType.user.name,
          message: queryInputValue!.trim(),
          timestamp: DateTime.now()),
      Conversation(
          conversationId: _sessionConversations!.session!.conversationId!,
          role: RoleType.companion.name,
          message: 'responding...',
          timestamp: DateTime.now())
    ];
    for (var conversation in newConversation) {
      _sessionConversations!.conversations!.add(conversation);
      rebuildUi();
    }
  }

  void showHistoryDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.chatHistory,
    );
  }

  void showBibleBookDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.bibleData,
    );
  }

  void navigateToChat() {
    _navigationService.clearStackAndShow(Routes.bibleChatView);
    rebuildUi();
  }

  void navigateBack() {
    _navigationService.back();
    rebuildUi();
  }

  void navigateToHome() {
    fetchBibleBooks();
    _logger.i(_books);
    _navigationService.navigateToHomeView(books: _books);
    rebuildUi();
  }

  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void shareText(String text, String title) {
    Share.share(text, subject: title);
  }
}
