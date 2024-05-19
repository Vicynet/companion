import 'package:companion/app/app.locator.dart';
import 'package:companion/app/app.logger.dart';
import 'package:companion/enums/role_type.dart';
import 'package:companion/exceptions/companion_exceptions.dart';
import 'package:companion/model/bible_query.dart';
import 'package:companion/model/conversation.dart';
import 'package:companion/model/session.dart';
import 'package:companion/model/session_conversations.dart';
import 'package:companion/services/database_service.dart';
import 'package:companion/utils/id_generator.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final _databaseService = locator<DatabaseService>();
  final _logger = getLogger('GeminiService');
  String _firstUserQuery = '';
  String _firstCompanionResponse = '';
  String _secondUserQuery = '';
  String _conversationId = '';
  String _sessionId = '';
  List<Conversation> _starterConversations = [];
  static ChatSession? openChatSession;
  static GenerativeModel? openModel;

  GenerativeModel initializeAIModel() {
    const apiKey = 'GEMINI_AI_API_KEY';
    openModel ??= GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
        generationConfig: GenerationConfig(maxOutputTokens: 1000));
    return openModel!;
  }

  ChatSession initializeAIChatSession(
      String userQuery, String companionResponse) {
    ChatSession newChatSession = initializeAIModel().startChat(history: [
      Content.text(userQuery),
      Content.model([TextPart(companionResponse)])
    ]);
    openChatSession = newChatSession;
    return newChatSession;
  }

  Future<SessionConversations?> bibleAIChat(BibleQuery bibleQuery) async {
    _firstUserQuery =
        'Hello Companion, let\'s explore ${bibleQuery.book} ${bibleQuery.chapter}:${bibleQuery.verse}';
    _firstCompanionResponse =
        'Alright, let me give you a deeper dive into ${bibleQuery.book} ${bibleQuery.chapter}:${bibleQuery.verse}';
    _secondUserQuery =
        "Analyze ${bibleQuery.book} ${bibleQuery.chapter}:${bibleQuery.verse} using the ${bibleQuery.translation} translation and interpret response entirely in the ${bibleQuery.language} Language. Bible Text: Provide the verse from ${bibleQuery.book} ${bibleQuery.chapter}:${bibleQuery.verse} in the ${bibleQuery.translation} translation. Explanation: Briefly describe the scene or concept depicted in the verse. Theme: Identify a concise 3 or 4 word phrase that captures the Bible passage. Language Analysis: Identify the original language (Hebrew or Greek) of the verse you chose. Word Study: Identify and explain two or four key words in the original language (Hebrew or Greek) and their significance in the context. Include the original Hebrew or Greek word in parenthesis followed by its meaning and explanation, separated by a semicolon. Use the same format for any additional words. Additional Resource: Find only available additional resource or lectures that explores the theme and concept in the Bible passage.";

    final content = Content.text(_secondUserQuery);
    _logger.i('Open chat history ${openChatSession?.history.last.toJson()}');

    try {
      var response = await initializeAIChatSession(
              _firstUserQuery, _firstCompanionResponse)
          .sendMessage(content);
      _logger.v(response.text);

      var newSessionConversation =
          await initializeLocalConversation(response.text!, bibleQuery);

      return newSessionConversation;
    } on CompanionException {
      _logger.e('Error connecting to Gemini AI');
      rethrow;
    } catch (e, s) {
      _logger.e('Error connecting to Gemini AI', e, s);
      return null;
    }
  }

  void initializeLocalSession(String sessionId, String conversationId,
      String title, BibleQuery bibleQuery) async {
    _logger.i('Main text $title');
    var formattedTitle = title.replaceAll(RegExp(r'[*><]'), "").trim();
    _logger.i('Formatted text $formattedTitle');
    var newTitle = extractTheme(formattedTitle);
    _logger.i('Extracted Text $newTitle');
    var session = Session(
        sessionId: sessionId,
        conversationId: conversationId,
        title:
            '$newTitle - ${bibleQuery.book} ${bibleQuery.chapter}:${bibleQuery.verse}',
        timestamp: DateTime.now());
    await _databaseService.createSession(session);
  }

  Future<SessionConversations?> initializeLocalConversation(
      String modelResponse, BibleQuery bibleQuery) async {
    _conversationId = IdGenerator().generateConversationId();
    _sessionId = IdGenerator().generateSessionId();

    _logger.i(_conversationId);
    _logger.i(_sessionId);
    _logger.i('Bible Query $bibleQuery');

    _starterConversations = [
      ..._starterConversations,
      Conversation(
          conversationId: _conversationId,
          role: RoleType.user.name,
          message: _firstUserQuery,
          timestamp: DateTime.now()),
      Conversation(
          conversationId: _conversationId,
          role: RoleType.companion.name,
          message: _firstCompanionResponse,
          timestamp: DateTime.now()),
      Conversation(
          conversationId: _conversationId,
          role: RoleType.companion.name,
          message: modelResponse.replaceAll(RegExp(r'[*><]'), "").trim(),
          timestamp: DateTime.now())
    ];

    initializeLocalSession(
        _sessionId, _conversationId, modelResponse, bibleQuery);

    for (var starterConversation in _starterConversations) {
      _logger.i('Initial Conversation ${starterConversation.conversationId}');

      _logger.i('Initial Conversation $starterConversation');

      await _databaseService.createConversation(starterConversation);
    }
    var newSessionConversion = await getConversations(_conversationId);
    return newSessionConversion;
  }

  Future<SessionConversations?> continousAIConversation(
      String query, String sessionId, String conversationId) async {
            _logger.i('Continous Open chat history ${openChatSession?.history.first.toJson()}');

    final content = Content.text(
        "Query: ($query). NLP: If this query is not Bible or Christian-related, reply with: \"I'm sorry, I can only respond to Bible or Christian-related queries\". Please stay within this restriction, but you can respond to pleasantries e.g Great, Thank youThank ");
    List<Conversation> newConversation = [];
    if (openChatSession != null) {
      var companionResponse = await openChatSession!.sendMessage(content);
      newConversation = [
        ...newConversation,
        Conversation(
            conversationId: conversationId,
            role: RoleType.user.name,
            message: query,
            timestamp: DateTime.now()),
        Conversation(
            conversationId: conversationId,
            role: RoleType.companion.name,
            message:
                companionResponse.text!.replaceAll(RegExp(r'[*><]'), "").trim(),
            timestamp: DateTime.now())
      ];
    }
    _logger.i('New convo $newConversation');
    _logger.i('New convo ${newConversation.first}');

    var sessionWithConversations = await _databaseService
        .updateOrAddConversation(sessionId, newConversation);
    return sessionWithConversations;
  }

  String extractTheme(String response) {
    RegExp regExp = RegExp(r'Theme:\s*\n{1,2}(.+?)\n{1,2}', dotAll: true);
    Match? match = regExp.firstMatch(response);
    return match != null ? match.group(1)!.trim() : "";
  }

  Future<SessionConversations?> getConversations(String conversationId) async {
    _logger.i(conversationId);
    var sessionConversations =
        await _databaseService.fetchConversationsById(conversationId);
    return sessionConversations;
  }

  Future<List<SessionConversations>?> getAllSessionsWithConversations() async {
    var allSessionsWithConversations =
        await _databaseService.fetchAllSessionsWithConversations();
    return allSessionsWithConversations;
  }
}
