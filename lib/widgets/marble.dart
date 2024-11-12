import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';

class Marble extends StatelessWidget {
  final Player? player;

  const Marble({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (player == null) {
      return const SizedBox.shrink();
    }

    final game = Provider.of<Game>(context, listen: false);
    Color color;
    switch (player!) {
      case Player.Player1:
        color = game.player1Color;
        break;
      case Player.Player2:
        color = game.player2Color;
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
