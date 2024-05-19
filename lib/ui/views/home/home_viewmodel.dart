import 'package:companion/app/app.bottomsheets.dart';
import 'package:companion/app/app.dialogs.dart';
import 'package:companion/app/app.locator.dart';
import 'package:companion/app/app.logger.dart';
import 'package:companion/model/bible_query.dart';
import 'package:companion/model/session_conversations.dart';
import 'package:companion/services/bible_data_service.dart';
import 'package:companion/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _bibleDataService = locator<BibleDataService>();
  final _navigationService = locator<NavigationService>();
  final _logger = getLogger('HomeViewModel');



  int get bookIndex => _bookIndex;
  int get chapterIndex => _chapterIndex;
  int get verseIndex => _verseIndex;
  int get translationIndex => _translationIndex;
  int get languageIndex => _languageIndex;

  List<String> get books => _books;
  List<String> _books = [];

  List<int> get chapters => _chapters;
  List<int> _chapters = [];

  List<int> get verses => _verses;
  List<int> _verses = [];

  List<String> get versions => _versions;
  List<String> _versions = [];

  List<String> get languages => _languages;
  List<String> _languages = [];

  String get book => _book;
  int? get chapter => _chapter;
  int? get verse => _verse;
  String get transalation => _translation;
  String get language => _language;

  static int _bookIndex = -1;
  int _chapterIndex = -1;
  int _verseIndex = -1;
  int _translationIndex = -1;
  int _languageIndex = -1;

  static String _book = '';
  static int? _chapter;
  static int? _verse;
  static String _translation = '';
  static String _language = '';

  List<SessionConversations>? get allSessionsWithConversations =>
      _allSessionsWithConversations;
  static List<SessionConversations>? _allSessionsWithConversations = [];

  Future<void> fetchLocalSessionsWithConversations() async {
    _allSessionsWithConversations =
        await _bibleDataService.getAllSessionsWithConversations();
    rebuildUi();
  }

  void fetchBibleBooks() {
    setBusy(true);
    _books = _bibleDataService.getBooks();
    _logger.i(_books);
    setBusy(false);

    rebuildUi();
  }

  void selectBook(int index, String book) {
    _book = book;
    _bookIndex = index;
    rebuildUi();
    _chapters = _bibleDataService.getChapters(book);
    showBibleBottomSheet(_chapters, book);
  }

  void selectChapter(int index, String book) {
    _chapterIndex = index;
    var chapter = index + 1;
    _chapter = chapter;
    rebuildUi();
    _verses = _bibleDataService.getVerses(book, chapter);
    rebuildUi();
  }

  void selectVerse(int index) {
    _verseIndex = index;
    _verse = index + 1;
    rebuildUi();
    _versions = _bibleDataService.getVersions();
  }

  void selectVersion(int index, String translation) {
    _translationIndex = index;
    _translation = translation;
    rebuildUi();
    _languages = _bibleDataService.getLanguages();
  }

  void selectLanguage(int index, String language) {
    _languageIndex = index;
    _language = language;
    showSummaryDialog();
  }

  void showBibleBottomSheet(List<int> chapters, String book) {
    _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.bible,
        title: book,
        description: ksHomeBottomSheetDescription,
        isScrollControlled: true,
        ignoreSafeArea: false,
        data: chapters);
  }

  void showSummaryDialog() {
    var bibleQuery = BibleQuery(
      book: _book,
      chapter: _chapter,
      verse: _verse,
      translation: _translation,
      language: _language,
    );
    _dialogService.showCustomDialog(
        variant: DialogType.summary, data: bibleQuery);
  }

  void showHistoryDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.chatHistory,
    );
  }

  void navigateBack() {
    _navigationService.back();
    rebuildUi();
  }

  void back() {
    if (_languageIndex > -1) {
      _languageIndex = -1;
    } else if (_translationIndex > -1) {
      _translationIndex = -1;
    } else if (_verseIndex > -1) {
      _verseIndex = -1;
    } else if (_chapterIndex > -1) {
      _chapterIndex = -1;
    }
    rebuildUi();
  }
}
