import 'dart:convert';
import 'package:companion/app/app.locator.dart';
import 'package:companion/model/session_conversations.dart';
import 'package:companion/services/database_service.dart';
import 'package:flutter/services.dart';

class BibleDataService {
  final _databaseService = locator<DatabaseService>();

  Map<String, dynamic> _bibleData = {};

  Future<Map<String, dynamic>?> readJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/app_bible.json');
      _bibleData = await jsonDecode(response);
      return _bibleData;
    } catch (e) {
      return null;
    }
  }

  List<String> getBooks() {
    return _bibleData['books']
        .map((book) => book['name'])
        .whereType<String>()
        .toList();
  }

  List<int> getChapters(String bookName) {
    final book =
        _bibleData['books'].firstWhere((book) => book['name'] == bookName);
    return book['chapters']
        .map((chapter) => chapter['number'])
        .whereType<int>()
        .toList();
  }

  List<int> getVerses(String bookName, int chapterNumber) {
    final book =
        _bibleData['books'].firstWhere((book) => book['name'] == bookName);
    final chapter = book['chapters']
        .firstWhere((chapter) => chapter['number'] == chapterNumber);
    return chapter['verses'].cast<int>();
  }

  List<String> getVersions() {
    return _bibleData['versions']
        .map((version) => version['label'])
        .whereType<String>()
        .toList();
  }

  List<String> getLanguages() {
    return _bibleData['languages']
        .map((language) => language)
        .whereType<String>()
        .toList();
  }

  Map<String, dynamic>? getNextVerse(
      String? bookName, int? chapterNumber, int? verseNumber) {
    final bookIndex =
        _bibleData['books'].indexWhere((book) => book['name'] == bookName);
    if (bookIndex == -1) return null;

    final book = _bibleData['books'][bookIndex];
    final chapterIndex = book['chapters']
        .indexWhere((chapter) => chapter['number'] == chapterNumber);
    if (chapterIndex == -1) return null;

    final chapter = book['chapters'][chapterIndex];
    final verseIndex =
        chapter['verses'].indexWhere((verse) => verse == verseNumber);
    if (verseIndex == -1) return null;

    // Move to the next verse
    if (verseIndex + 1 < chapter['verses'].length) {
      return {
        'book': bookName,
        'chapter': chapterNumber,
        'verse': chapter['verses'][verseIndex + 1]
      };
    } else if (chapterIndex + 1 < book['chapters'].length) {
      // Move to the first verse of the next chapter
      return {
        'book': bookName,
        'chapter': book['chapters'][chapterIndex + 1]['number'],
        'verse': 1
      };
    } else if (bookIndex + 1 < _bibleData['books'].length) {
      // Move to the first verse of the first chapter of the next book
      final nextBook = _bibleData['books'][bookIndex + 1];
      return {
        'book': nextBook['name'],
        'chapter': nextBook['chapters'][0]['number'],
        'verse': 1
      };
    }
    return null;
  }

  Map<String, dynamic>? getPreviousVerse(
      String bookName, int chapterNumber, int verseNumber) {
    final bookIndex =
        _bibleData['books'].indexWhere((book) => book['name'] == bookName);
    if (bookIndex == -1) return null;

    final book = _bibleData['books'][bookIndex];
    final chapterIndex = book['chapters']
        .indexWhere((chapter) => chapter['number'] == chapterNumber);
    if (chapterIndex == -1) return null;

    final chapter = book['chapters'][chapterIndex];
    final verseIndex =
        chapter['verses'].indexWhere((verse) => verse == verseNumber);
    if (verseIndex == -1) return null;

    // Move to the previous verse
    if (verseIndex > 0) {
      return {
        'book': bookName,
        'chapter': chapterNumber,
        'verse': chapter['verses'][verseIndex - 1]
      };
    } else if (chapterIndex > 0) {
      // Move to the last verse of the previous chapter
      final prevChapter = book['chapters'][chapterIndex - 1];
      return {
        'book': bookName,
        'chapter': prevChapter['number'],
        'verse': prevChapter['verses'].last
      };
    } else if (bookIndex > 0) {
      // Move to the last verse of the last chapter of the previous book
      final prevBook = _bibleData['books'][bookIndex - 1];
      final lastChapter = prevBook['chapters'].last;
      return {
        'book': prevBook['name'],
        'chapter': lastChapter['number'],
        'verse': lastChapter['verses'].last
      };
    }
    return null;
  }

  Future<List<SessionConversations>?> getAllSessionsWithConversations() async {
    return await _databaseService.fetchAllSessionsWithConversations();
  }
}
