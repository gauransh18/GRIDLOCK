import 'package:flutter/material.dart';
import '../models/game.dart';

class Marble extends StatelessWidget {
  final Player? player;

  const Marble({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (player == null) {
      return const SizedBox.shrink();
    }

    Color color;
    switch (player!) {
      case Player.Player1:
        color = Colors.red;
        break;
      case Player.Player2:
        color = Colors.blue;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: 40,
      height: 40,
    );
  }
}
