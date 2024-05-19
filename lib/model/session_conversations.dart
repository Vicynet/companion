import 'package:companion/model/conversation.dart';
import 'package:companion/model/session.dart';

class SessionConversations {
  Session? session;
  List<Conversation>? conversations;

  SessionConversations({
    this.session,
    this.conversations,
  });

  SessionConversations.fromJson(Map<String, dynamic> json) {
    session = json['session'];
    if (json['conversations'] != null) {
      conversations = <Conversation>[];
      json['conversations'].forEach((v) {
        conversations!.add(Conversation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session'] = session;
    if (conversations != null) {
      data['conversations'] =
          conversations!.map((conversation) => conversation.toJson()).toList();
    }
    return data;
  }

  factory SessionConversations.fromMap(Map<String, dynamic> map) {
    return SessionConversations(
      session: map['session'],
      conversations: List<Conversation>.from(map['conversations']
          ?.map((conversation) => Conversation.fromMap(conversation))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'session': session,
      'conversations':
          conversations?.map((conversation) => conversation.toMap()).toList(),
    };
  }
}
