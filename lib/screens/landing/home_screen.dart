import 'package:flutter/material.dart';
import 'package:forinterview/controllers/auth_controller.dart';
import 'package:forinterview/controllers/game_controller.dart';
import 'package:forinterview/screens/widgets/default_loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GameBloc _gameBloc;

  @override
  void initState() {
    super.initState();
    _gameBloc = GameBloc()
      ..setupLeaderboards()
      ..setupPlayerData()
      ..dice.listen((event) {
        print("dice state $event");
      });
  }

  @override
  void dispose() {
    _gameBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              AuthBloc().logout();
            },
            icon: const Icon(
              Icons.logout_outlined,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _scoreCard(),
          _diceWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _gameBloc.rollDice();
        },
      ),
    );
  }

  Widget _scoreCard() => StreamBuilder<List<int>>(
        stream: _gameBloc.score,
        builder: (context, snapshot) {
          if (snapshot.data == null) return const SizedBox.shrink();

          int total = 0;
          for (var attempt in snapshot.data!) {
            total = total + attempt;
          }
          String score = snapshot.data!.join(" + ");
          return Card(
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(score),
                  const Divider(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Your Score = $total",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Attempts remaining = ${10 - snapshot.data!.length}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget _diceWidget() => StreamBuilder<DiceState>(
        stream: GameBloc().dice,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox.shrink();
          }
          return Container(
            width: 150,
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.black,
                width: 5,
              ),
            ),
            child: snapshot.data! == DiceState.rolling
                ? const DefaultLoader()
                : Text("${snapshot.data}"),
          );
        },
      );
}
