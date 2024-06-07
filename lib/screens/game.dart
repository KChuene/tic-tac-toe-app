import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/color.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  State<GameScreen> createState() => _Game();
}

class _Game extends State<GameScreen> {
  List<List<String>> arrayMappingXO = [['', '', ''], ['', '', ''], ['', '', '']];
  bool isOTurn = true; 
  //TODO: Have a toggle widget to decide who starts first if O then isOTurn initially true else false.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                ToggleButtons(
                  isSelected: [true, false],
                  children: [
                    ButtonBar(),
                    ButtonBar()
                  ],
                  onPressed: (isOn) { 
                    isOTurn = (isOn > 0)? true: false;
                    print("O-turn: ${isOTurn}");
                  },
                ),
                const Expanded(child: Text('Score Board'))
              ]
            )
          ),
          Expanded(
            flex: 3,
            child:  GridView.builder(
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _play(tapIndex: index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: primaryColor
                      ),
                      color: secondaryColor
                    ),
                    child: const Center(
                      child: Text(
                        'X',
                        style: TextStyle(
                          fontFamily: 'Agency FB',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor
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
            child: Text(
              'Timer'
            )
          )
        ]
      )

    );
  }

  void _play({required int tapIndex}) {
    setState(() {
      if(arrayMappingXO[tapIndex].isNotEmpty) {
        return;
      }
      int row = _tdRow(tapIndex); 
      int col = _tdCol(tapIndex);

      arrayMappingXO[row][col] = (isOTurn)? 'O': 'X'; 
      print(arrayMappingXO[row][col]);

      isOTurn = !isOTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // Check the eight-triples combination for matching 'X' or 'O' triple

    // Combination 1, 2, 3: Row 1, 2, 3
    check() {
      for(int r= 0; r < 3; r++) {
        if(arrayMappingXO[r][0] == arrayMappingXO[r][1] && arrayMappingXO[r][0] == arrayMappingXO[r][2]) {
          return arrayMappingXO[r][0];
        }
      }

      // Combination 4, 5, 6: Col 1, 2, 3
      for(int c= 0; c < 3; c++) {
        if(arrayMappingXO[0][c] == arrayMappingXO[1][c] && arrayMappingXO[0][c] == arrayMappingXO[2][c]) {
          return arrayMappingXO[0][c];
        }
      }
      
      // Combination 7 and 8: Diagonal 1 and Diaognal 2
      if(arrayMappingXO[0][0] == arrayMappingXO[1][1] && arrayMappingXO[0][0] == arrayMappingXO[2][2]) {
        return arrayMappingXO[0][0];
      }
      if(arrayMappingXO[0][2] == arrayMappingXO[1][1] && arrayMappingXO[0][2] == arrayMappingXO[2][0]) {
        return arrayMappingXO[0][2];
      }
    }

    if(check() == 'X') {
      print('X won!');
    }
    else {
      print('O won!');
    }
  }

  int _tdRow(int index) {
    return index ~/ 3;
  }

  int _tdCol(int index) {
    return index % 3;
  }
}