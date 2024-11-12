import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animated_button/elevated_layer_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/game.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _changePlayerColor(BuildContext context, Player player, Color color) {
    final game = Provider.of<Game>(context, listen: false);
    game.changePlayerColor(player, color);
  }

  void _changeTimerDuration(BuildContext context, int duration) {
    final game = Provider.of<Game>(context, listen: false);
    game.setTimerDuration(duration);
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://gauranshsharma.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<Game>(context);

    List<DropdownMenuItem<Color>> _buildColorItems(Color selectedColor) {
      final colors = [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
      ];

      return colors.map((color) {
        return DropdownMenuItem<Color>(
          value: color,
          child: Container(
            width: 24,
            height: 24,
            color: color,
          ),
          enabled: color != selectedColor,
        );
      }).toList();
    }

    return Scaffold(
      backgroundColor: Color(0xFF87CEFA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 171, 255),
        elevation: 10,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.slackey(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player 1 Color Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Player 1 Color',
                      style: GoogleFonts.slackey(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DropdownButton<Color>(
                      value: game.player1Color,
                      items: _buildColorItems(game.player2Color),
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
                    Text(
                      'Player 2 Color',
                      style: GoogleFonts.slackey(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DropdownButton<Color>(
                      value: game.player2Color,
                      items: _buildColorItems(game.player1Color),
                      onChanged: (Color? color) {
                        if (color != null) _changePlayerColor(context, Player.Player2, color);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Timer Settings
                Text(
                  'Timer Duration',
                  style: GoogleFonts.slackey(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Slider(
                  value: game.timerDuration.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 11,
                  label: '${game.timerDuration} seconds',
                  onChanged: (double value) {
                    _changeTimerDuration(context, value.toInt());
                  },
                ),
                const SizedBox(height: 20),
                // Rules Section
                Text(
                  'Game Rules',
                  style: GoogleFonts.slackey(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '1. Each player takes turns to make a move.\n'
                  '2. The player who aligns their pieces first wins.\n'
                  '3. If the board is full and no player has aligned their pieces, it\'s a draw.\n'
                  '4. Use the timer to ensure quick gameplay.',
                  style: GoogleFonts.slackey(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            // Know Me Button
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedLayerButton(
                  onClick: _launchURL,
                  buttonHeight: 60,
                  buttonWidth: 270,
                  animationDuration: const Duration(milliseconds: 200),
                  animationCurve: Curves.ease,
                  topDecoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(),
                  ),
                  topLayerChild: const Text(
                    "Know Me",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  baseDecoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
