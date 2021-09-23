class PlayerModel {
  final String email;
  final int score;

  PlayerModel({
    required this.email,
    required this.score,
  });

  static PlayerModel fromMap(MapEntry e) {
    int sum = 0;
    final values = e.value;
    for (var v in values) {
      sum = sum + v as int;
    }
    return PlayerModel(
      email: e.key,
      score: sum,
    );
  }
}
