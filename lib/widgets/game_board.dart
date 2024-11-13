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
          child: Stack(
            children: [
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 16,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (context, index) {
                  int row = index ~/ 4;
                  int col = index % 4;
                  bool isWinningCell = game.winningPositions
                      .any((pos) => pos.row == row && pos.col == col);
                  Player? currentPlayer = game.board[row][col];
                  return GestureDetector(
                    onTap: () => _handleCellTap(context, game, row, col),
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: isWinningCell
                            ? Colors.yellow.withOpacity(0.3)
                            : Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Marble(player: currentPlayer),
                      ),
                    ),
                  );
                },
              ),
              if (game.winningPositions.isNotEmpty)
                Positioned.fill(
                  child: CustomPaint(
                    painter: WinningLinePainter(
                      game.winningPositions,
                      game.winner == Player.Player1
                          ? game.player1Color
                          : game.player2Color,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
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

class WinningLinePainter extends CustomPainter {
  final List<Position> winningPositions;
  final Color lineColor;

  WinningLinePainter(this.winningPositions, this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (winningPositions.length < 2) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    double cellWidth = size.width / 4;
    double cellHeight = size.height / 4;

    Position first = winningPositions.first;
    Position last = winningPositions.last;

    Offset start = Offset(
      first.col * cellWidth + cellWidth / 2,
      first.row * cellHeight + cellHeight / 2,
    );
    Offset end = Offset(
      last.col * cellWidth + cellWidth / 2,
      last.row * cellHeight + cellHeight / 2,
    );

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant WinningLinePainter oldDelegate) {
    return oldDelegate.winningPositions != winningPositions ||
        oldDelegate.lineColor != lineColor;
  }
}
