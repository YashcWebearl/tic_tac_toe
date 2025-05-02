
import 'dart:math';

import 'package:flutter/material.dart';

class TicTacToeGame extends StatefulWidget {
  final bool isAI;
  final String difficulty;

  const TicTacToeGame({super.key, this.isAI = false, this.difficulty = 'easy'});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  String currentPlayer = 'X';
  String winner = '';
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    if (widget.isAI && currentPlayer == 'O') {
      _makeAIMove();
    }
  }

  // void _handleTap(int row, int col) {
  //   if (board[row][col] == '' && !gameOver) {
  //     setState(() {
  //       board[row][col] = currentPlayer;
  //       if (_checkWinner(row, col)) {
  //         winner = currentPlayer;
  //         gameOver = true;
  //       } else if (_isDraw()) {
  //         winner = 'Draw';
  //         gameOver = true;
  //       } else {
  //         currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  //         if (widget.isAI && currentPlayer == 'O' && !gameOver) {
  //           _makeAIMove();
  //         }
  //       }
  //     });
  //   }
  // }
  void _handleTap(int row, int col) {
    if (board[row][col] == '' && !gameOver) {
      setState(() {
        board[row][col] = currentPlayer;
        if (_checkWinner(row, col)) {
          winner = currentPlayer;
          gameOver = true;
          _showGameOverDialog('$winner Wins!');
        } else if (_isDraw()) {
          winner = 'Draw';
          gameOver = true;
          _showGameOverDialog('It\'s a Draw!');
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          if (widget.isAI && currentPlayer == 'O' && !gameOver) {
            _makeAIMove();
          }
        }
      });
    }
  }


  void _makeAIMove() {
    if (gameOver) return;

    var move = widget.difficulty == 'easy'
        ? _randomMove()
        : widget.difficulty == 'medium'
        ? _mediumMove()
        : _hardMove();

    if (move != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleTap(move[0], move[1]);
      });
    }
  }

  List<int>? _randomMove() {
    List<List<int>> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          emptyCells.add([i, j]);
        }
      }
    }
    if (emptyCells.isNotEmpty) {
      return emptyCells[Random().nextInt(emptyCells.length)];
    }
    return null;
  }

  List<int>? _mediumMove() {
    // 50% chance for optimal move, 50% for random
    if (Random().nextDouble() < 0.5) {
      return _hardMove();
    }
    return _randomMove();
  }

  List<int>? _hardMove() {
    // Minimax algorithm for optimal move
    int bestScore = -1000;
    List<int>? bestMove;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') {
          board[i][j] = 'O';
          int score = _minimax(board, 0, false);
          board[i][j] = '';
          if (score > bestScore) {
            bestScore = score;
            bestMove = [i, j];
          }
        }
      }
    }
    return bestMove;
  }

  int _minimax(List<List<String>> board, int depth, bool isMaximizing) {
    if (_checkWinnerForMinimax(board, 'O')) return 10 - depth;
    if (_checkWinnerForMinimax(board, 'X')) return depth - 10;
    if (_isDrawForMinimax(board)) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            board[i][j] = 'O';
            int score = _minimax(board, depth + 1, false);
            board[i][j] = '';
            bestScore = max(score, bestScore);
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            board[i][j] = 'X';
            int score = _minimax(board, depth + 1, true);
            board[i][j] = '';
            bestScore = min(score, bestScore);
          }
        }
      }
      return bestScore;
    }
  }

  bool _checkWinner(int row, int col) {
    if (board[row].every((cell) => cell == currentPlayer)) return true;
    if ([board[0][col], board[1][col], board[2][col]].every((cell) => cell == currentPlayer)) return true;
    if (row == col && [board[0][0], board[1][1], board[2][2]].every((cell) => cell == currentPlayer)) return true;
    if (row + col == 2 && [board[0][2], board[1][1], board[2][0]].every((cell) => cell == currentPlayer)) return true;
    return false;
  }

  bool _checkWinnerForMinimax(List<List<String>> board, String player) {
    for (int i = 0; i < 3; i++) {
      if (board[i].every((cell) => cell == player)) return true;
      if ([board[0][i], board[1][i], board[2][i]].every((cell) => cell == player)) return true;
    }
    if ([board[0][0], board[1][1], board[2][2]].every((cell) => cell == player)) return true;
    if ([board[0][2], board[1][1], board[2][0]].every((cell) => cell == player)) return true;
    return false;
  }

  bool _isDraw() {
    for (var row in board) {
      if (row.contains('')) return false;
    }
    return true;
  }

  bool _isDrawForMinimax(List<List<String>> board) {
    for (var row in board) {
      if (row.contains('')) return false;
    }
    return true;
  }

  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
      winner = '';
      gameOver = false;
    });
    if (widget.isAI && currentPlayer == 'O') {
      _makeAIMove();
    }
  }

  Widget _buildCell(int row, int col) {
    return GestureDetector(
      onTap: () => _handleTap(row, col),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Color(0xFF040E25),
        ),
        width: 100,
        height: 100,
        alignment: Alignment.center,
        child: Text(
          board[row][col],
          style: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            color: board[row][col] == 'X' ? Colors.blue : Colors.red,
          ),
        ),
      ),
    );
  }
  void _showGameOverDialog(String message) {
    bool isDraw = message.toLowerCase().contains('draw');
    bool playerWon = message.contains('X') && !isDraw;
    bool opponentWon = message.contains('O') && !isDraw;

    bool showStars = playerWon || (!widget.isAI && opponentWon);

    String finalMessage = '';
    if (isDraw) {
      finalMessage = 'Better luck next time!';
    } else if (playerWon) {
      finalMessage = 'Congratulations on winning!';
    } else if (widget.isAI && opponentWon) {
      finalMessage = 'Oops! You lost this one.';
    } else if (!widget.isAI && opponentWon) {
      finalMessage = 'Opponent wins! Better luck next time.';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF040E25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white24),
        ),
        title: Column(
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            if (showStars)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star, color: Colors.yellow, size: 30),
                  SizedBox(width: 6),
                  Icon(Icons.star, color: Colors.yellow, size: 30),
                  SizedBox(width: 6),
                  Icon(Icons.star, color: Colors.yellow, size: 30),
                ],
              ),
            const SizedBox(height: 10),
            Text(
              finalMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A1C3A),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Go to Home',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A1C3A),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Replay',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1C3A), // Dark blue background matching the logo
      // appBar: AppBar(
      //   title: const Text('Tic Tac Toe'),
      //   backgroundColor: Colors.deepPTic Tac Toeurple,
      //   centerTitle: true,
      // ),
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: const Color(0xFF040E25), // Neon purple app bar (matches the O in the logo)
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_backspace_sharp,color: Colors.white,)
        ),
        titleTextStyle: const TextStyle(
          color:Colors.white, // Neon green text (matches the grid in the logo)
          fontSize: 20,
          fontWeight: FontWeight.bold,

        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            gameOver
                ? winner == 'Draw'
                ? 'It\'s a Draw!'
                : '$winner Wins!'
                // : '${widget.isAI && currentPlayer == 'O' ? 'AI\'s' : currentPlayer}\'s Turn',
                : currentPlayer == 'X'
                ? "X\'s turn"
                : widget.isAI
                ? 'AI\'s Turn'
                : 'O\'s Turn',

            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
          ),
          const SizedBox(height: 20),
          Column(
            children: List.generate(3, (row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (col) => _buildCell(row, col)),
              );
            }),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              backgroundColor:Color(0xFF040E25),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Reset Game',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}