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

  Future<List<SessionConversations>?> getAllSessionsWithConversations() async {
    var allSessionsWithConversations =
        await _databaseService.fetchAllSessionsWithConversations();
    return allSessionsWithConversations;
  }
}
