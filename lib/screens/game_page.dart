import 'package:flutter/material.dart';
import 'package:gridlock/models/game.dart';
import 'package:gridlock/widgets/game_board.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  final String title;

  const GamePage({super.key, required this.title});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final game = Provider.of<Game>(context, listen: false);
      game.addListener(_gameListener);
    });
  }

  @override
  void dispose() {
    final game = Provider.of<Game>(context, listen: false);
    game.removeListener(_gameListener);
    super.dispose();
  }

  void _gameListener() {
    final game = Provider.of<Game>(context, listen: false);
    if (game.isGameOver) {
      if (game.winner != null) {
        _showWinnerDialog(game.winner!);
      } else {
        _showDrawDialog();
      }
    }
  }

  void _showWinnerDialog(Player winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            Text('${winner == Player.Player1 ? "Player 1" : "Player 2"} Wins!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Game>(context, listen: false).resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('It\'s a Draw!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Game>(context, listen: false).resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<Game>(context);
    String currentTurn =
        game.currentPlayer == Player.Player1 ? "Player 1" : "Player 2";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Current Turn: $currentTurn',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          const Expanded(
            child: GameBoard(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
