import 'package:flutter/material.dart';
import 'package:gridlock/models/game_history.dart';
import 'package:hive/hive.dart';

enum Player { Player1, Player2 }

class Game extends ChangeNotifier {
  List<List<Player?>> board;
  Player currentPlayer;
  bool isGameOver;
  Player? winner;

  Color player1Color = Colors.red;
  Color player2Color = Colors.blue;

  int timerDuration = 10; 

  Game()
      : board = List.generate(4, (_) => List.filled(4, null)),
        currentPlayer = Player.Player1,
        isGameOver = false,
        winner = null;

  List<List<Player?>> previousBoard = List.generate(4, (_) => List.filled(4, null));
  List<Position> winningPositions = [];

  bool canPlaceMarble(int row, int col) {
    return board[row][col] == null && !isGameOver;
  }

  bool placeMarble(int row, int col) {
    if (!canPlaceMarble(row, col)) {
      return false;
    }

    _copyBoard(board, previousBoard);
    board[row][col] = currentPlayer;
    notifyListeners();

    return true;
  }

  Future<void> shiftMarblesCounterClockwise() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _copyBoard(board, previousBoard);
    _shiftOuterMarbles();
    _shiftInnerMarbles();
    notifyListeners();
    checkWinner();

    if (!isGameOver) {
      switchPlayer();
    }
  }

  void switchPlayer() {
    currentPlayer = currentPlayer == Player.Player1 ? Player.Player2 : Player.Player1;
    notifyListeners();
  }

  void _shiftOuterMarbles() {
    List<Position> outerPath = getOuterPath();
    List<Player?> outerMarbles = outerPath.map((pos) => board[pos.row][pos.col]).toList();
    outerMarbles.insert(0, outerMarbles.removeLast());
    for (int i = 0; i < outerPath.length; i++) {
      board[outerPath[i].row][outerPath[i].col] = outerMarbles[i];
    }
  }

  void _shiftInnerMarbles() {
    List<Position> innerPath = getInnerPath();
    List<Player?> innerMarbles = innerPath.map((pos) => board[pos.row][pos.col]).toList();
    innerMarbles.insert(0, innerMarbles.removeLast());
    for (int i = 0; i < innerPath.length; i++) {
      board[innerPath[i].row][innerPath[i].col] = innerMarbles[i];
    }
  }

  List<Position> getOuterPath() {
    return [
      Position(row: 0, col: 0),
      Position(row: 1, col: 0),
      Position(row: 2, col: 0),
      Position(row: 3, col: 0),
      Position(row: 3, col: 1),
      Position(row: 3, col: 2),
      Position(row: 3, col: 3),
      Position(row: 2, col: 3),
      Position(row: 1, col: 3),
      Position(row: 0, col: 3),
      Position(row: 0, col: 2),
      Position(row: 0, col: 1),
    ];
  }

  List<Position> getInnerPath() {
    return [
      Position(row: 1, col: 1),
      Position(row: 2, col: 1),
      Position(row: 2, col: 2),
      Position(row: 1, col: 2),
    ];
  }

  void checkWinner() {
    winningPositions = [];

    for (int i = 0; i < 4; i++) {
      if (board[i].every((player) => player == Player.Player1)) {
        winningPositions = List.generate(4, (col) => Position(row: i, col: col));
        endGame(Player.Player1);
        return;
      }
      if (board[i].every((player) => player == Player.Player2)) {
        winningPositions = List.generate(4, (col) => Position(row: i, col: col));
        endGame(Player.Player2);
        return;
      }
    }

    for (int i = 0; i < 4; i++) {
      bool player1Win = true;
      bool player2Win = true;
      for (int r = 0; r < 4; r++) {
        if (board[r][i] != Player.Player1) player1Win = false;
        if (board[r][i] != Player.Player2) player2Win = false;
      }
      if (player1Win) {
        winningPositions = List.generate(4, (row) => Position(row: row, col: i));
        endGame(Player.Player1);
        return;
      }
      if (player2Win) {
        winningPositions = List.generate(4, (row) => Position(row: row, col: i));
        endGame(Player.Player2);
        return;
      }
    }

    bool player1Diagonal1 = true;
    bool player1Diagonal2 = true;
    bool player2Diagonal1 = true;
    bool player2Diagonal2 = true;
    for (int i = 0; i < 4; i++) {
      if (board[i][i] != Player.Player1) player1Diagonal1 = false;
      if (board[i][i] != Player.Player2) player2Diagonal1 = false;
      if (board[i][3 - i] != Player.Player1) player1Diagonal2 = false;
      if (board[i][3 - i] != Player.Player2) player2Diagonal2 = false;
    }
    if (player1Diagonal1) {
      winningPositions = List.generate(4, (i) => Position(row: i, col: i));
      endGame(Player.Player1);
      return;
    }
    if (player1Diagonal2) {
      winningPositions = List.generate(4, (i) => Position(row: i, col: 3 - i));
      endGame(Player.Player1);
      return;
    }
    if (player2Diagonal1) {
      winningPositions = List.generate(4, (i) => Position(row: i, col: i));
      endGame(Player.Player2);
      return;
    }
    if (player2Diagonal2) {
      winningPositions = List.generate(4, (i) => Position(row: i, col: 3 - i));
      endGame(Player.Player2);
      return;
    }

    bool isDraw = board.every((row) => row.every((cell) => cell != null));
    if (isDraw) {
      isGameOver = true;
      winner = null;
      notifyListeners();
      
      final historyBox = Hive.box<GameHistory>('gameHistory');
      final history = GameHistory(board, winner, DateTime.now());
      historyBox.add(history);
    }
  }

  void endGame(Player? winningPlayer) {
    isGameOver = true;
    winner = winningPlayer;
    notifyListeners();

    final historyBox = Hive.box<GameHistory>('gameHistory');
    final history = GameHistory(board, winner, DateTime.now());
    historyBox.add(history);
  }

  void resetGame() {
    board = List.generate(4, (_) => List.filled(4, null));
    currentPlayer = Player.Player1;
    isGameOver = false;
    winner = null;

    previousBoard = List.generate(4, (_) => List.filled(4, null));
    winningPositions = [];
    notifyListeners();
  }

  void _copyBoard(List<List<Player?>> source, List<List<Player?>> destination) {
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        destination[r][c] = source[r][c];
      }
    }
  }

  void changePlayerColor(Player player, Color color) {
    if (player == Player.Player1) {
      player1Color = color;
    } else {
      player2Color = color;
    }
    notifyListeners();
  }

  void setTimerDuration(int duration) {
    timerDuration = duration;
    notifyListeners();
  }
}

class Position {
  final int row;
  final int col;

  Position({required this.row, required this.col});
}
