import 'package:companion/model/session_conversations.dart';

class Sessions {
  List<SessionConversations>? sessions;

  Sessions({
    this.sessions,
  });

  Sessions.fromJson(Map<String, dynamic> json) {
    if (json['sessions'] != null) {
      sessions = <SessionConversations>[];
      json['conversations'].forEach((v) {
        sessions!.add(SessionConversations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sessions != null) {
      data['sessions'] =
          sessions!.map((sessions) => sessions.toJson()).toList();
    }
    return data;
  }

  factory Sessions.fromMap(Map<String, dynamic> map) {
    return Sessions(
      sessions: List<SessionConversations>.from(map['sessions']
          ?.map((sessions) => SessionConversations.fromMap(sessions))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessions': sessions?.map((sessions) => sessions.toMap()).toList(),
    };
  }
}
