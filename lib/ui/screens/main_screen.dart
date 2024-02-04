import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper/ui/theme/colors.dart';
import 'package:minesweeper/utilis/game_helper.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final db = FirebaseFirestore.instance;
  MineSweeperGame game = MineSweeperGame();
  Stopwatch gameTimer = Stopwatch();
  int passedSeconds = 0;
  int bestScore = 999;
  late Timer _timer;

  @override
  void initState() {
    //print("uuid:" + Uuid().v4());
    retrieveData();
    super.initState();
    game.generateMap();
  }

  void probe(Cell cell) {
    if (!gameTimer.isRunning) {
      _startTimer();
    }
    game.getClickedCell(cell);
    if (game.gameOver) _resetTimer();
  }

  void flag(Cell cell) {
    game.flag(cell);
    if (game.gameOver) {
      _resetTimer();
    }
    if (game.gameWon) {
      insertNewScore(passedSeconds);
      retrieveData();
    }
  }

  void resetGame() {
    game.resetGame();
    _resetTimer();
    passedSeconds = 0;
  }

  void _startTimer() {
    gameTimer.start();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTime);
  }

  void _resetTimer() {
    if (gameTimer.isRunning && _timer.isActive) {
      gameTimer.stop();
      gameTimer.reset();
      _timer.cancel();
    }
  }

  void _updateTime(Timer timer) {
    setState(() {
      passedSeconds = gameTimer.elapsed.inSeconds; // Format elapsed time
    });
  }

  Future<DocumentSnapshot<Object?>> retrieveBestScore() async {
    try {
      Query<Object?> query =
          db.collection('BestScores').orderBy('score').limit(1);
      QuerySnapshot<Object?> snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[0]; // Return the document with the highest score
      } else {
        throw Exception('No documents found in the collection');
      }
    } catch (error) {
      rethrow; // Rethrow the error for further handling
    }
  }

  Future<void> insertNewScore(int score) async {
    try {
      // Use a document ID based on a timestamp for uniqueness
      DocumentReference docRef = db.collection('BestScores').doc(Uuid().v4());

      // Create a map with the score data
      Map<String, dynamic> data = {'score': score};

      // Set the document with the data
      await docRef.set(data);

      print('New score document added successfully!');
    } catch (error) {
      print('Error adding new score document: $error');
    }
  }

  retrieveData() {
    retrieveBestScore().then((DocumentSnapshot<Object?> bestScoreDoc) {
      if (bestScoreDoc.exists) {
        bestScore = bestScoreDoc.get('score');
        print('Highest score: $bestScore');
        // ... (use the highest score as needed)
      } else {
        print('No document with the highest score found');
      }
    }).catchError((error) {
      print('Error retrieving highest score: $error');
      // ... (handle the error appropriately)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text("MineSweeper"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.flag,
                        color: AppColor.accentColor,
                        size: 34.0,
                      ),
                      Text(
                        "${game.numberOfMines - game.placedFlags}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.timer,
                        color: AppColor.accentColor,
                        size: 34.0,
                      ),
                      Text(
                        "${passedSeconds}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          /* Game grid */
          Container(
            width: double.infinity,
            //height: MediaQuery.of(context).size.height * 0.6,
            height: 500,
            padding: EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MineSweeperGame.row,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: MineSweeperGame.cells,
                itemBuilder: (BuildContext ctx, index) {
                  Color cellColor = game.gameMap[index].reveal
                      ? AppColor.clickedCard
                      : AppColor.lightPrimaryColor;
                  return GestureDetector(
                    onLongPress: game.gameOver
                        ? null
                        : () {
                            setState(() {
                              flag(game.gameMap[index]);
                            });
                          },
                    onTap: game.gameOver
                        ? null
                        : () {
                            setState(() {
                              probe(game.gameMap[index]);
                            });
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Center(
                        child: Text(
                          game.gameMap[index].flagged
                              ? "\u2691"
                              : game.gameMap[index].reveal
                                  ? "${game.gameMap[index].content}"
                                  : "",
                          //'${game.gameMap[index].flagged ? "\u2691" : ""}${game.gameMap[index].reveal ? "${game.gameMap[index].content}" : ""}',
                          /* game.gameMap[index].reveal
                              ? "${game.gameMap[index].content}"
                              : "", */
                          style: TextStyle(
                            color: game.gameMap[index].flagged
                                ? Colors.white
                                : game.gameMap[index].reveal
                                    ? game.gameMap[index].content == "X"
                                        ? Colors.red
                                        : AppColor.letterColors[
                                            game.gameMap[index].content]
                                    : Colors.transparent,
                            /* game.gameMap[index].reveal
                                ? game.gameMap[index].content == "X"
                                    ? Colors.red
                                    : AppColor.letterColors[
                                        game.gameMap[index].content]
                                : Colors.transparent, */
                            fontSize: 32.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Text(
            game.gameWon
                ? "You Won! Best score: ${bestScore}"
                : game.gameOver
                    ? "You Lose"
                    : "",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                resetGame();
              });
            },
            fillColor: AppColor.lightPrimaryColor,
            elevation: 0.0,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Text(
              "Repeat",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
