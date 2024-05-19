class Session {
  String? sessionId;
  String? conversationId;
  String? title;
  DateTime? timestamp;

  Session({
    this.sessionId,
    this.conversationId,
    this.title,
    this.timestamp,
  });

  Session.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    conversationId = json['conversationId'];
    title = json['title'];
    timestamp = DateTime.parse(json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionId'] = sessionId;
    data['conversationId'] = conversationId;
    data['title'] = title;
    data['timestamp'] = timestamp?.toIso8601String();
    return data;
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      sessionId: map['sessionId'],
      conversationId: map['conversationId'],
      title: map['title'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'conversationId': conversationId,
      'title': title,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
