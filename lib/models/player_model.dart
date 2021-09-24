import 'package:firebase_auth/firebase_auth.dart';

class PlayerModel {
  final String email;
  final int score;

  PlayerModel({
    required this.email,
    required this.score,
  });

  static PlayerModel fromMap(MapEntry e, User user) {
    int sum = 0;
    final values = e.value;
    for (var v in values) {
      sum = sum + v as int;
    }
    final name = user.uid == e.key ? "YOU" : e.key;
    return PlayerModel(
      email: name,
      score: sum,
    );
  }
}
