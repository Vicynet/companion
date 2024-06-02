import 'package:companion/app/app.dialogs.dart';
import 'package:companion/app/app.locator.dart';
import 'package:companion/app/app.logger.dart';
import 'package:companion/app/app.router.dart';
import 'package:companion/enums/role_type.dart';
import 'package:companion/model/bible_query.dart';
import 'package:companion/model/conversation.dart';
import 'package:companion/model/scripture.dart';
import 'package:companion/model/session_conversations.dart';
import 'package:companion/services/bible_data_service.dart';
import 'package:companion/services/database_service.dart';
import 'package:companion/services/gemini_service.dart';
import 'package:companion/ui/views/components/chat_box_component.form.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BibleChatViewModel extends FormViewModel {
  final _geminiService = locator<GeminiService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _bibleDataService = locator<BibleDataService>();
  final _logger = getLogger('BibleChatViewModel');
  final _databaseService = locator<DatabaseService>();
  final flutterTts = FlutterTts();

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

  bool get showNextVerse => _showNextVerse;
  bool _showNextVerse = false;

  bool get showPreviousVerse => _showPreviousVerse;
  bool _showPreviousVerse = false;

  bool get isPlaying => _isPlaying;
  bool _isPlaying = false;

  Future<void> bibleChat(BibleQuery bibleQuery) async {
    setBusy(true);
    try {
      _logger.i('New Bible Query ${bibleQuery.book}');
      _sessionConversations = await _geminiService.bibleAIChat(bibleQuery);
      if (_sessionConversations == null) {
        _dialogService.showDialog(
          description: "Error connecting to Gemini AI",
        );
      } else {
        navigateToChat();
      }
      // await fetchLocalSessionsWithConversations();
      setBusy(false);
    } catch (e) {
      setBusy(false);
      _dialogService.showDialog(
        description: "Error fetching conversations",
      );
    }
  }

  Future<void> traverseBibleChat(BibleQuery? bibleQuery) async {
    _logger.i('Traverse Bible Query ${bibleQuery?.verse}');
    setBusy(true);
    try {
      if (bibleQuery == null) {
        _dialogService.showDialog(
          description: "Error getting verse",
        );
      } else {
        _sessionConversations = await _geminiService.bibleAIChat(bibleQuery);
        if (_sessionConversations == null) {
          _dialogService.showDialog(
            description: "Error connecting to Gemini AI",
          );
        } else {
          rebuildUi();
        }
      }
      setBusy(false);
    } catch (e) {
      setBusy(false);
      _dialogService.showDialog(
        description: "Error fetching conversations",
      );
    }
  }

  Future<void> fetchLocalSessionsWithConversations() async {
    setBusy(true);
    try {
      _allSessionsWithConversations =
          await _geminiService.getAllSessionsWithConversations();
      rebuildUi();
      setBusy(false);
    } catch (e) {
      setBusy(false);
      _dialogService.showDialog(
        description: "Error fetching history",
      );
    }
  }

  Future<void> fetchLocalConversationsById(String conversationId) async {
    try {
      _sessionConversations =
          await _geminiService.getConversations(conversationId);
      rebuildUi();
    } catch (e) {
      _dialogService.showDialog(
        description: "Error fetching conversations",
      );
    }
  }

  void fetchBibleBooks() {
    try {
      _books = _bibleDataService.getBooks();
      _logger.i(_books);
      rebuildUi();
    } catch (e) {
      _dialogService.showDialog(
        description: "Error fetching books",
      );
    }
  }

  // void nextVerse() async {
  //   try {
  //     _showNextVerse = true;
  //     setBusy(true);
  //     var scripture = Scripture(
  //         book: _sessionConversations?.session?.book,
  //         chapter: _sessionConversations?.session?.chapter,
  //         verse: _sessionConversations?.session?.verse,
  //         translation: _sessionConversations?.session?.translation,
  //         language: _sessionConversations?.session?.language);
  //     _databaseService.compareScripture(scripture).then((value) async {
  //       if (value.isNotEmpty) {
  //         fetchLocalConversationsById(value);
  //       } else {
  //         _logger.i(
  //             'Next verse Current verse ${_sessionConversations!.session!.verse}');
  //         final nextVerse = _bibleDataService.getNextVerse(
  //             _sessionConversations?.session?.book,
  //             _sessionConversations?.session?.chapter,
  //             _sessionConversations?.session?.verse);
  //         if (nextVerse != null) {
  //           _logger.i("nextVerse $nextVerse");
  //           final newBibleQuery = BibleQuery(
  //               book: nextVerse['book'],
  //               chapter: nextVerse['chapter'],
  //               verse: nextVerse['verse'],
  //               translation: _sessionConversations!.session!.translation,
  //               language: _sessionConversations!.session!.language);
  //           // _bibleQuery = newBibleQuery;
  //           _logger.i('Loaded Bible Query ${newBibleQuery.verse!}');
  //           await traverseBibleChat(newBibleQuery);
  //           _showNextVerse = false;
  //           setBusy(false);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     _showNextVerse = false;
  //     setBusy(false);
  //     _dialogService.showDialog(
  //       description: "Error getting next verse",
  //     );
  //   }
  // }

  // void previousVerse() async {
  //   try {
  //     _showPreviousVerse = true;
  //     setBusy(true);
  //     var scripture = Scripture(
  //         book: _sessionConversations?.session?.book,
  //         chapter: _sessionConversations?.session?.chapter,
  //         verse: _sessionConversations?.session?.verse,
  //         translation: _sessionConversations?.session?.translation,
  //         language: _sessionConversations?.session?.language);

  //     _databaseService.compareScripture(scripture).then((value) async {
  //       if (value.isNotEmpty) {
  //         fetchLocalConversationsById(value);
  //       } else {
  //         _logger.i(
  //             'Previous verse Current verse ${_sessionConversations!.session!.verse}');
  //         final previousVerse = _bibleDataService.getPreviousVerse(
  //             _sessionConversations!.session!.book!,
  //             _sessionConversations!.session!.chapter!,
  //             _sessionConversations!.session!.verse!);
  //         if (previousVerse != null) {
  //           _logger.i("previousVerse $previousVerse");
  //           final newBibleQuery = BibleQuery(
  //               book: previousVerse['book'],
  //               chapter: previousVerse['chapter'],
  //               verse: previousVerse['verse'],
  //               translation: _sessionConversations!.session!.translation,
  //               language: _sessionConversations!.session!.language);
  //           // _bibleQuery = newBibleQuery;
  //           await traverseBibleChat(newBibleQuery);
  //           _showPreviousVerse = false;
  //           setBusy(false);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     _showPreviousVerse = false;
  //     setBusy(false);
  //     _dialogService.showDialog(
  //       description: "Error getting previous verse",
  //     );
  //   }
  // }

  Future<void> processVerse({
    required Function getVerse,
    required Function fetchLocalConversationsById,
    required Function traverseBibleChat,
    required bool isNextVerse,
  }) async {
    try {
      if (isNextVerse) {
        _showNextVerse = true;
      } else {
        _showPreviousVerse = true;
      }
      setBusy(true);

      var scripture = Scripture(
        book: _sessionConversations?.session?.book,
        chapter: _sessionConversations?.session?.chapter,
        verse: _sessionConversations?.session?.verse,
        translation: _sessionConversations?.session?.translation,
        language: _sessionConversations?.session?.language,
      );

      final value = await _databaseService.compareScripture(scripture);
      if (value.isNotEmpty) {
        await fetchLocalConversationsById(value);
      } else {
        _logger.i(
            '${isNextVerse ? 'Next' : 'Previous'} verse Current verse ${_sessionConversations!.session!.verse}');
        final verse = getVerse(
          _sessionConversations!.session!.book!,
          _sessionConversations!.session!.chapter!,
          _sessionConversations!.session!.verse!,
        );
        if (verse != null) {
          _logger.i("${isNextVerse ? 'nextVerse' : 'previousVerse'} $verse");
          final newBibleQuery = BibleQuery(
            book: verse['book'],
            chapter: verse['chapter'],
            verse: verse['verse'],
            translation: _sessionConversations!.session!.translation,
            language: _sessionConversations!.session!.language,
          );
          _logger.i('Loaded Bible Query ${newBibleQuery.verse!}');
          await traverseBibleChat(newBibleQuery);
          if (isNextVerse) {
            _showNextVerse = false;
          } else {
            _showPreviousVerse = false;
          }
          setBusy(false);
        }
      }
    } catch (e) {
      if (isNextVerse) {
        _showNextVerse = false;
      } else {
        _showPreviousVerse = false;
      }
      setBusy(false);
      _dialogService.showDialog(
        description: "Error getting ${isNextVerse ? 'next' : 'previous'} verse",
      );
    }
  }

  void nextVerse() async {
    await processVerse(
      getVerse: _bibleDataService.getNextVerse,
      fetchLocalConversationsById: fetchLocalConversationsById,
      traverseBibleChat: traverseBibleChat,
      isNextVerse: true,
    );
  }

  void previousVerse() async {
    await processVerse(
      getVerse: _bibleDataService.getPreviousVerse,
      fetchLocalConversationsById: fetchLocalConversationsById,
      traverseBibleChat: traverseBibleChat,
      isNextVerse: false,
    );
  }

  Future<void> continousBibleChat() async {
    _logger.i(queryInputValue);
    newChatConversation();
    navigateToChat();
    rebuildUi();
    try {
      _sessionConversations = await _geminiService.continousAIConversation(
          queryInputValue!.trim(),
          _sessionConversations!.session!.sessionId!,
          _sessionConversations!.session!.conversationId!);
      rebuildUi();
      navigateToChat();
    } catch (e) {
      _dialogService.showDialog(
        description: "Error with Gemini AI",
      );
    }
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
    // rebuildUi();
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

  void startPlayback(String text) async {
    _isPlaying = true;
    rebuildUi();
    await flutterTts.speak(text).whenComplete(() async {
      await flutterTts.awaitSpeakCompletion(true).then((value) {
        _isPlaying = false;
        rebuildUi();
      });
    });
  }

  void pausePlayback() {
    flutterTts.pause();
    _isPlaying = false;
    rebuildUi();
  }

  void stopPlayback() {
    flutterTts.stop();
    _isPlaying = false;
    rebuildUi();
  }

  void onTtsComplete() {
    _isPlaying = false;
    rebuildUi();
  }
}
