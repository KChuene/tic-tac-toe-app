import 'dart:async'; // Timer package
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/color.dart';

class GameScreen extends StatefulWidget {
  static const String route = "/game";
  static var customFontStyle = const TextStyle(
    fontFamily: "Arial Rounded MT",
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white
  );

  const GameScreen({Key? key}) : super(key: key);

  State<GameScreen> createState() => _Game();
}

class _Game extends State<GameScreen> {
  List<List<String>> arrayMappingXO = [['', '', ''], ['', '', ''], ['', '', '']];
  List<int> winningTripple = [-1, -1, -1];
  bool isOTurn = true; //TODO: Have a toggle widget to decide who starts first if O then isOTurn initially true else false.

  String endResult = '';
  int oScore = 0; int xScore = 0;
  int turnsLeft = 0;
  bool isFirstPlay = true; 


  Timer? timer;
  static const maxSeconds = 30;
  int seconds = maxSeconds;

  void _startTimer() {
    // Configure the behaviour of the timer
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Invoke setState() every <Duration>
      setState(() {
        if(seconds > 0) {
          seconds--; // count down from 30=maxSeconds
        }
        else {
          _stopTimer();

          if(turnsLeft > 0) _updateWinner('time'); // Turns still left, but time ran out
        }
      });
    });
  }

  void _stopTimer() {
    timer?.cancel();
    _resetTimer(); 
  }

  void _resetTimer() => seconds = maxSeconds;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end, // Content won't hide behind status bar anymore
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(23)
                        ),
                        child: const Text(
                          'Player O', 
                          style: TextStyle(
                            fontFamily: "Arial",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )
                        )
                      ),
                      const SizedBox(height: 5),
                      Text(
                        oScore.toString(), 
                        style: GameScreen.customFontStyle
                      )
                    ],
                  ),
                  const SizedBox(width: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end, // Content won't hide behind status bar anymore
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(23)
                        ),
                        child: const Text(
                          'Player X', 
                          style: TextStyle(
                            fontFamily: "Arial",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )
                        )
                      ),
                      const SizedBox(height: 5),
                      Text(
                        xScore.toString(), 
                        style: GameScreen.customFontStyle
                      )
                    ],
                  )
                ],
              )
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 3,
              child:  GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      final isTimerRunning = (timer == null)? false: timer!.isActive;

                      // Only play if not out of turns and not out of time
                      if(turnsLeft > 0 && isTimerRunning) {
                        _play(tapIndex: index);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: primaryColor
                        ),
                        color: (_isWinBlock(index))? accentColor: secondaryColor
                      ),
                      child: Center(
                        child: Text(
                          arrayMappingXO[_tdRow(index)][_tdCol(index)],
                          style: TextStyle(
                            fontFamily: "Arial",
                            fontWeight: FontWeight.bold,
                            fontSize: 55,
                            color: (_isWinBlock(index))? Colors.white: primaryColor 
                          )
                        ),
                      )
                    )
                  );
                }
              )
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    endResult,
                    style: GameScreen.customFontStyle
                  ),
                  const SizedBox(height: 15),
                  _buildTimer()
                ]
              )
            )
          ]
        ),
      )

    );
  }

  Widget _buildTimer() {
    final isTimerRunning = (timer == null)? false: timer!.isActive;

    if(isTimerRunning) {
       return SizedBox(
        width: 125,
        height: 125,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1 - seconds / 30, // 30 segments of 3.333... = 100% 
              
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              strokeWidth: 8, // Progress color
              backgroundColor: accentColor, // Full color
            ),
            Center(
              child: Text(
                '$seconds', 
                style: const TextStyle(
                  fontSize: 45, 
                  color: Colors.white
                )
              ),
            )
          ],
        ),
       );
    }
    else {
      return ElevatedButton(
        onPressed: () => _init(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
        ),
        child: Text(
          (isFirstPlay)? 'Start': 'Play again!',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w300
          )
        )
      );
    }
  }

  void _play({required int tapIndex}) {
    setState(() {
      int row = _tdRow(tapIndex);
      int col = _tdCol(tapIndex);

      if(arrayMappingXO[row][col].isNotEmpty) {
        return;
      }
      arrayMappingXO[row][col] = (isOTurn)? 'o': 'x'; 

      isOTurn = !isOTurn;
      turnsLeft--;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // Check the eight-triples combination for matching 'X' or 'O' triple
    check() {
      // Combination 1, 2, 3: Row 1, 2, 3
      for(int r= 0; r < 3; r++) {
        if(arrayMappingXO[r][0].isEmpty) continue;

        if(arrayMappingXO[r][0] == arrayMappingXO[r][1] && 
          arrayMappingXO[r][0] == arrayMappingXO[r][2]) {

          winningTripple = [_odIndex(r, 0), _odIndex(r, 1), _odIndex(r, 2)];
          return arrayMappingXO[r][0];
        }
      }

      // Combination 4, 5, 6: Col 1, 2, 3
      for(int c= 0; c < 3; c++) {
        if(arrayMappingXO[0][c].isEmpty) continue;

        if(arrayMappingXO[0][c] == arrayMappingXO[1][c] && 
          arrayMappingXO[0][c] == arrayMappingXO[2][c]) {
          
          winningTripple = [_odIndex(0, c), _odIndex(1, c), _odIndex(2, c)];
          return arrayMappingXO[0][c];
        }
      }
      
      // Combination 7 and 8: Diagonal 1 and Diaognal 2
      if(arrayMappingXO[0][0] == arrayMappingXO[1][1] && 
        arrayMappingXO[0][0] == arrayMappingXO[2][2] && arrayMappingXO[0][0].isNotEmpty) {

        winningTripple = [_odIndex(0, 0), _odIndex(1, 1), _odIndex(2, 2)];
        return arrayMappingXO[0][0];
      }
      if(arrayMappingXO[0][2] == arrayMappingXO[1][1] && 
        arrayMappingXO[0][2] == arrayMappingXO[2][0] && arrayMappingXO[0][2].isNotEmpty) {

        winningTripple = [_odIndex(0, 2), _odIndex(1, 1), _odIndex(2, 0)];
        return arrayMappingXO[0][2];
      }
      
      return '';
    }
    String winner = check();

    if(winner.isNotEmpty) _stopTimer();
    _updateWinner(winner); 
  }

  int _tdRow(int index) => index ~/ 3;

  int _tdCol(int index) => index % 3;

  int _odIndex(int row, int col) {
    // 3x3 grid: index = row.col that is 0 = 0.0, 1 = 0.1 
    // since 0 / 3 = 0 rm 0 and 1 / 3 = 0 rm 1
    // ex. 2.2 = 8, 8 / 3 = 2.2
    return (row * 3) + col;
  }

  void _updateWinner(String winner) {
    if(winner == 'x') {
      endResult = 'Player X wins!';
      turnsLeft = 0; // End game, prevent further playing
      xScore++; // Timer already stopped
    }
    else if(winner == 'o') {
      endResult = 'Player O wins!';
      turnsLeft = 0; // End game, prevent further playing
      oScore++; // Timer already stopped
    }  
    else if(winner == 'time') {
      endResult = 'Time is up!'; // Timer already stopped
    }
    else if(turnsLeft <= 0) {
      endResult = 'No one wins!';
      _stopTimer();
    }
  }

  bool _isWinBlock(int index) => winningTripple.contains(index);

  void _init() {
    setState(() {
      if(isFirstPlay) isFirstPlay = false;

      for(List<String> row in arrayMappingXO) {
        for(int index= 0; index < 3; index++) {
          row[index] = '';
        }
      }

      endResult = '';
      turnsLeft = 9;
      winningTripple = [-1, -1, -1].toList();
      _startTimer();
    });
  }

  Widget playerSelector() {
    return Row(
      children: [
        ToggleButtons(
          borderRadius: BorderRadius.circular(25),
          color: primaryColor,
          isSelected: const [true, false], // 'O' and 'X'
          children: const [
            Text('o'),
            Text('x')
          ],
          onPressed: (index) { 
            setState(() {
              if(index > 0) {
                isOTurn = false;
              }
            });
          },
        ),
        const Expanded(child: Text('Score Board'))
      ]
    );
  }
} 