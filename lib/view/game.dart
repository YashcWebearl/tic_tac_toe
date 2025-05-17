import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/view/winner_page.dart';
import '../Widget/bg_container.dart';
import '../Widget/coin_add_service.dart';
import '../Widget/custom_appbar.dart';
import '../Widget/custom_button.dart';
import '../Widget/setting_dialoug.dart';
import '../Widget/sound.dart';
import '../Widget/undobutton.dart';
import 'ad_show.dart';

class TicTacToeGame extends StatefulWidget {
  final bool isAI;
  final String difficulty;
  final String playerXName;
  final String playerOName;

  const TicTacToeGame({
    super.key,
    this.isAI = false,
    this.difficulty = 'easy',
    this.playerXName = 'Player 1',
    this.playerOName = 'Player 2',
  });

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame>
    with SingleTickerProviderStateMixin {
  late String playerXName;
  late String playerOName;
  int _playCount = 0;
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  String currentPlayer = 'X';
  String winner = '';
  bool gameOver = false;
  List<List<List<String>>> moveHistory = [];
  List<Offset>? winningLine;
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _loadPlayerNames();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _loadPlayCount();
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _showGameOverDialog('$winner Wins!');
        }
      });

    if (widget.isAI && currentPlayer == 'O') {
      _makeAIMove();
    }
  }
  Future<void> _loadPlayCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _playCount = prefs.getInt('playCount') ?? 0;
    });
  }

  Future<void> _showNameDialog({required bool isPlayerX}) async {
    String currentName = isPlayerX ? playerXName : playerOName;
    TextEditingController controller = TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter ${isPlayerX ? 'Player X' : 'Player O'} Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Pridi',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  maxLength: 10,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                // const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    RoundedGradientButton(
                      width: 100,
                      height: 40,
                      text: 'Save',
                      onPressed: () async {
                        String newName = controller.text.trim();
                        if (newName.isNotEmpty) {
                          final prefs = await SharedPreferences.getInstance();
                          if (isPlayerX) {
                            await prefs.setString('playerXName', newName);
                            setState(() => playerXName = newName);
                          } else if (!widget.isAI) {
                            await prefs.setString('playerOName', newName);
                            setState(() => playerOName = newName);
                          }
                          Navigator.pop(context);
                        }
                      },
                    ),

                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadPlayerNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      playerXName = prefs.getString('playerXName') ?? widget.playerXName;
      playerOName = widget.isAI
          ? 'AI'
          : prefs.getString('playerOName') ?? widget.playerOName;
    });
  }
  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
  void _showUndoDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 380,
            height: 204,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Are you sure to undo?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Pridi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      CustomIconButton(
                        height: 45,
                        spacebetweenIcon: 0,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdPlaybackPage(
                                onAdComplete: _undoMove,
                              ),
                            ),
                          );
                        },
                        label: "Play ad",
                        labelColor: Colors.white,
                        iconWidget: Image.asset("assets/Ad.png", height: 28),
                      ),
                      const SizedBox(height: 12),
                      CustomIconButton(
                        width: 150,
                        height: 40,
                        onTap: () {
                          AudioHelper().playMoneySound();
                          Navigator.pop(context);
                          _undoMove();
                        },
                        label: "1",
                        labelColor: Colors.white,
                        iconWidget: Image.asset("assets/coin.png", height: 28),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleTap(int row, int col) {
    if (board[row][col] == '' &&
        !gameOver &&
        (!widget.isAI || currentPlayer == 'X')) {
      setState(() {
        moveHistory.add(_copyBoard()); // Track player's move
        board[row][col] = currentPlayer;
        if (_checkWinner(row, col)) {
          winner = currentPlayer;
          gameOver = true;
          _animationController?.forward();
        } else if (_isDraw()) {
          winner = 'Draw';
          gameOver = true;
          _showGameOverDialog('It\'s a Draw!');
        } else {
          if (widget.isAI) {
            currentPlayer = 'O';
            _makeAIMove();
          } else {
            currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          }
        }
      });
    }
  }
  List<List<String>> _copyBoard() {
    return board.map((row) => List<String>.from(row)).toList();
  }
  void _undoMove() async {
    try {
      // Call undo API
      await CoinService.undoCoins(coins: 20);

      // Proceed with local game logic
      if (moveHistory.isNotEmpty) {
        setState(() {
          board = moveHistory.removeLast();
          currentPlayer = 'X';
          winner = '';
          gameOver = false;
          winningLine = null;
          _animationController?.reset();
        });
      }
    } catch (e) {
      print('Failed to undo move: $e');
      // Optionally show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to undo. Try again.')),
      );
    }
  }

  // void _undoMove() {
  //
  //   if (moveHistory.isNotEmpty) {
  //     setState(() {
  //       board = moveHistory.removeLast(); // Revert to last player state
  //       currentPlayer = 'X'; // Always set to player's turn after undo
  //       winner = '';
  //       gameOver = false;
  //       winningLine = null;
  //       _animationController?.reset();
  //     });
  //   }
  // }
  void _makeAIMove() {
    if (gameOver) return;
    var move = widget.difficulty == 'Easy'
        ? _randomMove()
        : widget.difficulty == 'Medium'
        ? _mediumMove()
        : _hardMove();
    if (move != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          board[move![0]][move[1]] = 'O';
          if (_checkWinner(move[0], move[1])) {
            winner = 'O';
            gameOver = true;
            _animationController?.forward();
          } else if (_isDraw()) {
            winner = 'Draw';
            gameOver = true;
            _showGameOverDialog('It\'s a Draw!');
          } else {
            currentPlayer = 'X';
          }
        });
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
    if (Random().nextDouble() < 0.5) {
      return _hardMove();
    }
    return _randomMove();
  }
  List<int>? _hardMove() {
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
    if (board[row].every((cell) => cell == currentPlayer)) {
      winningLine = [
        Offset(24, row * 112.0 + 56),
        Offset(312, row * 112.0 + 56),
      ];
      return true;
    }
    if ([board[0][col], board[1][col], board[2][col]]
        .every((cell) => cell == currentPlayer)) {
      winningLine = [
        Offset(col * 112.0 + 56, 24),
        Offset(col * 112.0 + 56, 312),
      ];
      return true;
    }
    if (row == col &&
        [board[0][0], board[1][1], board[2][2]]
            .every((cell) => cell == currentPlayer)) {
      winningLine = [
        const Offset(24, 24),
        const Offset(312, 312),
      ];
      return true;
    }
    if (row + col == 2 &&
        [board[0][2], board[1][1], board[2][0]]
            .every((cell) => cell == currentPlayer)) {
      winningLine = [
        const Offset(312, 24),
        const Offset(24, 312),
      ];
      return true;
    }
    return false;
  }
  bool _checkWinnerForMinimax(List<List<String>> board, String player) {
    for (int i = 0; i < 3; i++) {
      if (board[i].every((cell) => cell == player)) return true;
      if ([board[0][i], board[1][i], board[2][i]]
          .every((cell) => cell == player)) return true;
    }
    if ([board[0][0], board[1][1], board[2][2]].every((cell) => cell == player))
      return true;
    if ([board[0][2], board[1][1], board[2][0]].every((cell) => cell == player))
      return true;
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
      winningLine = null;
      moveHistory.clear(); // Clear move history
      _animationController?.reset();
    });
    _incrementPlayCount();
    if (widget.isAI && currentPlayer == 'O') {
      _makeAIMove();
    }
  }
  Future<void> _incrementPlayCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentCount = (prefs.getInt('playCount') ?? 0) + 1;
    await prefs.setInt('playCount', currentCount);
    print('player count:- $currentCount');
    if (currentCount % 4 == 0) { // Show ad every 4 replays
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdPlaybackPage(
              onAdComplete: () {
                Navigator.pop(context);
                prefs.setInt('playCount', 0); // Reset counter after showing ad
              },
            ),
          ),
        );
      }
    }
  }
  Widget _buildCell(int row, int col) {
    String cellValue = board[row][col];
    Color bgColor;
    if (cellValue == 'X') {
      bgColor = Colors.transparent;
    } else if (cellValue == 'O') {
      bgColor = Colors.transparent;
    } else {
      bgColor = Colors.white;
    }
    return GestureDetector(
      // onTap: () => _handleTap(row, col),
      onTap: () {
        // if (AudioHelper().isSoundOn) {
        //   AudioHelper().playBackgroundMusic(); // Or better: .playMoveSound()
        // }
        AudioHelper().playMakeMove();
        _handleTap(row, col);
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.9),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          cellValue,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: cellValue == 'X'
                ? const Color(0xFFF4B52E)
                : const Color(0xFFF4B52E),
          ),
        ),
      ),
    );
  }
  void _showGameOverDialog(String message) {
    bool isDraw = message.toLowerCase().contains('draw');
    bool playerWon = message.contains('X') && !isDraw;
    bool opponentWon = message.contains('O') && !isDraw;
    bool isAgainstAIAndPlayerWon = widget.isAI && playerWon;

    if (isAgainstAIAndPlayerWon) {
      AudioHelper().playWinSound();
      AudioHelper().playMoneySound();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WinnerPage(
            coinReward: 5,
            onContinue: () {
              Navigator.pop(context);
              _resetGame();
            },
          ),
        ),
      );
    } else {
      String finalMessage = '';
      Color iconColor;

      if (isDraw) {
        AudioHelper().playLoseSound();
        finalMessage = 'Better luck next time!';
        iconColor = Colors.blue;
      } else if (message.contains('X')) {
        AudioHelper().playWinSound();
        message = widget.isAI ? 'You won!' : '$playerXName Wins!';
        finalMessage = widget.isAI
            ? 'You won against the AI!'
            : '$playerXName is the winner!';
        iconColor = widget.isAI ? Colors.yellow : Colors.blue;
      } else {
        AudioHelper().playLoseSound();
        message = widget.isAI ? 'AI Wins!' : '$playerOName Wins!';
        finalMessage = widget.isAI
            ? 'Oops! You lost this one.'
            : '$playerOName is the winner!';
        iconColor = widget.isAI ? Colors.red : Colors.blue;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFA949F2),
                  Color(0xFF3304B3),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  Icon(
                    Icons.sentiment_very_satisfied,
                    color: iconColor,
                    size: 80,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    finalMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedGradientButton(
                        width: 115,
                        text: 'Home',
                        onPressed: () {
                          AudioHelper().stopWinOrLoseSound();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                      RoundedGradientButton(
                        width: 115,
                        text: 'Replay',
                        onPressed: () {
                          AudioHelper().stopWinOrLoseSound();
                          Navigator.pop(context);
                          _resetGame();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('game.dart');
    ScreenUtil.init(context);
    return Scaffold(
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              CustomTopBar(
                // coins: 500,
                isGame: true,
                onBack: () => Navigator.pop(context),
                onSettings: () {
                  showDialog(
                    context: context,
                    builder: (context) => const SettingsDialog(),
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      const Icon(Icons.close,
                          size: 40, color: Color(0xFFF4B52E)),
                      GestureDetector(
                        onTap: () => _showNameDialog(isPlayerX: true),
                        child: Text(
                          "$playerXName's Turn",
                          style: TextStyle(
                            color: currentPlayer == 'X'
                                ? Colors.white
                                : Colors.white54,
                            fontSize: 20,
                            fontFamily: 'Pridi',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(width: 10),
                  const Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pridi',
                    ),
                  ),
                  // const SizedBox(width: 10),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      const Icon(Icons.circle_outlined,
                          size: 40, color: Color(0xFFF4B52E)),
                      widget.isAI
                          ? Text(
                        "AI's Turn",
                        style: TextStyle(
                          color: currentPlayer == 'O'
                              ? Colors.white
                              : Colors.white54,
                          fontSize: 20,
                          fontFamily: 'Pridi',
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : GestureDetector(
                        onTap: () => _showNameDialog(isPlayerX: false),
                        child: Text(
                          "$playerOName's Turn",
                          style: TextStyle(
                            color: currentPlayer == 'O'
                                ? Colors.white
                                : Colors.white54,
                            fontSize: 20,
                            fontFamily: 'Pridi',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),



              const SizedBox(height: 60),
              // widget.difficulty == ''
              //     ? SizedBox(
              //   height: 24,
              // )
              //     : Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Container(
              //       // width: 100,
              //       // width: 336,
              //       padding: EdgeInsets.only(bottom: 4,left: 15,right: 15),
              //       decoration: BoxDecoration(
              //         color: const Color(0xFF400CB9), // Deep purple
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(color: Colors.white, width: 1),
              //         boxShadow: const [
              //           BoxShadow(
              //             color: Colors.black26,
              //             blurRadius: 4,
              //             offset: Offset(0, 2),
              //           ),
              //         ],
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Text(
              //             widget.difficulty ?? '',
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontFamily: 'Pridi',
              //               fontWeight: FontWeight.w500,
              //               color: Colors.white,
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //     SizedBox(width: 50)
              //   ],
              // ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Column(
                    children: List.generate(3, (row) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (col) => _buildCell(row, col)),
                      );
                    }),
                  ),
                  // Add this Positioned widget for difficulty display
                  Positioned(
                    top: -37,
                    // left: 5,
                    // right: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width:widget.difficulty == 'Medium' ?110 : 125), // Spacer for first cell
                        Container(width:widget.difficulty == 'Medium' ?115 : 125), // Spacer for second cell
                        if(widget.difficulty != '')
                          // const SizedBox(width: 112), // Spacer for third cell
                        Container(
                          padding: const EdgeInsets.only(bottom: 5,left: 10,right: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF400CB9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.difficulty,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Pridi',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (winningLine != null)
                    CustomPaint(
                      size: const Size(336, 336),
                      painter: WinningLinePainter(
                        winningLine: winningLine!,
                        progress: _animation?.value ?? 0,
                      ),
                    ),
                ],
              ),
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Column(
              //       children: List.generate(3, (row) {
              //         return Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children:
              //           List.generate(3, (col) => _buildCell(row, col)),
              //         );
              //       }),
              //
              //     ),
              //     if (winningLine != null)
              //       CustomPaint(
              //         size: const Size(336, 336),
              //         painter: WinningLinePainter(
              //           winningLine: winningLine!,
              //           progress: _animation?.value ?? 0,
              //         ),
              //       ),
              //   ],
              // ),
              const SizedBox(height: 60),
              if (!gameOver &&
                  (widget.isAI ? currentPlayer == 'X' : true) &&
                  moveHistory.isNotEmpty)
                CustomIconButton(
                  onTap: _showUndoDialog,
                  width: 110,
                  height: 40,
                  iconPath: 'assets/undo.png',
                  label: 'Undo',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
class WinningLinePainter extends CustomPainter {
  final List<Offset> winningLine;
  final double progress;
  WinningLinePainter({required this.winningLine, required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF4B52E)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final start = winningLine[0];
    final end = winningLine[1];
    final animatedEnd = Offset(
      start.dx + (end.dx - start.dx) * progress,
      start.dy + (end.dy - start.dy) * progress,
    );
    canvas.drawLine(start, animatedEnd, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}







// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tic_tac_toe/view/winner_page.dart';
// import '../Widget/bg_container.dart';
// import '../Widget/custom_appbar.dart';
// import '../Widget/custom_button.dart';
// import '../Widget/setting_dialoug.dart';
// import '../Widget/sound.dart';
// import '../Widget/undobutton.dart';
// import 'ad_show.dart';
//
// class TicTacToeGame extends StatefulWidget {
//   final bool isAI;
//   final String difficulty;
//   final String playerXName;
//   final String playerOName;
//
//   const TicTacToeGame({
//     super.key,
//     this.isAI = false,
//     this.difficulty = 'easy',
//     this.playerXName = 'Player 1',
//     this.playerOName = 'Player 2',
//   });
//
//   @override
//   State<TicTacToeGame> createState() => _TicTacToeGameState();
// }
//
// class _TicTacToeGameState extends State<TicTacToeGame>
//     with SingleTickerProviderStateMixin {
//   late String playerXName;
//   late String playerOName;
//   int _playCount = 0;
//   List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
//   String currentPlayer = 'X';
//   String winner = '';
//   bool gameOver = false;
//   List<List<List<String>>> moveHistory = [];
//   List<Offset>? winningLine;
//   AnimationController? _animationController;
//   Animation<double>? _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPlayerNames();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _loadPlayCount();
//     _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _showGameOverDialog('$winner Wins!');
//         }
//       });
//
//     if (widget.isAI && currentPlayer == 'O') {
//       _makeAIMove();
//     }
//   }
//   Future<void> _loadPlayCount() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _playCount = prefs.getInt('playCount') ?? 0;
//     });
//   }
//   // Future<void> _showNameDialog({required bool isPlayerX}) async {
//   //   String currentName = isPlayerX ? playerXName : playerOName;
//   //   TextEditingController controller = TextEditingController(text: currentName);
//   //
//   //   await showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: Text('Enter ${isPlayerX ? 'Player X' : 'Player O'} Name'),
//   //       content: TextField(
//   //         controller: controller,
//   //         autofocus: true,
//   //       ),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: const Text('Cancel'),
//   //         ),
//   //         TextButton(
//   //           onPressed: () async {
//   //             String newName = controller.text.trim();
//   //             if (newName.isNotEmpty) {
//   //               SharedPreferences prefs = await SharedPreferences.getInstance();
//   //               if (isPlayerX) {
//   //                 await prefs.setString('playerXName', newName);
//   //                 setState(() => playerXName = newName);
//   //               } else if (!widget.isAI) {
//   //                 await prefs.setString('playerOName', newName);
//   //                 setState(() => playerOName = newName);
//   //               }
//   //               Navigator.pop(context);
//   //             }
//   //           },
//   //           child: const Text('Save'),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   Future<void> _showNameDialog({required bool isPlayerX}) async {
//     String currentName = isPlayerX ? playerXName : playerOName;
//     TextEditingController controller = TextEditingController(text: currentName);
//
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.transparent,
//           contentPadding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           content: Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Enter ${isPlayerX ? 'Player X' : 'Player O'} Name',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontFamily: 'Pridi',
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: controller,
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     labelText: 'Name',
//                     labelStyle: const TextStyle(color: Colors.white),
//                     border: const OutlineInputBorder(),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.2),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       style: TextButton.styleFrom(foregroundColor: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Cancel'),
//                     ),
//                     const SizedBox(width: 10),
//                     RoundedGradientButton(
//                       width: 100,
//                       height: 40,
//                       text: 'Save',
//                       onPressed: () async {
//                         String newName = controller.text.trim();
//                         if (newName.isNotEmpty) {
//                           final prefs = await SharedPreferences.getInstance();
//                           if (isPlayerX) {
//                             await prefs.setString('playerXName', newName);
//                             setState(() => playerXName = newName);
//                           } else if (!widget.isAI) {
//                             await prefs.setString('playerOName', newName);
//                             setState(() => playerOName = newName);
//                           }
//                           Navigator.pop(context);
//                         }
//                       },
//                     ),
//                     // ElevatedButton(
//                     //   style: ElevatedButton.styleFrom(
//                     //     backgroundColor: Colors.white,
//                     //     foregroundColor: Color(0xFF3304B3),
//                     //     shape: RoundedRectangleBorder(
//                     //       borderRadius: BorderRadius.circular(10),
//                     //     ),
//                     //   ),
//                     //   onPressed: () async {
//                     //     String newName = controller.text.trim();
//                     //     if (newName.isNotEmpty) {
//                     //       final prefs = await SharedPreferences.getInstance();
//                     //       if (isPlayerX) {
//                     //         await prefs.setString('playerXName', newName);
//                     //         setState(() => playerXName = newName);
//                     //       } else if (!widget.isAI) {
//                     //         await prefs.setString('playerOName', newName);
//                     //         setState(() => playerOName = newName);
//                     //       }
//                     //       Navigator.pop(context);
//                     //     }
//                     //   },
//                     //   child: const Text('Save'),
//                     // ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   Future<void> _loadPlayerNames() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       playerXName = prefs.getString('playerXName') ?? widget.playerXName;
//       playerOName = widget.isAI
//           ? 'AI'
//           : prefs.getString('playerOName') ?? widget.playerOName;
//     });
//   }
//
//   @override
//   void dispose() {
//     _animationController?.dispose();
//     super.dispose();
//   }
//
//   void _showUndoDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: 380,
//             height: 204,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Stack(
//               children: [
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Are you sure to undo?",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Pridi',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       CustomIconButton(
//                         height: 45,
//                         spacebetweenIcon: 0,
//                         onTap: () {
//                           Navigator.pop(context);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AdPlaybackPage(
//                                 onAdComplete: _undoMove,
//                               ),
//                             ),
//                           );
//                         },
//                         label: "Play ad",
//                         labelColor: Colors.white,
//                         iconWidget: Image.asset("assets/Ad.png", height: 28),
//                       ),
//                       const SizedBox(height: 12),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           AudioHelper().playMoneySound();
//                           Navigator.pop(context);
//                           _undoMove();
//                         },
//                         label: "1",
//                         labelColor: Colors.white,
//                         iconWidget: Image.asset("assets/coin.png", height: 28),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.close, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _handleTap(int row, int col) {
//     if (board[row][col] == '' &&
//         !gameOver &&
//         (!widget.isAI || currentPlayer == 'X')) {
//       setState(() {
//         moveHistory.add(_copyBoard()); // Track player's move
//         board[row][col] = currentPlayer;
//         if (_checkWinner(row, col)) {
//           winner = currentPlayer;
//           gameOver = true;
//           _animationController?.forward();
//         } else if (_isDraw()) {
//           winner = 'Draw';
//           gameOver = true;
//           _showGameOverDialog('It\'s a Draw!');
//         } else {
//           if (widget.isAI) {
//             currentPlayer = 'O';
//             _makeAIMove();
//           } else {
//             currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//           }
//         }
//       });
//     }
//   }
//
//   List<List<String>> _copyBoard() {
//     return board.map((row) => List<String>.from(row)).toList();
//   }
//
//   void _undoMove() {
//     if (moveHistory.isNotEmpty) {
//       setState(() {
//         board = moveHistory.removeLast(); // Revert to last player state
//         currentPlayer = 'X'; // Always set to player's turn after undo
//         winner = '';
//         gameOver = false;
//         winningLine = null;
//         _animationController?.reset();
//       });
//     }
//   }
//
//   void _makeAIMove() {
//     if (gameOver) return;
//
//     var move = widget.difficulty == 'Easy'
//         ? _randomMove()
//         : widget.difficulty == 'Medium'
//             ? _mediumMove()
//             : _hardMove();
//
//     if (move != null) {
//       Future.delayed(const Duration(milliseconds: 500), () {
//         setState(() {
//           // Do NOT add to moveHistory here
//           board[move![0]][move[1]] = 'O';
//           if (_checkWinner(move[0], move[1])) {
//
//             winner = 'O';
//             gameOver = true;
//             _animationController?.forward();
//           } else if (_isDraw()) {
//             winner = 'Draw';
//             gameOver = true;
//             _showGameOverDialog('It\'s a Draw!');
//           } else {
//             currentPlayer = 'X';
//           }
//         });
//       });
//     }
//   }
//
//   List<int>? _randomMove() {
//     List<List<int>> emptyCells = [];
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           emptyCells.add([i, j]);
//         }
//       }
//     }
//     if (emptyCells.isNotEmpty) {
//       return emptyCells[Random().nextInt(emptyCells.length)];
//     }
//     return null;
//   }
//
//   List<int>? _mediumMove() {
//     if (Random().nextDouble() < 0.5) {
//       return _hardMove();
//     }
//     return _randomMove();
//   }
//
//   List<int>? _hardMove() {
//     int bestScore = -1000;
//     List<int>? bestMove;
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           board[i][j] = 'O';
//           int score = _minimax(board, 0, false);
//           board[i][j] = '';
//           if (score > bestScore) {
//             bestScore = score;
//             bestMove = [i, j];
//           }
//         }
//       }
//     }
//     return bestMove;
//   }
//
//   int _minimax(List<List<String>> board, int depth, bool isMaximizing) {
//     if (_checkWinnerForMinimax(board, 'O')) return 10 - depth;
//     if (_checkWinnerForMinimax(board, 'X')) return depth - 10;
//     if (_isDrawForMinimax(board)) return 0;
//
//     if (isMaximizing) {
//       int bestScore = -1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'O';
//             int score = _minimax(board, depth + 1, false);
//             board[i][j] = '';
//             bestScore = max(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     } else {
//       int bestScore = 1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'X';
//             int score = _minimax(board, depth + 1, true);
//             board[i][j] = '';
//             bestScore = min(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     }
//   }
//
//   bool _checkWinner(int row, int col) {
//     if (board[row].every((cell) => cell == currentPlayer)) {
//       winningLine = [
//         Offset(24, row * 112.0 + 56),
//         Offset(312, row * 112.0 + 56),
//       ];
//       return true;
//     }
//     if ([board[0][col], board[1][col], board[2][col]]
//         .every((cell) => cell == currentPlayer)) {
//       winningLine = [
//         Offset(col * 112.0 + 56, 24),
//         Offset(col * 112.0 + 56, 312),
//       ];
//       return true;
//     }
//     if (row == col &&
//         [board[0][0], board[1][1], board[2][2]]
//             .every((cell) => cell == currentPlayer)) {
//       winningLine = [
//         const Offset(24, 24),
//         const Offset(312, 312),
//       ];
//       return true;
//     }
//     if (row + col == 2 &&
//         [board[0][2], board[1][1], board[2][0]]
//             .every((cell) => cell == currentPlayer)) {
//       winningLine = [
//         const Offset(312, 24),
//         const Offset(24, 312),
//       ];
//       return true;
//     }
//     return false;
//   }
//
//   bool _checkWinnerForMinimax(List<List<String>> board, String player) {
//     for (int i = 0; i < 3; i++) {
//       if (board[i].every((cell) => cell == player)) return true;
//       if ([board[0][i], board[1][i], board[2][i]]
//           .every((cell) => cell == player)) return true;
//     }
//     if ([board[0][0], board[1][1], board[2][2]].every((cell) => cell == player))
//       return true;
//     if ([board[0][2], board[1][1], board[2][0]].every((cell) => cell == player))
//       return true;
//     return false;
//   }
//
//   bool _isDraw() {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//
//   bool _isDrawForMinimax(List<List<String>> board) {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//
//   void _resetGame() {
//     setState(() {
//       board = List.generate(3, (_) => List.filled(3, ''));
//       currentPlayer = 'X';
//       winner = '';
//       gameOver = false;
//       winningLine = null;
//       moveHistory.clear(); // Clear move history
//       _animationController?.reset();
//     });
//     _incrementPlayCount();
//     if (widget.isAI && currentPlayer == 'O') {
//       _makeAIMove();
//     }
//   }
//   Future<void> _incrementPlayCount() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int currentCount = (prefs.getInt('playCount') ?? 0) + 1;
//     await prefs.setInt('playCount', currentCount);
//     print('player count:- $currentCount');
//     if (currentCount % 4 == 0) { // Show ad every 4 replays
//       if (mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AdPlaybackPage(
//               onAdComplete: () {
//                 Navigator.pop(context);
//                 prefs.setInt('playCount', 0); // Reset counter after showing ad
//               },
//             ),
//           ),
//         );
//       }
//     }
//   }
//   Widget _buildCell(int row, int col) {
//     String cellValue = board[row][col];
//     Color bgColor;
//     if (cellValue == 'X') {
//       bgColor = Colors.transparent;
//     } else if (cellValue == 'O') {
//       bgColor = Colors.transparent;
//     } else {
//       bgColor = Colors.white;
//     }
//     return GestureDetector(
//       // onTap: () => _handleTap(row, col),
//       onTap: () {
//         // if (AudioHelper().isSoundOn) {
//         //   AudioHelper().playBackgroundMusic(); // Or better: .playMoveSound()
//         // }
//         AudioHelper().playMakeMove();
//         _handleTap(row, col);
//       },
//       child: Container(
//         margin: const EdgeInsets.all(6),
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(0),
//           border: Border.all(
//             color: Colors.white.withValues(alpha: 0.9),
//             width: 1,
//           ),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           cellValue,
//           style: TextStyle(
//             fontSize: 50,
//             fontWeight: FontWeight.bold,
//             color: cellValue == 'X'
//                 ? const Color(0xFFF4B52E)
//                 : const Color(0xFFF4B52E),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showGameOverDialog(String message) {
//     bool isDraw = message.toLowerCase().contains('draw');
//     bool playerWon = message.contains('X') && !isDraw;
//     bool opponentWon = message.contains('O') && !isDraw;
//     bool isAgainstAIAndPlayerWon = widget.isAI && playerWon;
//
//     if (isAgainstAIAndPlayerWon) {
//       AudioHelper().playWinSound();
//       AudioHelper().playMoneySound();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => WinnerPage(
//             coinReward: 20,
//             onContinue: () {
//               Navigator.pop(context);
//               _resetGame();
//             },
//           ),
//         ),
//       );
//     } else {
//       String finalMessage = '';
//       Color iconColor;
//
//       if (isDraw) {
//         AudioHelper().playLoseSound();
//         finalMessage = 'Better luck next time!';
//         iconColor = Colors.blue;
//       } else if (message.contains('X')) {
//         AudioHelper().playWinSound();
//         message = widget.isAI ? 'You won!' : '$playerXName Wins!';
//         finalMessage = widget.isAI
//             ? 'You won against the AI!'
//             : '$playerXName is the winner!';
//         iconColor = widget.isAI ? Colors.yellow : Colors.blue;
//       } else {
//         AudioHelper().playLoseSound();
//         message = widget.isAI ? 'AI Wins!' : '$playerOName Wins!';
//         finalMessage = widget.isAI
//             ? 'Oops! You lost this one.'
//             : '$playerOName is the winner!';
//         iconColor = widget.isAI ? Colors.red : Colors.blue;
//       }
//
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => AlertDialog(
//           backgroundColor: Colors.transparent,
//           contentPadding: EdgeInsets.zero,
//           titlePadding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           content: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xFFA949F2),
//                   Color(0xFF3304B3),
//                 ],
//               ),
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     message,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Icon(
//                     Icons.sentiment_very_satisfied,
//                     color: iconColor,
//                     size: 80,
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     finalMessage,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       RoundedGradientButton(
//                         width: 115,
//                         text: 'Home',
//                         onPressed: () {
//                           AudioHelper().stopWinOrLoseSound();
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                         },
//                       ),
//                       RoundedGradientButton(
//                         width: 115,
//                         text: 'Replay',
//                         onPressed: () {
//                           AudioHelper().stopWinOrLoseSound();
//                           Navigator.pop(context);
//                           _resetGame();
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('game.dart');
//     ScreenUtil.init(context);
//     return Scaffold(
//       body: BackgroundContainer(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40),
//               CustomTopBar(
//                 coins: 500,
//                 isGame: true,
//                 onBack: () => Navigator.pop(context),
//                 onSettings: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => const SettingsDialog(),
//                   );
//                 },
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Column(
//                   //   children: [
//                   //     const SizedBox(height: 10),
//                   //     const Icon(Icons.close,
//                   //         size: 40, color: Color(0xFFF4B52E)),
//                   //     Text(
//                   //       // widget.isAI ? 'Player\'s Turn' : 'Player 1\'s Turn',
//                   //       widget.isAI
//                   //           ? 'Your Turn'
//                   //           : '${widget.playerXName}\'s Turn',
//                   //       style: TextStyle(
//                   //         color: currentPlayer == 'X'
//                   //             ? Colors.white
//                   //             : Colors.white54,
//                   //         fontSize: 20,
//                   //         fontFamily: 'Pridi',
//                   //         fontWeight: FontWeight.bold,
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                   Column(
//                     children: [
//                       const SizedBox(height: 10),
//                       const Icon(Icons.close,
//                           size: 40, color: Color(0xFFF4B52E)),
//                       GestureDetector(
//                         onTap: () => _showNameDialog(isPlayerX: true),
//                         child: Text(
//                           "$playerXName's Turn",
//                           style: TextStyle(
//                             color: currentPlayer == 'X'
//                                 ? Colors.white
//                                 : Colors.white54,
//                             fontSize: 20,
//                             fontFamily: 'Pridi',
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 10),
//                   const Text(
//                     'VS',
//                     style: TextStyle(
//                       fontSize: 24,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'Pridi',
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   // Column(
//                   //   children: [
//                   //     const SizedBox(height: 10),
//                   //     const Icon(Icons.circle_outlined,
//                   //         size: 40, color: Color(0xFFF4B52E)),
//                   //     Text(
//                   //       // widget.isAI ? 'AI\'s Turn' : 'Player 2\'s Turn',
//                   //       widget.isAI ? 'AI\'s Turn' : '${widget.playerOName}\'s Turn',
//                   //       style: TextStyle(
//                   //         color: currentPlayer == 'O'
//                   //             ? Colors.white
//                   //             : Colors.white54,
//                   //         fontSize: 20,
//                   //         fontFamily: 'Pridi',
//                   //         fontWeight: FontWeight.bold,
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                   Column(
//                     children: [
//                       const SizedBox(height: 10),
//                       const Icon(Icons.circle_outlined,
//                           size: 40, color: Color(0xFFF4B52E)),
//                       widget.isAI
//                           ? Text(
//                               "AI's Turn",
//                               style: TextStyle(
//                                 color: currentPlayer == 'O'
//                                     ? Colors.white
//                                     : Colors.white54,
//                                 fontSize: 20,
//                                 fontFamily: 'Pridi',
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                           : GestureDetector(
//                               onTap: () => _showNameDialog(isPlayerX: false),
//                               child: Text(
//                                 "$playerOName's Turn",
//                                 style: TextStyle(
//                                   color: currentPlayer == 'O'
//                                       ? Colors.white
//                                       : Colors.white54,
//                                   fontSize: 20,
//                                   fontFamily: 'Pridi',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 60),
//               widget.difficulty == ''
//                   ? SizedBox(
//                       height: 24,
//                     )
//                   : Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Container(
//                         // width: 100,
//                         width: 100,
//                         padding: EdgeInsets.only(bottom: 4),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF400CB9), // Deep purple
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.white, width: 1),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               widget.difficulty ?? '',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontFamily: 'Pridi',
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 50)
//                     ],
//                   ),
//               // Padding(
//               //         padding: const EdgeInsets.only(right: 50.0, left: 280),
//               //         child: Container(
//               //           // width: 100,
//               //             width: 100,
//               //           padding: EdgeInsets.only(bottom: 4),
//               //           decoration: BoxDecoration(
//               //             color: const Color(0xFF400CB9), // Deep purple
//               //             borderRadius: BorderRadius.circular(12),
//               //             border: Border.all(color: Colors.white, width: 1),
//               //             boxShadow: const [
//               //               BoxShadow(
//               //                 color: Colors.black26,
//               //                 blurRadius: 4,
//               //                 offset: Offset(0, 2),
//               //               ),
//               //             ],
//               //           ),
//               //           child: Row(
//               //             mainAxisAlignment: MainAxisAlignment.center,
//               //             crossAxisAlignment: CrossAxisAlignment.center,
//               //             children: [
//               //               Text(
//               //                 widget.difficulty ?? '',
//               //                 style: TextStyle(
//               //                   fontSize: 20,
//               //                   fontFamily: 'Pridi',
//               //                   fontWeight: FontWeight.w500,
//               //                   color: Colors.white,
//               //                 ),
//               //               )
//               //             ],
//               //           ),
//               //         ),
//               //       ),
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Column(
//                     children: List.generate(3, (row) {
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children:
//                             List.generate(3, (col) => _buildCell(row, col)),
//                       );
//                     }),
//                   ),
//                   if (winningLine != null)
//                     CustomPaint(
//                       size: const Size(336, 336),
//                       painter: WinningLinePainter(
//                         winningLine: winningLine!,
//                         progress: _animation?.value ?? 0,
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 60),
//               if (!gameOver &&
//                   (widget.isAI ? currentPlayer == 'X' : true) &&
//                   moveHistory.isNotEmpty)
//                 CustomIconButton(
//                   onTap: _showUndoDialog,
//                   width: 110,
//                   height: 40,
//                   iconPath: 'assets/undo.png',
//                   label: 'Undo',
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WinningLinePainter extends CustomPainter {
//   final List<Offset> winningLine;
//   final double progress;
//
//   WinningLinePainter({required this.winningLine, required this.progress});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFF4B52E)
//       ..strokeWidth = 8
//       ..strokeCap = StrokeCap.round;
//
//     final start = winningLine[0];
//     final end = winningLine[1];
//
//     final animatedEnd = Offset(
//       start.dx + (end.dx - start.dx) * progress,
//       start.dy + (end.dy - start.dy) * progress,
//     );
//
//     canvas.drawLine(start, animatedEnd, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tic_tac_toe/view/winner_page.dart';
// import '../Widget/bg_container.dart';
// import '../Widget/custom_appbar.dart';
// import '../Widget/custom_button.dart';
// import '../Widget/setting_dialoug.dart';
// import '../Widget/undobutton.dart';
// import 'ad_show.dart';
//
// class TicTacToeGame extends StatefulWidget {
//   final bool isAI;
//   final String difficulty;
//   final String playerXName;
//   final String playerOName;
//
//   const TicTacToeGame({
//     super.key,
//     this.isAI = false,
//     this.difficulty = 'easy',
//     this.playerXName = 'Player 1',
//     this.playerOName = 'Player 2',
//   });
//
//   @override
//   State<TicTacToeGame> createState() => _TicTacToeGameState();
// }
//
// class _TicTacToeGameState extends State<TicTacToeGame>
//     with SingleTickerProviderStateMixin {
//   List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
//   String currentPlayer = 'X';
//   String winner = '';
//   bool gameOver = false;
//   List<List<List<String>>> moveHistory = [];
//   List<Offset>? winningLine;
//   AnimationController? _animationController;
//   Animation<double>? _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _showGameOverDialog('$winner Wins!');
//         }
//       });
//
//     if (widget.isAI && currentPlayer == 'O') {
//       _makeAIMove();
//     }
//   }
//
//   @override
//   void dispose() {
//     _animationController?.dispose();
//     super.dispose();
//   }
//
//   void _showUndoDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: 380,
//             height: 204,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Stack(
//               children: [
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Are you sure to undo?",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Pridi',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       CustomIconButton(
//                         height: 45,
//                         spacebetweenIcon: 0,
//                         onTap: () {
//                           Navigator.pop(context);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AdPlaybackPage(
//                                 onAdComplete: _undoMove,
//                               ),
//                             ),
//                           );
//                         },
//                         label: "Play AD",
//                         labelColor: Colors.white,
//                         iconWidget: Image.asset("assets/Ad.png", height: 28),
//                       ),
//                       const SizedBox(height: 12),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _showUseCoinConfirmationDialog();
//                         },
//                         label: "1",
//                         labelColor: Colors.white,
//                         iconWidget: Image.asset("assets/coin.png", height: 28),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.close, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showUseCoinConfirmationDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: 380,
//             height: 204,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Stack(
//               children: [
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Are you sure to use a coin?",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Pridi',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _undoMove();
//                         },
//                         label: "Yes",
//                         labelColor: Colors.white,
//                       ),
//                       const SizedBox(height: 12),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _showUndoDialog();
//                         },
//                         label: "No",
//                         labelColor: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.close, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // void _handleTap(int row, int col) {
//   //   if (board[row][col] == '' && !gameOver && (!widget.isAI || currentPlayer == 'X')) {
//   //     setState(() {
//   //       moveHistory.add(_copyBoard());
//   //       board[row][col] = currentPlayer;
//   //       if (_checkWinner(row, col)) {
//   //         winner = currentPlayer;
//   //         gameOver = true;
//   //         _animationController?.forward();
//   //       } else if (_isDraw()) {
//   //         winner = 'Draw';
//   //         gameOver = true;
//   //         _showGameOverDialog('It\'s a Draw!');
//   //       } else {
//   //         // Corrected player switching logic
//   //         if (widget.isAI) {
//   //           currentPlayer = 'O'; // Switch to AI's turn
//   //           _makeAIMove();
//   //         } else {
//   //           currentPlayer = currentPlayer == 'X' ? 'O' : 'X'; // Toggle for two-player
//   //         }
//   //       }
//   //     });
//   //   }
//   // }
//   void _handleTap(int row, int col) {
//     if (board[row][col] == '' &&
//         !gameOver &&
//         (!widget.isAI || currentPlayer == 'X')) {
//       setState(() {
//         moveHistory.add(_copyBoard()); // Track player's move
//         board[row][col] = currentPlayer;
//         if (_checkWinner(row, col)) {
//           winner = currentPlayer;
//           gameOver = true;
//           _animationController?.forward();
//         } else if (_isDraw()) {
//           winner = 'Draw';
//           gameOver = true;
//           _showGameOverDialog('It\'s a Draw!');
//         } else {
//           if (widget.isAI) {
//             currentPlayer = 'O';
//             _makeAIMove();
//           } else {
//             currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//           }
//         }
//       });
//     }
//   }
//
//   List<List<String>> _copyBoard() {
//     return board.map((row) => List<String>.from(row)).toList();
//   }
//
//   void _undoMove() {
//     if (moveHistory.isNotEmpty) {
//       setState(() {
//         board = moveHistory.removeLast(); // Revert to last player state
//         currentPlayer = 'X'; // Always set to player's turn after undo
//         winner = '';
//         gameOver = false;
//         winningLine = null;
//         _animationController?.reset();
//       });
//     }
//   }
//
//   // void _undoMove() {
//   //   if (moveHistory.isNotEmpty) {
//   //     setState(() {
//   //       if (widget.isAI) {
//   //         // When playing with AI, undo two moves (player's and AI's)
//   //         if (moveHistory.length >= 2 && currentPlayer == 'X') {
//   //           // Remove AI's move
//   //           moveHistory.removeLast();
//   //           // Restore to state before player's move
//   //           board = moveHistory.removeLast();
//   //         } else if (moveHistory.length == 1 && currentPlayer == 'X') {
//   //           // Only player's move exists
//   //           board = moveHistory.removeLast();
//   //         }
//   //         currentPlayer = 'X'; // Set back to player's turn
//   //       } else {
//   //         // Without AI, undo the last move
//   //         board = moveHistory.removeLast();
//   //         currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//   //       }
//   //       winner = '';
//   //       gameOver = false;
//   //       winningLine = null;
//   //       _animationController?.reset();
//   //     });
//   //   }
//   // }
//
//   // void _makeAIMove() {
//   //   if (gameOver) return;
//   //
//   //   // Get AI's move
//   //   var move = widget.difficulty == 'easy'
//   //       ? _randomMove()
//   //       : widget.difficulty == 'medium'
//   //       ? _mediumMove()
//   //       : _hardMove();
//   //
//   //   if (move != null) {
//   //     Future.delayed(const Duration(milliseconds: 500), () {
//   //       setState(() {
//   //         moveHistory.add(_copyBoard());
//   //         board[move![0]][move[1]] = 'O'; // Directly update the board
//   //         if (_checkWinner(move[0], move[1])) {
//   //           winner = 'O';
//   //           gameOver = true;
//   //           _animationController?.forward();
//   //         } else if (_isDraw()) {
//   //           winner = 'Draw';
//   //           gameOver = true;
//   //           _showGameOverDialog('It\'s a Draw!');
//   //         } else {
//   //           currentPlayer = 'X'; // Switch back to player
//   //         }
//   //       });
//   //     });
//   //   }
//   // }
//   void _makeAIMove() {
//     if (gameOver) return;
//
//     var move = widget.difficulty == 'Easy'
//         ? _randomMove()
//         : widget.difficulty == 'Medium'
//             ? _mediumMove()
//             : _hardMove();
//
//     if (move != null) {
//       Future.delayed(const Duration(milliseconds: 500), () {
//         setState(() {
//           // Do NOT add to moveHistory here
//           board[move![0]][move[1]] = 'O';
//           if (_checkWinner(move[0], move[1])) {
//             winner = 'O';
//             gameOver = true;
//             _animationController?.forward();
//           } else if (_isDraw()) {
//             winner = 'Draw';
//             gameOver = true;
//             _showGameOverDialog('It\'s a Draw!');
//           } else {
//             currentPlayer = 'X';
//           }
//         });
//       });
//     }
//   }
//
//   List<int>? _randomMove() {
//     List<List<int>> emptyCells = [];
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           emptyCells.add([i, j]);
//         }
//       }
//     }
//     if (emptyCells.isNotEmpty) {
//       return emptyCells[Random().nextInt(emptyCells.length)];
//     }
//     return null;
//   }
//
//   List<int>? _mediumMove() {
//     if (Random().nextDouble() < 0.5) {
//       return _hardMove();
//     }
//     return _randomMove();
//   }
//
//   List<int>? _hardMove() {
//     int bestScore = -1000;
//     List<int>? bestMove;
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           board[i][j] = 'O';
//           int score = _minimax(board, 0, false);
//           board[i][j] = '';
//           if (score > bestScore) {
//             bestScore = score;
//             bestMove = [i, j];
//           }
//         }
//       }
//     }
//     return bestMove;
//   }
//
//   int _minimax(List<List<String>> board, int depth, bool isMaximizing) {
//     if (_checkWinnerForMinimax(board, 'O')) return 10 - depth;
//     if (_checkWinnerForMinimax(board, 'X')) return depth - 10;
//     if (_isDrawForMinimax(board)) return 0;
//
//     if (isMaximizing) {
//       int bestScore = -1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'O';
//             int score = _minimax(board, depth + 1, false);
//             board[i][j] = '';
//             bestScore = max(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     } else {
//       int bestScore = 1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'X';
//             int score = _minimax(board, depth + 1, true);
//             board[i][j] = '';
//             bestScore = min(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     }
//   }
//
//   bool _checkWinner(int row, int col) {
//     if (board[row].every((cell) => cell == currentPlayer)) {
//       winningLine = [
//         Offset(24, row * 112.0 + 56),
//         Offset(312, row * 112.0 + 56),
//       ];
//       return true;
//     }
//     if ([board[0][col], board[1][col], board[2][col]]
//         .every((cell) => cell == currentPlayer)) {
//       winningLine = [
//         Offset(col * 112.0 + 56, 24),
//         Offset(col * 112.0 + 56, 312),
//       ];
//       return true;
//     }
//     if (row == col &&
//         [board[0][0], board[1][1], board[2][2]]
//             .every((cell) => cell == currentPlayer)) {
//       winningLine = [
//         const Offset(24, 24),
//         const Offset(312, 312),
//       ];
//       return true;
//     }
//     if (row + col == 2 &&
//         [board[0][2], board[1][1], board[2][0]]
//             .every((cell) => cell == currentPlayer)) {
//       winningLine = [
//         const Offset(312, 24),
//         const Offset(24, 312),
//       ];
//       return true;
//     }
//     return false;
//   }
//
//   bool _checkWinnerForMinimax(List<List<String>> board, String player) {
//     for (int i = 0; i < 3; i++) {
//       if (board[i].every((cell) => cell == player)) return true;
//       if ([board[0][i], board[1][i], board[2][i]]
//           .every((cell) => cell == player)) return true;
//     }
//     if ([board[0][0], board[1][1], board[2][2]].every((cell) => cell == player))
//       return true;
//     if ([board[0][2], board[1][1], board[2][0]].every((cell) => cell == player))
//       return true;
//     return false;
//   }
//
//   bool _isDraw() {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//
//   bool _isDrawForMinimax(List<List<String>> board) {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//
//   void _resetGame() {
//     setState(() {
//       board = List.generate(3, (_) => List.filled(3, ''));
//       currentPlayer = 'X';
//       winner = '';
//       gameOver = false;
//       winningLine = null;
//       moveHistory.clear(); // Clear move history
//       _animationController?.reset();
//     });
//     if (widget.isAI && currentPlayer == 'O') {
//       _makeAIMove();
//     }
//   }
//
//   // void _resetGame() {
//   //   setState(() {
//   //     board = List.generate(3, (_) => List.filled(3, ''));
//   //     currentPlayer = 'X';
//   //     winner = '';
//   //     gameOver = false;
//   //     winningLine = null;
//   //     _animationController?.reset();
//   //   });
//   //   if (widget.isAI && currentPlayer == 'O') {
//   //     _makeAIMove();
//   //   }
//   // }
//
//   Widget _buildCell(int row, int col) {
//     String cellValue = board[row][col];
//     Color bgColor;
//     if (cellValue == 'X') {
//       bgColor = Colors.transparent;
//     } else if (cellValue == 'O') {
//       bgColor = Colors.transparent;
//     } else {
//       bgColor = Colors.white;
//     }
//     return GestureDetector(
//       onTap: () => _handleTap(row, col),
//       child: Container(
//         margin: const EdgeInsets.all(6),
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(0),
//           border: Border.all(
//             color: Colors.white.withValues(alpha: 0.9),
//             width: 1,
//           ),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           cellValue,
//           style: TextStyle(
//             fontSize: 50,
//             fontWeight: FontWeight.bold,
//             color: cellValue == 'X'
//                 ? const Color(0xFFF4B52E)
//                 : const Color(0xFFF4B52E),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // void _showGameOverDialog(String message) {
//   //   bool isDraw = message.toLowerCase().contains('draw');
//   //   bool playerWon = message.contains('X') && !isDraw;
//   //   bool opponentWon = message.contains('O') && !isDraw;
//   //   bool isAgainstAIAndPlayerWon = widget.isAI && playerWon;
//   //
//   //   if (isAgainstAIAndPlayerWon) {
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => WinnerPage(
//   //           coinReward: 20,
//   //           onContinue: () {
//   //             Navigator.pop(context);
//   //             _resetGame();
//   //           },
//   //         ),
//   //       ),
//   //     );
//   //   } else {
//   //     String finalMessage = '';
//   //     Color iconColor;
//   //
//   //     if (isDraw) {
//   //       finalMessage = 'Better luck next time!';
//   //       iconColor = Colors.blue;
//   //     } else if (message.contains('X')) {
//   //       message = widget.isAI ? 'You won!' : 'Player 1 Wins!';
//   //       finalMessage =
//   //           widget.isAI ? 'You won against the AI!' : 'Player 1 is the winner!';
//   //       iconColor = widget.isAI ? Colors.yellow : Colors.blue;
//   //     } else {
//   //       message = widget.isAI ? 'AI Wins!' : 'Player 2 Wins!';
//   //       finalMessage =
//   //           widget.isAI ? 'Oops! You lost this one.' : 'Player 2 played well!';
//   //       iconColor = widget.isAI ? Colors.red : Colors.blue;
//   //     }
//   //
//   //     showDialog(
//   //       context: context,
//   //       barrierDismissible: false,
//   //       builder: (_) => AlertDialog(
//   //         backgroundColor: Colors.transparent,
//   //         contentPadding: EdgeInsets.zero,
//   //         titlePadding: EdgeInsets.zero,
//   //         shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.circular(20),
//   //         ),
//   //         content: Container(
//   //           decoration: const BoxDecoration(
//   //             gradient: LinearGradient(
//   //               begin: Alignment.topCenter,
//   //               end: Alignment.bottomCenter,
//   //               colors: [
//   //                 Color(0xFFA949F2),
//   //                 Color(0xFF3304B3),
//   //               ],
//   //             ),
//   //             borderRadius: BorderRadius.all(Radius.circular(20)),
//   //           ),
//   //           child: Padding(
//   //             padding: const EdgeInsets.all(16.0),
//   //             child: Column(
//   //               mainAxisSize: MainAxisSize.min,
//   //               children: [
//   //                 Text(
//   //                   message,
//   //                   textAlign: TextAlign.center,
//   //                   style: const TextStyle(
//   //                     color: Colors.white,
//   //                     fontWeight: FontWeight.bold,
//   //                     fontSize: 24,
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 10),
//   //                 Icon(
//   //                   Icons.sentiment_very_satisfied,
//   //                   color: iconColor,
//   //                   size: 80,
//   //                 ),
//   //                 const SizedBox(height: 10),
//   //                 Text(
//   //                   finalMessage,
//   //                   textAlign: TextAlign.center,
//   //                   style: const TextStyle(
//   //                     color: Colors.white,
//   //                     fontSize: 16,
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 20),
//   //                 Row(
//   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                   children: [
//   //                     RoundedGradientButton(
//   //                       width: 115,
//   //                       text: 'Home',
//   //                       onPressed: () {
//   //                         Navigator.pop(context);
//   //                         Navigator.pop(context);
//   //                       },
//   //                     ),
//   //                     RoundedGradientButton(
//   //                       width: 115,
//   //                       text: 'Replay',
//   //                       onPressed: () {
//   //                         Navigator.pop(context);
//   //                         _resetGame();
//   //                       },
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //   }
//   // }
//
//
//   void _showGameOverDialog(String message) {
//     bool isDraw = message.toLowerCase().contains('draw');
//     bool playerWon = message.contains('X') && !isDraw;
//     bool opponentWon = message.contains('O') && !isDraw;
//     bool isAgainstAIAndPlayerWon = widget.isAI && playerWon;
//
//     if (isAgainstAIAndPlayerWon) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => WinnerPage(
//             coinReward: 20,
//             onContinue: () {
//               Navigator.pop(context);
//               _resetGame();
//             },
//           ),
//         ),
//       );
//     } else {
//       String finalMessage = '';
//       Color iconColor;
//
//       if (isDraw) {
//         finalMessage = 'Better luck next time!';
//         iconColor = Colors.blue;
//       } else if (message.contains('X')) {
//         // Modified player name display
//         message = widget.isAI ? 'You won!' : '${widget.playerXName} Wins!';
//         finalMessage = widget.isAI
//             ? 'You won against the AI!'
//             : '${widget.playerXName} is the winner!';
//         iconColor = widget.isAI ? Colors.yellow : Colors.blue;
//       } else {
//         // Modified player name display
//         message = widget.isAI ? 'AI Wins!' : '${widget.playerOName} Wins!';
//         finalMessage = widget.isAI
//             ? 'Oops! You lost this one.'
//             : '${widget.playerOName} played well!';
//         iconColor = widget.isAI ? Colors.red : Colors.blue;
//       }
//
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => AlertDialog(
//           backgroundColor: Colors.transparent,
//           contentPadding: EdgeInsets.zero,
//           titlePadding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           content: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xFFA949F2),
//                   Color(0xFF3304B3),
//                 ],
//               ),
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     message,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Icon(
//                     Icons.sentiment_very_satisfied,
//                     color: iconColor,
//                     size: 80,
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     finalMessage,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       RoundedGradientButton(
//                         width: 115,
//                         text: 'Home',
//                         onPressed: () {
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                         },
//                       ),
//                       RoundedGradientButton(
//                         width: 115,
//                         text: 'Replay',
//                         onPressed: () {
//                           Navigator.pop(context);
//                           _resetGame();
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//   // void _showGameOverDialog(String message) {
//   //   bool isDraw = message.toLowerCase().contains('draw');
//   //   bool playerWon = message.contains('X') && !isDraw;
//   //   bool opponentWon = message.contains('O') && !isDraw;
//   //   bool showStars = playerWon || (!widget.isAI && opponentWon);
//   //
//   //   if (playerWon || (!widget.isAI && opponentWon)) {
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => WinnerPage(
//   //           coinReward: 20,
//   //           onContinue: () {
//   //             Navigator.pop(context);
//   //             _resetGame();
//   //           },
//   //         ),
//   //       ),
//   //     );
//   //   } else {
//   //     String finalMessage = '';
//   //     Color iconColor;
//   //
//   //     if (isDraw) {
//   //       finalMessage = 'Better luck next time!';
//   //       iconColor = Colors.blue;
//   //     } else if (message.contains('X')) {
//   //       message = 'Player 1 Wins!';
//   //       finalMessage = widget.isAI ? 'You won against the AI!' : 'Player 1 is the winner!';
//   //       iconColor = Colors.yellow;
//   //     } else {
//   //       message = widget.isAI ? 'AI Wins!' : 'Player 2 Wins!';
//   //       finalMessage = widget.isAI ? 'Oops! You lost this one.' : 'Player 2 played well!';
//   //       iconColor = Colors.red;
//   //     }
//   //
//   //     showDialog(
//   //       context: context,
//   //       barrierDismissible: false,
//   //       builder: (_) => AlertDialog(
//   //         backgroundColor: Colors.transparent,
//   //         contentPadding: EdgeInsets.zero,
//   //         titlePadding: EdgeInsets.zero,
//   //         shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.circular(20),
//   //         ),
//   //         content: Container(
//   //           decoration: const BoxDecoration(
//   //             gradient: LinearGradient(
//   //               begin: Alignment.topCenter,
//   //               end: Alignment.bottomCenter,
//   //               colors: [
//   //                 Color(0xFFA949F2),
//   //                 Color(0xFF3304B3),
//   //               ],
//   //             ),
//   //             borderRadius: BorderRadius.all(Radius.circular(20)),
//   //           ),
//   //           child: Padding(
//   //             padding: const EdgeInsets.all(16.0),
//   //             child: Column(
//   //               mainAxisSize: MainAxisSize.min,
//   //               children: [
//   //                 Text(
//   //                   message,
//   //                   textAlign: TextAlign.center,
//   //                   style: const TextStyle(
//   //                     color: Colors.white,
//   //                     fontWeight: FontWeight.bold,
//   //                     fontSize: 24,
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 10),
//   //                 Icon(
//   //                   Icons.sentiment_very_satisfied,
//   //                   color: iconColor,
//   //                   size: 80,
//   //                 ),
//   //                 const SizedBox(height: 10),
//   //                 if (showStars)
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.center,
//   //                     children: const [
//   //                       Icon(Icons.star, color: Colors.yellow, size: 30),
//   //                       SizedBox(width: 6),
//   //                       Icon(Icons.star, color: Colors.yellow, size: 30),
//   //                       SizedBox(width: 6),
//   //                       Icon(Icons.star, color: Colors.yellow, size: 30),
//   //                     ],
//   //                   ),
//   //                 const SizedBox(height: 10),
//   //                 Text(
//   //                   finalMessage,
//   //                   textAlign: TextAlign.center,
//   //                   style: TextStyle(
//   //                     color: Colors.white,
//   //                     fontSize: 16,
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 20),
//   //                 Row(
//   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                   children: [
//   //                     RoundedGradientButton(
//   //                       width: 115,
//   //                       text: 'Home',
//   //                       onPressed: () {
//   //                         Navigator.pop(context);
//   //                         Navigator.pop(context);
//   //                       },
//   //                     ),
//   //                     RoundedGradientButton(
//   //                       width: 115,
//   //                       text: 'Replay',
//   //                       onPressed: () {
//   //                         Navigator.pop(context);
//   //                         _resetGame();
//   //                       },
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //         actions: [],
//   //       ),
//   //     );
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context);
//     return Scaffold(
//       body: BackgroundContainer(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40),
//               CustomTopBar(
//                 coins: 500,
//                 isGame: true,
//                 onBack: () => Navigator.pop(context),
//                 onSettings: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => const SettingsDialog(),
//                   );
//                 },
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Column(
//                     children: [
//                       const SizedBox(height: 10),
//                       const Icon(Icons.close,
//                           size: 40, color: Color(0xFFF4B52E)),
//                       Text(
//                         // widget.isAI ? 'Player\'s Turn' : 'Player 1\'s Turn',
//                         widget.isAI ? 'Your Turn' : '${widget.playerXName}\'s Turn',
//                         style: TextStyle(
//                           color: currentPlayer == 'X'
//                               ? Colors.white
//                               : Colors.white54,
//                           fontSize: 20,
//                           fontFamily: 'Pridi',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 10),
//                   const Text(
//                     'VS',
//                     style: TextStyle(
//                       fontSize: 24,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'Pridi',
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Column(
//                     children: [
//                       const SizedBox(height: 10),
//                       const Icon(Icons.circle_outlined,
//                           size: 40, color: Color(0xFFF4B52E)),
//                       Text(
//                         // widget.isAI ? 'AI\'s Turn' : 'Player 2\'s Turn',
//                         widget.isAI ? 'AI\'s Turn' : '${widget.playerOName}\'s Turn',
//                         style: TextStyle(
//                           color: currentPlayer == 'O'
//                               ? Colors.white
//                               : Colors.white54,
//                           fontSize: 20,
//                           fontFamily: 'Pridi',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 60),
//               widget.difficulty == ''
//                   ? SizedBox(
//                       height: 24,
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(right: 50.0, left: 280),
//                       child: Container(
//                         // width: 100,
//                         padding: EdgeInsets.only(bottom: 4),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF400CB9), // Deep purple
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.white, width: 1),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               widget.difficulty ?? '',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontFamily: 'Pridi',
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Column(
//                     children: List.generate(3, (row) {
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children:
//                             List.generate(3, (col) => _buildCell(row, col)),
//                       );
//                     }),
//                   ),
//                   if (winningLine != null)
//                     CustomPaint(
//                       size: const Size(336, 336),
//                       painter: WinningLinePainter(
//                         winningLine: winningLine!,
//                         progress: _animation?.value ?? 0,
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 60),
//               if (!gameOver &&
//                   (widget.isAI ? currentPlayer == 'X' : true) &&
//                   moveHistory.isNotEmpty)
//                 CustomIconButton(
//                   onTap: _showUndoDialog,
//                   width: 110,
//                   height: 40,
//                   iconPath: 'assets/undo.png',
//                   label: 'Undo',
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WinningLinePainter extends CustomPainter {
//   final List<Offset> winningLine;
//   final double progress;
//
//   WinningLinePainter({required this.winningLine, required this.progress});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFF4B52E)
//       ..strokeWidth = 8
//       ..strokeCap = StrokeCap.round;
//
//     final start = winningLine[0];
//     final end = winningLine[1];
//
//     final animatedEnd = Offset(
//       start.dx + (end.dx - start.dx) * progress,
//       start.dy + (end.dy - start.dy) * progress,
//     );
//
//     canvas.drawLine(start, animatedEnd, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// void _showGameOverDialog(String message) {
//   bool isDraw = message.toLowerCase().contains('draw');
//   bool playerWon = message.contains('X') && !isDraw;
//   bool opponentWon = message.contains('O') && !isDraw;
//   bool showStars = playerWon || (!widget.isAI && opponentWon);
//   String finalMessage = '';
//   Color iconColor;
//
//   if (isDraw) {
//     finalMessage = 'Better luck next time!';
//     iconColor = Colors.blue;
//   } else if (message.contains('X')) {
//     message = 'Player 1 Wins!';
//     finalMessage = widget.isAI ? 'You won against the AI!' : 'Player 1 is the winner!';
//     iconColor = Colors.yellow;
//   } else {
//     message = widget.isAI ? 'AI Wins!' : 'Player 2 Wins!';
//     finalMessage = widget.isAI ? 'Oops! You lost this one.' : 'Player 2 played well!';
//     iconColor = Colors.red;
//   }
//
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => AlertDialog(
//       backgroundColor: Colors.transparent,
//       contentPadding: EdgeInsets.zero,
//       titlePadding: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       content: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFA949F2),
//               Color(0xFF3304B3),
//             ],
//           ),
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 24,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Icon(
//                 Icons.sentiment_very_satisfied,
//                 color: iconColor,
//                 size: 80,
//               ),
//               const SizedBox(height: 10),
//               if (showStars)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.star, color: Colors.yellow, size: 30),
//                     SizedBox(width: 6),
//                     Icon(Icons.star, color: Colors.yellow, size: 30),
//                     SizedBox(width: 6),
//                     Icon(Icons.star, color: Colors.yellow, size: 30),
//                   ],
//                 ),
//               const SizedBox(height: 10),
//               Text(
//                 finalMessage,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   RoundedGradientButton(
//                     width: 115,
//                     text: 'Home',
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                     },
//                   ),
//                   RoundedGradientButton(
//                     width: 115,
//                     text: 'Replay',
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _resetGame();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [],
//     ),
//   );
// }

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../Widget/bg_container.dart';
// import '../Widget/custom_appbar.dart';
// import '../Widget/custom_button.dart';
// import '../Widget/undobutton.dart';
// import 'ad_show.dart';
//
// class TicTacToeGame extends StatefulWidget {
//   final bool isAI;
//   final String difficulty;
//   const TicTacToeGame({super.key, this.isAI = false, this.difficulty = 'easy'});
//
//   @override
//   State<TicTacToeGame> createState() => _TicTacToeGameState();
// }
//
// class _TicTacToeGameState extends State<TicTacToeGame> {
//   List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
//   String currentPlayer = 'X';
//   String winner = '';
//   bool gameOver = false;
//   List<List<List<String>>> moveHistory = [];
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.isAI && currentPlayer == 'O') {
//       _makeAIMove();
//     }
//   }
//
//   void _showUndoDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: 380,
//             height: 204,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Stack(
//               children: [
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Are you sure to undo?",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Pridi',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       CustomIconButton(
//                         height: 45,
//                         spacebetweenIcon: 0,
//                         onTap: () {
//                           Navigator.pop(context);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AdPlaybackPage(
//                                 onAdComplete: _undoMove,
//                               ),
//                             ),
//                           );
//                         },
//                         label: "Play AD",
//                         labelColor: Colors.white,
//                         iconWidget: Image.asset("assets/Ad.png", height: 28),
//                       ),
//                       const SizedBox(height: 12),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _showUseCoinConfirmationDialog();
//                         },
//                         label: "1",
//                         labelColor: Colors.white,
//                         iconWidget: Image.asset("assets/coin.png", height: 28),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.close, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showUseCoinConfirmationDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: 380,
//             height: 204,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Stack(
//               children: [
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Are you sure to use a coin?",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Pridi',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _undoMove();
//                         },
//                         label: "Yes",
//                         labelColor: Colors.white,
//                       ),
//                       const SizedBox(height: 12),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _showUndoDialog();
//                         },
//                         label: "No",
//                         labelColor: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.close, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _handleTap(int row, int col) {
//     if (board[row][col] == '' && !gameOver) {
//       setState(() {
//         moveHistory.add(_copyBoard());
//         board[row][col] = currentPlayer;
//         if (_checkWinner(row, col)) {
//           winner = currentPlayer;
//           gameOver = true;
//           _showGameOverDialog('$winner Wins!');
//         } else if (_isDraw()) {
//           winner = 'Draw';
//           gameOver = true;
//           _showGameOverDialog('It\'s a Draw!');
//         } else {
//           currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//           if (widget.isAI && currentPlayer == 'O' && !gameOver) {
//             _makeAIMove();
//           }
//         }
//       });
//     }
//   }
//
//   List<List<String>> _copyBoard() {
//     return board.map((row) => List<String>.from(row)).toList();
//   }
//
//   void _undoMove() {
//     if (moveHistory.isNotEmpty) {
//       setState(() {
//         board = moveHistory.removeLast();
//         currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//         winner = '';
//         gameOver = false;
//       });
//     }
//   }
//
//   void _makeAIMove() {
//     if (gameOver) return;
//     var move = widget.difficulty == 'easy'
//         ? _randomMove()
//         : widget.difficulty == 'medium'
//         ? _mediumMove()
//         : _hardMove();
//     if (move != null) {
//       Future.delayed(const Duration(milliseconds: 500), () {
//         _handleTap(move[0], move[1]);
//       });
//     }
//   }
//
//   List<int>? _randomMove() {
//     List<List<int>> emptyCells = [];
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           emptyCells.add([i, j]);
//         }
//       }
//     }
//     if (emptyCells.isNotEmpty) {
//       return emptyCells[Random().nextInt(emptyCells.length)];
//     }
//     return null;
//   }
//
//   List<int>? _mediumMove() {
//     if (Random().nextDouble() < 0.5) {
//       return _hardMove();
//     }
//     return _randomMove();
//   }
//
//   List<int>? _hardMove() {
//     int bestScore = -1000;
//     List<int>? bestMove;
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           board[i][j] = 'O';
//           int score = _minimax(board, 0, false);
//           board[i][j] = '';
//           if (score > bestScore) {
//             bestScore = score;
//             bestMove = [i, j];
//           }
//         }
//       }
//     }
//     return bestMove;
//   }
//
//   int _minimax(List<List<String>> board, int depth, bool isMaximizing) {
//     if (_checkWinnerForMinimax(board, 'O')) return 10 - depth;
//     if (_checkWinnerForMinimax(board, 'X')) return depth - 10;
//     if (_isDrawForMinimax(board)) return 0;
//
//     if (isMaximizing) {
//       int bestScore = -1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'O';
//             int score = _minimax(board, depth + 1, false);
//             board[i][j] = '';
//             bestScore = max(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     } else {
//       int bestScore = 1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'X';
//             int score = _minimax(board, depth + 1, true);
//             board[i][j] = '';
//             bestScore = min(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     }
//   }
//
//   bool _checkWinner(int row, int col) {
//     if (board[row].every((cell) => cell == currentPlayer)) return true;
//     if ([board[0][col], board[1][col], board[2][col]].every((cell) => cell == currentPlayer)) return true;
//     if (row == col && [board[0][0], board[1][1], board[2][2]].every((cell) => cell == currentPlayer)) return true;
//     if (row + col == 2 && [board[0][2], board[1][1], board[2][0]].every((cell) => cell == currentPlayer)) return true;
//     return false;
//   }
//
//   bool _checkWinnerForMinimax(List<List<String>> board, String player) {
//     for (int i = 0; i < 3; i++) {
//       if (board[i].every((cell) => cell == player)) return true;
//       if ([board[0][i], board[1][i], board[2][i]].every((cell) => cell == player)) return true;
//     }
//     if ([board[0][0], board[1][1], board[2][2]].every((cell) => cell == player)) return true;
//     if ([board[0][2], board[1][1], board[2][0]].every((cell) => cell == player)) return true;
//     return false;
//   }
//
//   bool _isDraw() {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//
//   bool _isDrawForMinimax(List<List<String>> board) {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//
//   void _resetGame() {
//     setState(() {
//       board = List.generate(3, (_) => List.filled(3, ''));
//       currentPlayer = 'X';
//       winner = '';
//       gameOver = false;
//     });
//     if (widget.isAI && currentPlayer == 'O') {
//       _makeAIMove();
//     }
//   }
//
//   Widget _buildCell(int row, int col) {
//     String cellValue = board[row][col];
//     Color bgColor;
//     if (cellValue == 'X') {
//       bgColor = Colors.transparent; // Amber for X
//     } else if (cellValue == 'O') {
//       bgColor = Colors.transparent; // Purple for O
//     } else {
//       bgColor = Colors.white; // Default empty cell
//     }
//     return GestureDetector(
//       onTap: () => _handleTap(row, col),
//       child: Container(
//         margin: const EdgeInsets.all(6),
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(0),
//           border: Border.all(
//             color: Colors.white.withValues(alpha: 0.9),
//             width: 1,
//           ),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           cellValue,
//           style: TextStyle(
//             fontSize: 50,
//             fontWeight: FontWeight.bold,
//             color: cellValue == 'X'
//                 ? Color(0xFFF4B52E) // White text on amber background
//                 : Color(0xFFF4B52E), // White text on purple background
//           ),
//         ),
//       ),
//     );
//   }
//   void _showGameOverDialog(String message) {
//     bool isDraw = message.toLowerCase().contains('draw');
//     bool playerWon = message.contains('X') && !isDraw;
//     bool opponentWon = message.contains('O') && !isDraw;
//     bool showStars = playerWon || (!widget.isAI && opponentWon);
//     String finalMessage = '';
//     Color iconColor;
//
//     // Determine the message and icon color based on game result
//     if (isDraw) {
//       finalMessage = 'Better luck next time!';
//       iconColor = Colors.blue; // Blue for draw
//     } else if (message.contains('X')) {
//       message = 'Player 1 Wins!';
//       finalMessage = widget.isAI ? 'You won against the AI!' : 'Player 1 is the winner!';
//       iconColor = Colors.yellow; // Yellow for player win
//     } else {
//       message = widget.isAI ? 'AI Wins!' : 'Player 2 Wins!';
//       finalMessage = widget.isAI ? 'Oops! You lost this one.' : 'Player 2 played well!';
//       iconColor = Colors.red; // Red for opponent/AI win
//     }
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         backgroundColor: Colors.transparent, // Make background transparent for gradient
//         contentPadding: EdgeInsets.zero, // Remove default padding
//         titlePadding: EdgeInsets.zero, // Remove default title padding
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         content: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFFA949F2), // Top color
//                 Color(0xFF3304B3), // Bottom color
//               ],
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   message,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 24,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Icon(
//                   Icons.sentiment_very_satisfied,
//                   color: iconColor, // Dynamic icon color based on result
//                   size: 80,
//                 ),
//                 const SizedBox(height: 10),
//                 if (showStars)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(Icons.star, color: Colors.yellow, size: 30),
//                       SizedBox(width: 6),
//                       Icon(Icons.star, color: Colors.yellow, size: 30),
//                       SizedBox(width: 6),
//                       Icon(Icons.star, color: Colors.yellow, size: 30),
//                     ],
//                   ),
//                 const SizedBox(height: 10),
//                 Text(
//                   finalMessage,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white, // Match text color with icon
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     RoundedGradientButton(
//                       width: 115,
//                       text: 'Home',
//                       onPressed: () {
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                       },
//                     ),
//                     // const SizedBox(width: 5),
//                     RoundedGradientButton(
//                       width: 115,
//                       text: 'Replay',
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _resetGame();
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [], // No actions since buttons are in content
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BackgroundContainer(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 10),
//             CustomTopBar(
//               coins: 500,
//               onBack: () => Navigator.pop(context),
//               onSettings: () {},
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(height: 10),
//                     Icon(Icons.close, size: 40, color: Color(0xFFF4B52E)), // X icon
//                     Text(
//                       widget.isAI ? 'Player\'s Turn' : 'Player 1\'s Turn',
//                       style: TextStyle(
//                         color: currentPlayer == 'X' ? Colors.white : Colors.white54,
//                         fontSize: 20,
//                         fontFamily: 'Pridi',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   'VS',
//                   style: TextStyle(
//                     fontSize: 24,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'Pridi',
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Column(
//                   children: [
//                     SizedBox(height: 10),
//                     Icon(Icons.circle_outlined, size: 40, color: Color(0xFFF4B52E)), // O icon
//                     Text(
//                       widget.isAI ? 'Ai\'s Turn' : 'Player 2\'s Turn',
//                       style: TextStyle(
//                         color: currentPlayer == 'O' ? Colors.white : Colors.white54,
//                         fontSize: 20,
//                         fontFamily: 'Pridi',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 50),
//             Column(
//               children: List.generate(3, (row) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(3, (col) => _buildCell(row, col)),
//                 );
//               }),
//             ),
//             const SizedBox(height: 50),
//             CustomIconButton(
//               onTap: _showUndoDialog,
//               iconPath: 'assets/undo.png',
//               label: 'Undo',
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class WinningLinePainter extends CustomPainter {
//   final List<Offset> winningLine;
//   final double progress;
//
//   WinningLinePainter({required this.winningLine, required this.progress});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFF4B52E) // Amber color to match X and O
//       ..strokeWidth = 10
//       ..strokeCap = StrokeCap.round;
//
//     final start = winningLine[0];
//     final end = winningLine[1];
//
//     // Calculate the animated end point (from start to end based on progress)
//     final animatedEnd = Offset(
//       start.dx + (end.dx - start.dx) * progress,
//       start.dy + (end.dy - start.dy) * progress,
//     );
//
//     // Draw the line from start to the animated end point
//     canvas.drawLine(start, animatedEnd, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// class AdPlaybackPage extends StatefulWidget {
//   final VoidCallback onAdComplete;
//
//   const AdPlaybackPage({super.key, required this.onAdComplete});
//
//   @override
//   State<AdPlaybackPage> createState() => _AdPlaybackPageState();
// }
//
// class _AdPlaybackPageState extends State<AdPlaybackPage> {
//   int _remainingSeconds = 15;
//   late Timer _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_remainingSeconds > 0) {
//           _remainingSeconds--;
//         } else {
//           _timer.cancel();
//           widget.onAdComplete();
//           Navigator.pop(context);
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Stack(
//           children: [
//             Center(
//               child: Image.asset(
//                 'assets/SkipAd.png',
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: Row(
//                 children: [
//                   Text(
//                     '$_remainingSeconds',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       _timer.cancel();
//                       Navigator.pop(context);
//                     },
//                     child: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../Widget/bg_container.dart';
// import '../Widget/custom_appbar.dart';
// import '../Widget/undobutton.dart';
// class TicTacToeGame extends StatefulWidget {
//   final bool isAI;
//   final String difficulty;
//   const TicTacToeGame({super.key, this.isAI = false, this.difficulty = 'easy'});
//   @override
//   State<TicTacToeGame> createState() => _TicTacToeGameState();
// }
// class _TicTacToeGameState extends State<TicTacToeGame> {
//   List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
//   String currentPlayer = 'X';
//   String winner = '';
//   bool gameOver = false;
//   List<List<List<String>>> moveHistory = [];
//   @override
//   void initState() {
//     super.initState();
//     if (widget.isAI && currentPlayer == 'O') {_makeAIMove();}
//   }
//   void _showUndoDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: 380,
//             height: 204,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Stack(
//               children: [
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Are you sure to undo?",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Pridi',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       CustomIconButton(
//                         height: 45,
//                         spacebetweenIcon: 0,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _undoMove();
//                           // TODO: Handle playing ad logic
//                         },
//                         label: "Play AD",
//                         labelColor: Colors.white,
//                         iconWidget: Image.asset("assets/Ad.png", height: 28),
//                       ),
//                       const SizedBox(height: 12),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _showUseCoinConfirmationDialog();
//                         },
//                         label: "1",
//                         labelColor: Colors.white,
//                         iconWidget: Image.asset("assets/coin.png", height: 28),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.close, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//   void _showUseCoinConfirmationDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             width: 380,
//             height: 204,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Stack(
//               children: [
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Are you sure to use a coin?",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Pridi',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _undoMove();
//                         },
//                         label: "Yes",
//                         labelColor: Colors.white,
//                       ),
//                       const SizedBox(height: 12),
//                       CustomIconButton(
//                         width: 150,
//                         height: 40,
//                         onTap: () {
//                           Navigator.pop(context);
//                           _showUndoDialog();
//                         },
//                         label: "No",
//                         labelColor: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.close, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//   void _handleTap(int row, int col) {
//     if (board[row][col] == '' && !gameOver) {
//       setState(() {
//         moveHistory.add(_copyBoard());
//         board[row][col] = currentPlayer;
//         if (_checkWinner(row, col)) {
//           winner = currentPlayer;
//           gameOver = true;
//           _showGameOverDialog('$winner Wins!');
//         } else if (_isDraw()) {
//           winner = 'Draw';
//           gameOver = true;
//           _showGameOverDialog('It\'s a Draw!');
//         } else {
//           currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//           if (widget.isAI && currentPlayer == 'O' && !gameOver) {
//             _makeAIMove();
//           }
//         }
//       });
//     }
//   }
//   List<List<String>> _copyBoard() {
//     return board.map((row) => List<String>.from(row)).toList();
//   }
//   void _undoMove() {
//     if (moveHistory.isNotEmpty) {
//       setState(() {
//         board = moveHistory.removeLast();
//         currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//         winner = '';
//         gameOver = false;
//       });
//     }
//   }
//   void _makeAIMove() {
//     if (gameOver) return;
//     var move = widget.difficulty == 'easy'
//         ? _randomMove()
//         : widget.difficulty == 'medium'
//         ? _mediumMove()
//         : _hardMove();
//     if (move != null) {
//       Future.delayed(const Duration(milliseconds: 500), () {
//         _handleTap(move[0], move[1]);
//       });
//     }
//   }
//   List<int>? _randomMove() {
//     List<List<int>> emptyCells = [];
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           emptyCells.add([i, j]);
//         }
//       }
//     }
//     if (emptyCells.isNotEmpty) {
//       return emptyCells[Random().nextInt(emptyCells.length)];
//     }
//     return null;
//   }
//   List<int>? _mediumMove() {
//     if (Random().nextDouble() < 0.5) {
//       return _hardMove();
//     }
//     return _randomMove();
//   }
//   List<int>? _hardMove() {
//     int bestScore = -1000;
//     List<int>? bestMove;
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           board[i][j] = 'O';
//           int score = _minimax(board, 0, false);
//           board[i][j] = '';
//           if (score > bestScore) {
//             bestScore = score;
//             bestMove = [i, j];
//           }
//         }
//       }
//     }
//     return bestMove;
//   }
//   int _minimax(List<List<String>> board, int depth, bool isMaximizing) {
//     if (_checkWinnerForMinimax(board, 'O')) return 10 - depth;
//     if (_checkWinnerForMinimax(board, 'X')) return depth - 10;
//     if (_isDrawForMinimax(board)) return 0;
//     if (isMaximizing) {
//       int bestScore = -1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'O';
//             int score = _minimax(board, depth + 1, false);
//             board[i][j] = '';
//             bestScore = max(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     } else {
//       int bestScore = 1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'X';
//             int score = _minimax(board, depth + 1, true);
//             board[i][j] = '';
//             bestScore = min(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     }
//   }
//   bool _checkWinner(int row, int col) {
//     if (board[row].every((cell) => cell == currentPlayer)) return true;
//     if ([board[0][col], board[1][col], board[2][col]].every((cell) => cell == currentPlayer)) return true;
//     if (row == col && [board[0][0], board[1][1], board[2][2]].every((cell) => cell == currentPlayer)) return true;
//     if (row + col == 2 && [board[0][2], board[1][1], board[2][0]].every((cell) => cell == currentPlayer)) return true;
//     return false;
//   }
//   bool _checkWinnerForMinimax(List<List<String>> board, String player) {
//     for (int i = 0; i < 3; i++) {
//       if (board[i].every((cell) => cell == player)) return true;
//       if ([board[0][i], board[1][i], board[2][i]].every((cell) => cell == player)) return true;
//     }
//     if ([board[0][0], board[1][1], board[2][2]].every((cell) => cell == player)) return true;
//     if ([board[0][2], board[1][1], board[2][0]].every((cell) => cell == player)) return true;
//     return false;
//   }
//   bool _isDraw() {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//   bool _isDrawForMinimax(List<List<String>> board) {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//   void _resetGame() {
//     setState(() {
//       board = List.generate(3, (_) => List.filled(3, ''));
//       currentPlayer = 'X';
//       winner = '';
//       gameOver = false;
//     });
//     if (widget.isAI && currentPlayer == 'O') {
//       _makeAIMove();
//     }
//   }
//   Widget _buildCell(int row, int col) {
//     String cellValue = board[row][col];
//     Color bgColor;
//     if (cellValue == 'X') {
//       bgColor = Colors.transparent; // Amber for X
//     } else if (cellValue == 'O') {
//       bgColor = Colors.transparent; // Purple for O
//     } else {
//       bgColor = Colors.white; // Default empty cell
//     }
//     return GestureDetector(
//       onTap: () => _handleTap(row, col),
//       child: Container(
//         margin: const EdgeInsets.all(6),
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(0),
//           border: Border.all(
//             color: Colors.white.withValues(alpha: 0.9),
//             width: 1,
//           ),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           cellValue,
//           style: TextStyle(
//             fontSize: 50,
//             fontWeight: FontWeight.bold,
//             color: cellValue == 'X'
//                 ? Color(0xFFF4B52E) // White text on amber background
//                 : Color(0xFFF4B52E), // White text on purple background
//           ),
//         ),
//       ),
//     );
//   }
//   void _showGameOverDialog(String message) {
//     bool isDraw = message.toLowerCase().contains('draw');
//     bool playerWon = message.contains('X') && !isDraw;
//     bool opponentWon = message.contains('O') && !isDraw;
//     bool showStars = playerWon || (!widget.isAI && opponentWon);
//     String finalMessage = '';
//     if (isDraw) {
//       finalMessage = 'Better luck next time!';
//     } else if (winner == 'X') {
//       message = 'Player 1 Wins!';
//       finalMessage = widget.isAI ? 'You won against the AI!' : 'Player 1 is the winner!';
//     } else if (winner == 'O') {
//       message = widget.isAI ? 'AI Wins!' : 'Player 2 Wins!';
//       finalMessage = widget.isAI ? 'Oops! You lost this one.' : 'Player 2 played well!';
//     }
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         backgroundColor: const Color(0xFF040E25),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: const BorderSide(color: Colors.white24),
//         ),
//         title: Column(
//           children: [
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//             const SizedBox(height: 10),
//             if (showStars)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Icon(Icons.star, color: Colors.yellow, size: 30),
//                   SizedBox(width: 6),
//                   Icon(Icons.star, color: Colors.yellow, size: 30),
//                   SizedBox(width: 6),
//                   Icon(Icons.star, color: Colors.yellow, size: 30),
//                 ],
//               ),
//             const SizedBox(height: 10),
//             Text(
//               finalMessage,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//         actionsAlignment: MainAxisAlignment.center,
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF0A1C3A),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             ),
//             child: const Text(
//               'Go to Home',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           const SizedBox(width: 10),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _resetGame();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF0A1C3A),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             ),
//             child: const Text(
//               'Replay',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BackgroundContainer(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 10),
//             CustomTopBar(
//               coins: 500,
//               onBack: () => Navigator.pop(context),
//               onSettings: () {},
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(height: 10),
//                     Icon(Icons.close, size: 40, color: Color(0xFFF4B52E)), // X icon
//                     Text(
//                       widget.isAI?
//                       'Player\'s Turn':'Player 1\'s Turn',
//                       style: TextStyle(
//                         color: currentPlayer == 'X' ? Colors.white : Colors.white54,
//                         fontSize: 20,
//                         fontFamily: 'Pridi',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 10),
//                 const Text('VS', style: TextStyle(fontSize: 24, color: Colors.black,fontWeight: FontWeight.w500,fontFamily: 'Pridi',)),
//                 const SizedBox(width: 10),
//                 Column(
//                   children: [
//                     SizedBox(height: 10),
//                     Icon(Icons.circle_outlined, size: 40, color: Color(0xFFF4B52E)), // O icon
//                     Text(
//                       widget.isAI?
//                       'Ai\'s Turn':'Player 2\'s Turn',
//                       style: TextStyle(
//                         color: currentPlayer == 'O' ? Colors.white : Colors.white54,
//                         fontSize: 20,
//                         fontFamily: 'Pridi',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 50),
//             Column(
//               children: List.generate(3, (row) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(3, (col) => _buildCell(row, col)),
//                 );
//               }),
//             ),
//             const SizedBox(height: 50),
//             CustomIconButton(
//               onTap: _showUndoDialog,
//               iconPath: 'assets/undo.png',
//               label: 'Undo',
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

//
// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// class TicTacToeGame extends StatefulWidget {
//   final bool isAI;
//   final String difficulty;
//
//   const TicTacToeGame({super.key, this.isAI = false, this.difficulty = 'easy'});
//
//   @override
//   State<TicTacToeGame> createState() => _TicTacToeGameState();
// }
//
// class _TicTacToeGameState extends State<TicTacToeGame> {
//   List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
//   String currentPlayer = 'X';
//   String winner = '';
//   bool gameOver = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.isAI && currentPlayer == 'O') {
//       _makeAIMove();
//     }
//   }
//
//   // void _handleTap(int row, int col) {
//   //   if (board[row][col] == '' && !gameOver) {
//   //     setState(() {
//   //       board[row][col] = currentPlayer;
//   //       if (_checkWinner(row, col)) {
//   //         winner = currentPlayer;
//   //         gameOver = true;
//   //       } else if (_isDraw()) {
//   //         winner = 'Draw';
//   //         gameOver = true;
//   //       } else {
//   //         currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//   //         if (widget.isAI && currentPlayer == 'O' && !gameOver) {
//   //           _makeAIMove();
//   //         }
//   //       }
//   //     });
//   //   }
//   // }
//   void _handleTap(int row, int col) {
//     if (board[row][col] == '' && !gameOver) {
//       setState(() {
//         board[row][col] = currentPlayer;
//         if (_checkWinner(row, col)) {
//           winner = currentPlayer;
//           gameOver = true;
//           _showGameOverDialog('$winner Wins!');
//         } else if (_isDraw()) {
//           winner = 'Draw';
//           gameOver = true;
//           _showGameOverDialog('It\'s a Draw!');
//         } else {
//           currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//           if (widget.isAI && currentPlayer == 'O' && !gameOver) {
//             _makeAIMove();
//           }
//         }
//       });
//     }
//   }
//
//
//   void _makeAIMove() {
//     if (gameOver) return;
//
//     var move = widget.difficulty == 'easy'
//         ? _randomMove()
//         : widget.difficulty == 'medium'
//         ? _mediumMove()
//         : _hardMove();
//
//     if (move != null) {
//       Future.delayed(const Duration(milliseconds: 500), () {
//         _handleTap(move[0], move[1]);
//       });
//     }
//   }
//
//   List<int>? _randomMove() {
//     List<List<int>> emptyCells = [];
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           emptyCells.add([i, j]);
//         }
//       }
//     }
//     if (emptyCells.isNotEmpty) {
//       return emptyCells[Random().nextInt(emptyCells.length)];
//     }
//     return null;
//   }
//
//   List<int>? _mediumMove() {
//     // 50% chance for optimal move, 50% for random
//     if (Random().nextDouble() < 0.5) {
//       return _hardMove();
//     }
//     return _randomMove();
//   }
//
//   List<int>? _hardMove() {
//     // Minimax algorithm for optimal move
//     int bestScore = -1000;
//     List<int>? bestMove;
//
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         if (board[i][j] == '') {
//           board[i][j] = 'O';
//           int score = _minimax(board, 0, false);
//           board[i][j] = '';
//           if (score > bestScore) {
//             bestScore = score;
//             bestMove = [i, j];
//           }
//         }
//       }
//     }
//     return bestMove;
//   }
//
//   int _minimax(List<List<String>> board, int depth, bool isMaximizing) {
//     if (_checkWinnerForMinimax(board, 'O')) return 10 - depth;
//     if (_checkWinnerForMinimax(board, 'X')) return depth - 10;
//     if (_isDrawForMinimax(board)) return 0;
//
//     if (isMaximizing) {
//       int bestScore = -1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'O';
//             int score = _minimax(board, depth + 1, false);
//             board[i][j] = '';
//             bestScore = max(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     } else {
//       int bestScore = 1000;
//       for (int i = 0; i < 3; i++) {
//         for (int j = 0; j < 3; j++) {
//           if (board[i][j] == '') {
//             board[i][j] = 'X';
//             int score = _minimax(board, depth + 1, true);
//             board[i][j] = '';
//             bestScore = min(score, bestScore);
//           }
//         }
//       }
//       return bestScore;
//     }
//   }
//
//   bool _checkWinner(int row, int col) {
//     if (board[row].every((cell) => cell == currentPlayer)) return true;
//     if ([board[0][col], board[1][col], board[2][col]].every((cell) => cell == currentPlayer)) return true;
//     if (row == col && [board[0][0], board[1][1], board[2][2]].every((cell) => cell == currentPlayer)) return true;
//     if (row + col == 2 && [board[0][2], board[1][1], board[2][0]].every((cell) => cell == currentPlayer)) return true;
//     return false;
//   }
//
//   bool _checkWinnerForMinimax(List<List<String>> board, String player) {
//     for (int i = 0; i < 3; i++) {
//       if (board[i].every((cell) => cell == player)) return true;
//       if ([board[0][i], board[1][i], board[2][i]].every((cell) => cell == player)) return true;
//     }
//     if ([board[0][0], board[1][1], board[2][2]].every((cell) => cell == player)) return true;
//     if ([board[0][2], board[1][1], board[2][0]].every((cell) => cell == player)) return true;
//     return false;
//   }
//
//   bool _isDraw() {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//
//   bool _isDrawForMinimax(List<List<String>> board) {
//     for (var row in board) {
//       if (row.contains('')) return false;
//     }
//     return true;
//   }
//
//   void _resetGame() {
//     setState(() {
//       board = List.generate(3, (_) => List.filled(3, ''));
//       currentPlayer = 'X';
//       winner = '';
//       gameOver = false;
//     });
//     if (widget.isAI && currentPlayer == 'O') {
//       _makeAIMove();
//     }
//   }
//
//   Widget _buildCell(int row, int col) {
//     return GestureDetector(
//       onTap: () => _handleTap(row, col),
//       child: Container(
//         margin: const EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           color: Color(0xFF040E25),
//         ),
//         width: 100,
//         height: 100,
//         alignment: Alignment.center,
//         child: Text(
//           board[row][col],
//           style: TextStyle(
//             fontSize: 55,
//             fontWeight: FontWeight.bold,
//             color: board[row][col] == 'X' ? Colors.blue : Colors.red,
//           ),
//         ),
//       ),
//     );
//   }
//   void _showGameOverDialog(String message) {
//     bool isDraw = message.toLowerCase().contains('draw');
//     bool playerWon = message.contains('X') && !isDraw;
//     bool opponentWon = message.contains('O') && !isDraw;
//
//     bool showStars = playerWon || (!widget.isAI && opponentWon);
//
//     String finalMessage = '';
//     if (isDraw) {
//       finalMessage = 'Better luck next time!';
//     } else if (playerWon) {
//       finalMessage = 'Congratulations on winning!';
//     } else if (widget.isAI && opponentWon) {
//       finalMessage = 'Oops! You lost this one.';
//     } else if (!widget.isAI && opponentWon) {
//       finalMessage = 'Opponent wins! Better luck next time.';
//     }
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         backgroundColor: const Color(0xFF040E25),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: const BorderSide(color: Colors.white24),
//         ),
//         title: Column(
//           children: [
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//               ),
//             ),
//             const SizedBox(height: 10),
//             if (showStars)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Icon(Icons.star, color: Colors.yellow, size: 30),
//                   SizedBox(width: 6),
//                   Icon(Icons.star, color: Colors.yellow, size: 30),
//                   SizedBox(width: 6),
//                   Icon(Icons.star, color: Colors.yellow, size: 30),
//                 ],
//               ),
//             const SizedBox(height: 10),
//             Text(
//               finalMessage,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//         actionsAlignment: MainAxisAlignment.center,
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF0A1C3A),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             ),
//             child: const Text(
//               'Go to Home',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           const SizedBox(width: 10),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _resetGame();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF0A1C3A),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             ),
//             child: const Text(
//               'Replay',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A1C3A), // Dark blue Widget matching the logo
//       // appBar: AppBar(
//       //   title: const Text('Tic Tac Toe'),
//       //   backgroundColor: Colors.deepPTic Tac Toeurple,
//       //   centerTitle: true,
//       // ),
//       appBar: AppBar(
//         title: const Text('Tic Tac Toe'),
//         backgroundColor: const Color(0xFF040E25), // Neon purple app bar (matches the O in the logo)
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         leading: GestureDetector(
//             onTap: (){
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.keyboard_backspace_sharp,color: Colors.white,)
//         ),
//         titleTextStyle: const TextStyle(
//           color:Colors.white, // Neon green text (matches the grid in the logo)
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             gameOver
//                 ? winner == 'Draw'
//                 ? 'It\'s a Draw!'
//                 : '$winner Wins!'
//                 // : '${widget.isAI && currentPlayer == 'O' ? 'AI\'s' : currentPlayer}\'s Turn',
//                 : currentPlayer == 'X'
//                 ? "X\'s turn"
//                 : widget.isAI
//                 ? 'AI\'s Turn'
//                 : 'O\'s Turn',
//
//             style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
//           ),
//           const SizedBox(height: 20),
//           Column(
//             children: List.generate(3, (row) {
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(3, (col) => _buildCell(row, col)),
//               );
//             }),
//           ),
//           const SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: _resetGame,
//             style: ElevatedButton.styleFrom(
//               backgroundColor:Color(0xFF040E25),
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//               textStyle: const TextStyle(fontSize: 18),
//             ),
//             child: const Text('Reset Game',style: TextStyle(color: Colors.white),),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void _handleTap(int row, int col) {
//   if (board[row][col] == '' && !gameOver) {
//     setState(() {
//       board[row][col] = currentPlayer;
//       if (_checkWinner(row, col)) {
//         winner = currentPlayer;
//         gameOver = true;
//         _showGameOverDialog('$winner Wins!');
//       } else if (_isDraw()) {
//         winner = 'Draw';
//         gameOver = true;
//         _showGameOverDialog('It\'s a Draw!');
//       } else {
//         currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//         if (widget.isAI && currentPlayer == 'O' && !gameOver) {
//           _makeAIMove();
//         }
//       }
//     });
//   }
// }

// boxShadow: [
//   BoxShadow(
//     color: Colors.black.withOpacity(0.2),
//     blurRadius: 8,
//     offset: const Offset(2, 4),
//   ),
// ],

// Widget _buildCell(int row, int col) {
//   return GestureDetector(
//     onTap: () => _handleTap(row, col),
//     child: Container(
//       margin: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         color: Color(0xFF040E25),
//       ),
//       width: 100,
//       height: 100,
//       alignment: Alignment.center,
//       child: Text(
//         board[row][col],
//         style: TextStyle(
//           fontSize: 55,
//           fontWeight: FontWeight.bold,
//           color: board[row][col] == 'X' ? Colors.blue : Colors.red,
//         ),
//       ),
//     ),
//   );
// }

// if (isDraw) {
//   finalMessage = 'Better luck next time!';
// } else if (playerWon) {
//   finalMessage = 'Congratulations on winning!';
// } else if (widget.isAI && opponentWon) {
//   finalMessage = 'Oops! You lost this one.';
// } else if (!widget.isAI && opponentWon) {
//   finalMessage = 'Opponent wins! Better luck next time.';
// }

// backgroundColor: const Color(0xFF0A1C3A),
// appBar: AppBar(
//   title: const Text('Tic Tac Toe'),
//   backgroundColor: const Color(0xFF040E25), // Neon purple app bar (matches the O in the logo)
//   centerTitle: true,
//   automaticallyImplyLeading: false,
//   leading: GestureDetector(
//       onTap: (){
//         Navigator.pop(context);
//       },
//       child: Icon(Icons.keyboard_backspace_sharp,color: Colors.white,)
//   ),
//   titleTextStyle: const TextStyle(
//     color:Colors.white, // Neon green text (matches the grid in the logo)
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//   ),
// ),

// Text(
//   gameOver
//       ? winner == 'Draw'
//       ? 'It\'s a Draw!'
//       : '$winner Wins!'
//       : currentPlayer == 'X'
//       ? "X\'s turn"
//       : widget.isAI
//       ? 'AI\'s Turn'
//       : 'O\'s Turn',
//   style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
// ),

// UndoButton(
//   onTap: _undoMove,
// ),

// void _showUndoDialog() {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (context) {
//       return Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           width: 380,
//           height: 204,
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Stack(
//             children: [
//               Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 15),
//                     const Text(
//                       "Are you Sure To Undo ?",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontFamily: 'Pridi',
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 15),
//                     CustomIconButton(
//                       height: 45,
//                       spacebetweenIcon:0,
//                       onTap: () {
//                         Navigator.pop(context);
//                         _undoMove();
//                         // TODO: Handle playing ad logic
//                       },
//                       label: "Play AD",
//                       labelColor: Colors.white,
//                       iconWidget: Image.asset("assets/Ad.png", height: 28), // Replace with your actual icon path
//                     ),
//                     const SizedBox(height: 12),
//                     CustomIconButton(
//                       width: 150,
//                       height: 40,
//                       onTap: () {
//                         Navigator.pop(context);
//                         // _undoMove();
//                         _showUseCoinConfirmationDialog();
//                         // TODO: Handle deducting 1 coin
//                       },
//                       label: "1",
//                       labelColor: Colors.white,
//                       iconWidget: Image.asset("assets/coin.png", height: 28), // Replace with your actual icon path
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.close, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
// void _showUseCoinConfirmationDialog() {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (context) {
//       return Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           width: 380,
//           height: 204,
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Stack(
//             children: [
//               Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 15),
//                     const Text(
//                       "Are you Sure To Coin ?",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontFamily: 'Pridi',
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 15),
//                     // ElevatedButton(
//                     //   onPressed: () {
//                     //     Navigator.pop(context); // Close confirmation dialog
//                     //     _undoMove(); // Proceed with undo
//                     //   },
//                     //   style: ElevatedButton.styleFrom(
//                     //     backgroundColor: Colors.blueAccent,
//                     //   ),
//                     //   child: const Text("Yes",style: TextStyle(
//                     //     fontSize: 20,
//                     //     fontWeight: FontWeight.bold,
//                     //     color: Colors.white,
//                     //     fontFamily: 'Pridi',
//                     //   ),
//                     //     textAlign: TextAlign.center,),
//                     // ),
//                     CustomIconButton(
//                       width: 150,
//                       height: 40,
//                       onTap: () {
//                         Navigator.pop(context);
//                         _undoMove();
//
//                         // TODO: Handle deducting 1 coin
//                       },
//                       label: "Yes",
//                       labelColor: Colors.white,
//                       // iconWidget: Image.asset("assets/coin.png", height: 28), // Replace with your actual icon path
//                     ),
//                     const SizedBox(height: 10),
//                     CustomIconButton(
//                       width: 150,
//                       height: 40,
//                       onTap: () {
//                         Navigator.pop(context);
//                         // _undoMove();
//                         _showUndoDialog();
//                         // TODO: Handle deducting 1 coin
//                       },
//                       label: "No",
//                       labelColor: Colors.white,
//                       // iconWidget: Image.asset("assets/coin.png", height: 28), // Replace with your actual icon path
//                     ),
//                     // ElevatedButton(
//                     //   onPressed: () {
//                     //     Navigator.pop(context); // Close confirmation dialog
//                     //     _showUndoDialog(); // Show the original Undo dialog
//                     //   },
//                     //   style: ElevatedButton.styleFrom(
//                     //     backgroundColor: Colors.blueAccent,
//                     //   ),
//                     //   child: const Text("No",style: TextStyle(
//                     //     fontSize: 20,
//                     //     fontWeight: FontWeight.bold,
//                     //     color: Colors.white,
//                     //     fontFamily: 'Pridi',
//                     //   ),
//                     //     textAlign: TextAlign.center,),
//                     // ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.close, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// void _showGameOverDialog(String message) {
//   bool isDraw = message.toLowerCase().contains('draw');
//   bool playerWon = message.contains('X') && !isDraw;
//   bool opponentWon = message.contains('O') && !isDraw;
//   bool showStars = playerWon || (!widget.isAI && opponentWon);
//   String finalMessage = '';
//   if (isDraw) {
//     finalMessage = 'Better luck next time!';
//   } else if (winner == 'X') {
//     message = 'Player 1 Wins!';
//     finalMessage = widget.isAI ? 'You won against the AI!' : 'Player 1 is the winner!';
//   } else if (winner == 'O') {
//     message = widget.isAI ? 'AI Wins!' : 'Player 2 Wins!';
//     finalMessage = widget.isAI ? 'Oops! You lost this one.' : 'Player 2 played well!';
//   }
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => AlertDialog(
//       backgroundColor: const Color(0xFF040E25),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: const BorderSide(color: Colors.white24),
//       ),
//       title: Column(
//         children: [
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 24,
//             ),
//           ),
//           const SizedBox(height: 10),
//           if (showStars)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Icon(Icons.star, color: Colors.yellow, size: 30),
//                 SizedBox(width: 6),
//                 Icon(Icons.star, color: Colors.yellow, size: 30),
//                 SizedBox(width: 6),
//                 Icon(Icons.star, color: Colors.yellow, size: 30),
//               ],
//             ),
//           const SizedBox(height: 10),
//           Text(
//             finalMessage,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//       actionsAlignment: MainAxisAlignment.center,
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF0A1C3A),
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           ),
//           child: const Text(
//             'Go to Home',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         const SizedBox(width: 10),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//             _resetGame();
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF0A1C3A),
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           ),
//           child: const Text(
//             'Replay',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// bool _checkWinner(int row, int col) {
//   // Check row
//   if (board[row].every((cell) => cell == currentPlayer)) {
//     winningLine = [
//       Offset(0, row * 112.0 + 56), // Start: left center of the row
//       Offset(336, row * 112.0 + 56), // End: right center of the row
//     ];
//     return true;
//   }
//   // Check column
//   if ([board[0][col], board[1][col], board[2][col]].every((cell) => cell == currentPlayer)) {
//     winningLine = [
//       Offset(col * 112.0 + 56, 0), // Start: top center of the column
//       Offset(col * 112.0 + 56, 336), // End: bottom center of the column
//     ];
//     return true;
//   }
//   // Check main diagonal
//   if (row == col && [board[0][0], board[1][1], board[2][2]].every((cell) => cell == currentPlayer)) {
//     winningLine = [
//       const Offset(0, 0), // Start: top-left
//       const Offset(336, 336), // End: bottom-right
//     ];
//     return true;
//   }
//   // Check anti-diagonal
//   if (row + col == 2 && [board[0][2], board[1][1], board[2][0]].every((cell) => cell == currentPlayer)) {
//     winningLine = [
//       const Offset(336, 0), // Start: top-right
//       const Offset(0, 336), // End: bottom-left
//     ];
//     return true;
//   }
//   return false;
// }

// void _handleTap(int row, int col) {
//   if (board[row][col] == '' && !gameOver) {
//     setState(() {
//       moveHistory.add(_copyBoard());
//       board[row][col] = currentPlayer;
//       if (_checkWinner(row, col)) {
//         winner = currentPlayer;
//         gameOver = true;
//         _animationController?.forward();
//       } else if (_isDraw()) {
//         winner = 'Draw';
//         gameOver = true;
//         _showGameOverDialog('It\'s a Draw!');
//       } else {
//         currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//         if (widget.isAI && currentPlayer == 'O' && !gameOver) {
//           _makeAIMove();
//         }
//       }
//     });
//   }
//   // if (board[row][col] == '' && !gameOver && (!widget.isAI || currentPlayer == 'X')) {
//   //   setState(() {
//   //     moveHistory.add(_copyBoard());
//   //     board[row][col] = currentPlayer;
//   //     if (_checkWinner(row, col)) {
//   //       winner = currentPlayer;
//   //       gameOver = true;
//   //       _animationController?.forward();
//   //     } else if (_isDraw()) {
//   //       winner = 'Draw';
//   //       gameOver = true;
//   //       _showGameOverDialog('It\'s a Draw!');
//   //     } else {
//   //       currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
//   //       if (widget.isAI && currentPlayer == 'X' && !gameOver) {
//   //         _makeAIMove();
//   //       }
//   //     }
//   //   });
//   // }
// }

// void _handleTap(int row, int col) {
//   // Allow interaction only if:
//   // - Cell is empty
//   // - Game is not over
//   // - In AI mode: it's the player's turn (X)
//   // - In 2-player mode: always allow
//   if (board[row][col] == '' &&
//       !gameOver &&
//       (!widget.isAI || currentPlayer == 'X')) {
//     setState(() {
//       moveHistory.add(_copyBoard());
//       board[row][col] = currentPlayer;
//       if (_checkWinner(row, col)) {
//         winner = currentPlayer;
//         gameOver = true;
//         _animationController?.forward();
//       } else if (_isDraw()) {
//         winner = 'Draw';
//         gameOver = true;
//         _showGameOverDialog('It\'s a Draw!');
//       } else {
//         currentPlayer = 'O'; // Switch to AI
//         if (widget.isAI) _makeAIMove(); // Trigger AI move
//       }
//     });
//   }
// }

// void _makeAIMove() {
//   if (gameOver) return;
//   var move = widget.difficulty == 'easy'
//       ? _randomMove()
//       : widget.difficulty == 'medium'
//       ? _mediumMove()
//       : _hardMove();
//   if (move != null) {
//     Future.delayed(const Duration(milliseconds: 500), () {
//       _handleTap(move[0], move[1]);
//     });
//   }
// }
