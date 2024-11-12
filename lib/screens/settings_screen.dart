import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _changePlayerColor(BuildContext context, Player player, Color color) {
    final game = Provider.of<Game>(context, listen: false);
    game.changePlayerColor(player, color);
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<Game>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Player 1 Color Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Player 1 Color'),
                DropdownButton<Color>(
                  value: game.player1Color,
                  items: [
                    DropdownMenuItem(
                      value: Colors.red,
                      child: Container(
                        width: 24,
                        height: 24,
                        color: Colors.red,
                      ),
                    ),
                    DropdownMenuItem(
                      value: Colors.green,
                      child: Container(
                        width: 24,
                        height: 24,
                        color: Colors.green,
                      ),
                    ),
                    DropdownMenuItem(
                      value: Colors.blue,
                      child: Container(
                        width: 24,
                        height: 24,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                  onChanged: (Color? color) {
                    if (color != null) _changePlayerColor(context, Player.Player1, color);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Player 2 Color Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Player 2 Color'),
                DropdownButton<Color>(
                  value: game.player2Color,
                  items: [
                    DropdownMenuItem(
                      value: Colors.red,
                      child: Container(
                        width: 24,
                        height: 24,
                        color: Colors.red,
                      ),
                    ),
                    DropdownMenuItem(
                      value: Colors.green,
                      child: Container(
                        width: 24,
                        height: 24,
                        color: Colors.green,
                      ),
                    ),
                    DropdownMenuItem(
                      value: Colors.blue,
                      child: Container(
                        width: 24,
                        height: 24,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                  onChanged: (Color? color) {
                    if (color != null) _changePlayerColor(context, Player.Player2, color);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}