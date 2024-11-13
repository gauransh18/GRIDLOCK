import 'package:flutter/material.dart';
import 'package:gridlock/models/game_history.dart';
import 'package:gridlock/models/player_adapter.dart';
import 'package:gridlock/screens/welcome_screen.dart';
import 'package:gridlock/screens/game_page.dart';
import 'package:gridlock/screens/settings_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GameHistoryAdapter());
  Hive.registerAdapter(PlayerAdapter());
  await Hive.openBox<GameHistory>('gameHistory');
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => Game(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gridlock Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/game': (context) => const GamePage(title: 'Gridlock Game'),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

