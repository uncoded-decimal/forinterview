import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:forinterview/models/player_model.dart';
import 'package:rxdart/subjects.dart';
import 'dart:math' show Random;

enum DiceState {
  rest,
  rolling,
}

class GameBloc {
  int diceValue = 6;
  final BehaviorSubject<DiceState> _diceSubject =
      BehaviorSubject.seeded(DiceState.rest);
  Stream<DiceState> get dice => _diceSubject.stream;

  final BehaviorSubject<List<PlayerModel>> _leaderboardSubject =
      BehaviorSubject();
  Stream<List<PlayerModel>> get leaderboards => _leaderboardSubject.stream;

  final BehaviorSubject<List<int>> _scoreSubject = BehaviorSubject.seeded([]);
  Stream<List<int>> get score => _scoreSubject.stream;

  void setupLeaderboards() async {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('leaderboards').onValue.listen((event) {
      List<PlayerModel> players = [];
      if (event.snapshot.value != null) {
        final v = event.snapshot.value as Map;
        for (var player in v.entries) {
          players.add(PlayerModel.fromMap(player));
        }
      }
      _leaderboardSubject.sink.add(players);
    });
  }

  void setupPlayerData() async {
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('leaderboards').child(user.uid).onValue.listen((event) {
      final localscore = <int>[];
      if (event.snapshot.value == null) {
      } else {
        List<Object?> state = event.snapshot.value;
        for (var element in state) {
          if (element != null) {
            localscore.add(element as int);
          }
        }
      }
      _scoreSubject.sink.add(localscore);
    });
  }

  void rollDice() async {
    _diceSubject.sink.add(DiceState.rolling);
    final user = FirebaseAuth.instance.currentUser!;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    diceValue = Random().nextInt(6) + 1;
    await Future.delayed(const Duration(seconds: 3));
    _diceSubject.sink.add(DiceState.rest);
    ref.child('leaderboards').child(user.uid).update(
      {
        "${_scoreSubject.value.length}": diceValue,
      },
    );
  }

  void dispose() {
    _diceSubject.close();
    _scoreSubject.close();
    _leaderboardSubject.close();
  }
}
