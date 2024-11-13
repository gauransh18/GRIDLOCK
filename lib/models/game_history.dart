import 'package:hive/hive.dart';
import 'game.dart';

part 'game_history.g.dart';

@HiveType(typeId: 0)
class GameHistory extends HiveObject {
  @HiveField(0)
  final List<List<Player?>> board;

  @HiveField(1)
  final Player? winner;

  @HiveField(2)
  final DateTime date;

  GameHistory(this.board, this.winner, this.date);
} 