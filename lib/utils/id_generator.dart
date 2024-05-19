import 'dart:math';

class IdGenerator {
  String generateSessionId() {
    const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    var code = "";

    for (var i = 0; i < 16; i++) {
      final randomIndex = Random().nextInt(characters.length);
      code += characters[randomIndex];
    }
    return 'ss-$code';
  }

  String generateConversationId() {
    const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    var code = "";

    for (var i = 0; i < 8; i++) {
      final randomIndex = Random().nextInt(characters.length);
      code += characters[randomIndex];
    }
    return 'cvs-$code';
  }
}
