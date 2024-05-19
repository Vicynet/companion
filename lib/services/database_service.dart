import 'package:companion/app/app.locator.dart';
import 'package:companion/app/app.logger.dart';
import 'package:companion/model/conversation.dart';
import 'package:companion/model/session.dart';
import 'package:companion/model/session_conversations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

class DatabaseService {
  final _logger = getLogger('DatabaseService');
  final _databaseMigrationService = locator<DatabaseMigrationService>();

  late final Database _database;
  final String _sessionTable = 'session';
  final String _conversationTable = 'conversation';

  Future<void> init() async {
    _logger.i('Initializing database');
    final directory = await getApplicationDocumentsDirectory();
    _database = await openDatabase(
      '${directory.path}/bible_chat',
      version: 1,
    );
    try {
      _logger.i('Creating database tables');
      // Apply migration on every start
      await _databaseMigrationService.runMigration(
        _database,
        migrationFiles: [
          '1_bible_chat.sql',
        ],
        verbose: true,
      );
      _logger.i('Database tables created');
    } catch (e, s) {
      _logger.v('Error creating database tables', e, s);
    }
  }

  Future<void> createConversation(Conversation conversation) async {
    _logger.i('storing conversation data');
    try {
      await _database.insert(
        _conversationTable,
        conversation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      _logger.i('Conversation data stored');
    } catch (e) {
      _logger.e('error trying to store a conversation data');
    }
  }

  Future<void> createSession(Session session) async {
    _logger.i('storing session data');
    try {
      await _database.insert(
        _sessionTable,
        session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      _logger.i('Session data stored');
    } catch (e) {
      _logger.e('error trying to store a session data');
    }
  }

  Future<SessionConversations?> fetchConversationsById(
      String conversationId) async {
    _logger.i(conversationId);

    try {
      final session = await _database.query(
        _sessionTable,
        where: 'conversationId = ?',
        whereArgs: [conversationId],
      );

      if (session.isEmpty) {
        _logger.e('No record found');
        return null;
      }
      _logger.i(session);

      _logger.i('session data found');

      final currentSession = Session.fromJson(session.first);
      _logger.i(currentSession);

      final conversations = await _database.query(
        _conversationTable,
        where: 'conversationId = ?',
        whereArgs: [conversationId],
      );
      _logger.i(conversations);

      final allConversations =
          conversations.map((map) => Conversation.fromJson(map)).toList();

      _logger.i('All Conversations $conversations');

      _logger.i('Conversations data fetched');
      return SessionConversations(
          session: currentSession, conversations: allConversations);
    } catch (e) {
      _logger.e('error getting conversation data', e);
      return null;
    }
  }

  Future<List<SessionConversations>> fetchAllSessionsWithConversations() async {
    try {
      final List<SessionConversations> sessionsWithConversations = [];
      _logger.i('Fetching all sessions');

      // Query all sessions
      final List<Map<String, dynamic>> sessions =
          await _database.query(_sessionTable);

      _logger.i('Sessions found $sessions');

      // Iterate over each session
      for (final session in sessions) {
        final Session currentSession = Session.fromJson(session);
        _logger.i('Current session conversations $currentSession');

        _logger.i('Current session toString ${currentSession.toString()}');

        // Query conversations for the current session
        final List<Map<String, dynamic>> conversations = await _database.query(
          _conversationTable,
          where: 'conversationId = ?',
          whereArgs: [currentSession.conversationId],
        );
        _logger.i('Current session db conversations $conversations');
        _logger.i(
            'Current session db conversations toString ${conversations.toString()}');

        // Add conversations to the session
        var currentConversations = conversations
            .map((conversationMap) => Conversation.fromJson(conversationMap))
            .toList();

        _logger.i('Current session json conversations $currentConversations');
        _logger.i(
            'Current session db conversations json toString ${currentConversations.toString()}');

        var sessionWithConversation = SessionConversations(
            session: currentSession, conversations: currentConversations);

        sessionsWithConversations.add(sessionWithConversation);
      }
      _logger.i('All SessionsWithConversations $sessionsWithConversations');

      return sessionsWithConversations;
    } catch (e) {
      _logger.e('Error fetching sessions with conversations: $e');
      return [];
    }
  }

  Future<SessionConversations?> updateOrAddConversation(
      String sessionId, List<Conversation> conversations) async {
    try {
      final session = await _database.query(
        _sessionTable,
        where: 'sessionId = ?',
        whereArgs: [sessionId],
      );

      if (session.isEmpty) {
        _logger.i('Session not found');
        return null;
      }

      final currentSession = Session.fromJson(session.first);
          _logger.i('Current session ${currentSession.title}');

      for (var conversation in conversations) {
        if (currentSession.conversationId == conversation.conversationId) {
          await _database.insert(
            _conversationTable,
            conversation.toMap(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
          _logger.i('New Conversation data stored $conversation');
          _logger.i('New Conversation data stored ${conversation.message}');
        }
      }
      _logger.i('Conversation added successfully.');
      return fetchConversationsById(currentSession.conversationId!);
    } catch (e) {
      _logger.e('Error updating or adding conversation: $e');
      return null;
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      await _database.delete(
        _conversationTable,
        where: 'conversationId = ?',
        whereArgs: [conversationId],
      );
      _logger.i('Conversation deleted successfully');
      await _database.delete(
        'sessions',
        where: 'conversationId = ?',
        whereArgs: [conversationId],
      );
      _logger.i('Sessiomn deleted successfully');
    } catch (e) {
      _logger.e('Error deleting conversation: $e');
    }
  }
}
