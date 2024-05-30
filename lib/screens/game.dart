import 'package:flutter/material.dart';
import 'package: ../constants/color.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  State<GameScreen> createState() => _Game();
}

class _Game extends State<GameScreen> {

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Score Board',

            )
          ),
          Expanded(
            child:  GridView.builder(
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) => {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    borderRadius: BorderRadius.circular(),
                    border: Border.all(
                      width: 2,
                      color: primaryColor
                    ),
                    color: secondaryColor
                  )
                )
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
      );

    );
  }
}