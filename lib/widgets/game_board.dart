import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import 'marble.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(
      builder: (context, game, child) {
        return AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            itemCount: 16,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemBuilder: (context, index) {
              int row = index ~/ 4;
              int col = index % 4;
              bool isWinningCell = game.winner != null &&
                  _isWinningPosition(game, row, col);
              Player? currentPlayer = game.board[row][col];
              return GestureDetector(
                onTap: () => _handleCellTap(context, game, row, col),
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: isWinningCell ? Colors.yellow : Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Marble(player: currentPlayer),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  bool _isWinningPosition(Game game, int row, int col) {
    // Placeholder for winning position logic
    return false;
  }

  void _handleCellTap(BuildContext context, Game game, int row, int col) async {
    if (!game.canPlaceMarble(row, col)) {
      return;
    }

    bool placed = game.placeMarble(row, col);
    if (placed) {
      await game.shiftMarblesCounterClockwise();
    }
  }
}
