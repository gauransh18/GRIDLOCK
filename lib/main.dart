import 'package:flutter/material.dart';
import 'package:gridlock/screens/game_page.dart';
import 'package:gridlock/screens/welcome_screen.dart';
import 'package:gridlock/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'models/game.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Game(),
      child: const MarbleGameApp(),
    ),
  );
}

class MarbleGameApp extends StatelessWidget {
  const MarbleGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counterclockwise Marble Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/game': (context) => const GamePage(title: 'Marble Game'),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

