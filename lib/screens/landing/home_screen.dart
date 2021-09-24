import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:forinterview/controllers/auth_controller.dart';
import 'package:forinterview/controllers/game_controller.dart';
import 'package:forinterview/models/player_model.dart';
import 'package:forinterview/screens/widgets/error_dialog.dart';
import 'package:get_version/get_version.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late GameBloc _gameBloc;
  late Animation _diceTween;
  late AnimationController _diceAnimation;

  @override
  void initState() {
    super.initState();
    _diceAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _diceAnimation.repeat();
        }
      });
    final Animation<double> curve =
        CurvedAnimation(parent: _diceAnimation, curve: Curves.easeOut);
    _diceTween = IntTween(begin: 1, end: 6).animate(curve);
    _gameBloc = GameBloc()
      ..setupLeaderboards()
      ..setupPlayerData()
      ..dice.listen((event) {
        if (event == DiceState.rolling) {
          _diceAnimation.forward();
        } else {
          _diceAnimation.stop();
        }
      }, onError: (e) {
        if (mounted) {
          showErrorDialog(
            context,
            errorTitle: "Roll Information",
            errorMessage: e.toString(),
          );
        }
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
              showInfo();
            },
            icon: const Icon(Icons.info_outline),
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
        stream: _gameBloc.dice,
        initialData: DiceState.rest,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == null) {
            return const SizedBox.shrink();
          }
          return Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.black,
                width: 5,
              ),
            ),
            child: (snapshot.data == DiceState.rest)
                ? InkWell(
                    onTap: () => _gameBloc.rollDice(),
                    child: Image.asset(
                      "assets/images/die_${_gameBloc.diceValue}.png",
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : AnimatedBuilder(
                    animation: _diceAnimation,
                    builder: (context, child) {
                      return Image.asset(
                          "assets/images/die_${_diceTween.value}.png");
                    },
                  ),
          );
        },
      );

  void showInfo() async {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            /// informaion Center
            Card(
              margin: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<User?>(
                      stream: AuthBloc().currentUser,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                            snapshot.data!.displayName ?? snapshot.data!.uid,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ));
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          AuthBloc().logout();
                        },
                        child: const Text("Log out"),
                      ),
                    ),
                    FutureBuilder<String>(
                      future: GetVersion.projectVersion,
                      builder: (context, snapshot) {
                        return Text("Version ${snapshot.data}");
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// Leaderboards
            Card(
              margin: const EdgeInsets.all(20),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding: const EdgeInsets.all(20),
                child: StreamBuilder<List<PlayerModel>>(
                    stream: _gameBloc.leaderboards,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return const SizedBox.shrink();
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Leaderboards",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                              child: ListView(
                            children: snapshot.data!
                                .map((e) => Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Text(
                                              e.email,
                                              style: TextStyle(
                                                fontSize:
                                                    e.email == "YOU" ? 18 : 16,
                                                color: Colors.white,
                                                fontWeight: e.email == "YOU"
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Text("${e.score}"),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ))
                        ],
                      );
                    }),
              ),
            ),
          ],
        );
      },
    );
  }
}
