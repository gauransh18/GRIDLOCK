import 'package:flutter/material.dart';
import 'package:gridlock/models/game.dart';
import 'package:gridlock/widgets/game_board.dart';
import 'package:provider/provider.dart';
import 'package:simple_animated_button/elevated_layer_button.dart';
import 'settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class GamePage extends StatefulWidget {
  final String title;

  const GamePage({super.key, required this.title});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Timer? _turnTimer;
  int _remainingTime = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final game = Provider.of<Game>(context, listen: false);
      game.addListener(_gameListener);
      _initializeTimer();
    });
  }

  void _initializeTimer() {
    final game = Provider.of<Game>(context, listen: false);
    setState(() {
      _remainingTime = game.timerDuration;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _turnTimer?.cancel();
    final game = Provider.of<Game>(context, listen: false);
    game.removeListener(_gameListener);
    super.dispose();
  }

  void _startTimer() {
    _turnTimer?.cancel();
    _turnTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _turnTimer?.cancel();
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    final game = Provider.of<Game>(context, listen: false);
    game.switchPlayer();
    _initializeTimer();
  }

  void _gameListener() {
    final game = Provider.of<Game>(context, listen: false);
    if (game.isGameOver) {
      _turnTimer?.cancel();
      if (game.winner != null) {
        _showWinnerDialog(game.winner!);
      } else {
        _showDrawDialog();
      }
    } else {
      _initializeTimer();
    }
  }

  void _showWinnerDialog(Player winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          '${winner == Player.Player1 ? "Player 1" : "Player 2"} Wins!',
          style: GoogleFonts.slackey(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Game>(context, listen: false).resetGame();
            },
            child: Text(
              'Play Again',
              style: GoogleFonts.slackey(fontSize: 16, color: Colors.brown),
            ),
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
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'It\'s a Draw!',
          style: GoogleFonts.slackey(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Game>(context, listen: false).resetGame();
            },
            child: Text(
              'Play Again',
              style: GoogleFonts.slackey(fontSize: 16, color: Colors.brown),
            ),
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
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Reset Game',
          style: GoogleFonts.slackey(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        content: Text(
          'Are you sure?',
          style: GoogleFonts.slackey(
            textStyle: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.slackey(fontSize: 16, color: Colors.brown),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Game>(context, listen: false).resetGame();
            },
            child: Text(
              'Reset',
              style: GoogleFonts.slackey(fontSize: 16, color: Colors.brown),
            ),
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

    final player1Color = game.player1Color;
    final player2Color = game.player2Color;

    return Scaffold(
      backgroundColor: Color(0xFF87CEFA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 171, 255),
        elevation: 10,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        actions: [
          ElevatedLayerButton(
            onClick: _resetGame,
            buttonHeight: 40,
            buttonWidth: 100,
            animationDuration: const Duration(milliseconds: 200),
            animationCurve: Curves.ease,
            topDecoration: BoxDecoration(
              color: Colors.amber,
              border: Border.all(),
            ),
            topLayerChild: const Text(
              "Reset",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            baseDecoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(),
            ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Current Turn',
                      style: GoogleFonts.slackey(
                        textStyle: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      currentTurn,
                      style: GoogleFonts.slackey(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: currentTurn == "Player 1" ? player1Color : player2Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  'Time Remaining: $_remainingTime seconds',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: constraints.maxHeight * 0.5, 
                  child: const GameBoard(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
