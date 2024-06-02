class Session {
  String? sessionId;
  String? conversationId;
  String? title;
  String? book;
  int? chapter;
  int? verse;
  String? translation;
  String? language;
  DateTime? timestamp;

  Session({
    this.sessionId,
    this.conversationId,
    this.title,
    this.book,
    this.chapter,
    this.verse,
    this.translation,
    this.language,
    this.timestamp,
  });

  Session.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    conversationId = json['conversationId'];
    title = json['title'];
    book = json['book'];
    chapter = json['chapter'];
    verse = json['verse'];
    translation = json['translation'];
    language = json['language'];
    timestamp = DateTime.parse(json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionId'] = sessionId;
    data['conversationId'] = conversationId;
    data['title'] = title;
    data['book'] = book;
    data['chapter'] = chapter;
    data['verse'] = verse;
    data['translation'] = translation;
    data['language'] = language;
    data['timestamp'] = timestamp?.toIso8601String();
    return data;
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      sessionId: map['sessionId'],
      conversationId: map['conversationId'],
      title: map['title'],
      book: map['book'],
      chapter: map['chapter'],
      verse: map['verse'],
      translation: map['translation'],
      language: map['language'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'conversationId': conversationId,
      'title': title,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'translation': translation,
      'language': language,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
