class Conversation {
  int? id;
  String? conversationId;
  String? role;
  String? message;
  DateTime? timestamp;

  Conversation({
    this.id,
    this.conversationId,
    this.role,
    this.message,
    this.timestamp,
  });

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversationId'];
    role = json['role'];
    message = json['message'];
    timestamp = DateTime.parse(json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['conversationId'] = conversationId;
    data['role'] = role;
    data['message'] = message;
    data['timestamp'] = timestamp?.toIso8601String();
    return data;
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'],
      conversationId: map['conversationId'],
      role: map['role'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'role': role,
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
