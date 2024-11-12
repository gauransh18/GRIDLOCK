import 'package:flutter/material.dart';
import 'package:gridlock/models/game.dart';
import 'package:gridlock/widgets/game_board.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';

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
  
  void _resetGame() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Game'),
        content: const Text('Are you sure you want to reset the game?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel action
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Provider.of<Game>(context, listen: false).resetGame(); // Reset the game
            },
            child: const Text('Reset'),
          ),
        ],
      ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Game',
            onPressed: _resetGame,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
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
