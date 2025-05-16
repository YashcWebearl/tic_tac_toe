import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Widget/bg_container.dart';
import 'game.dart';

class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    print('difficulty.dart');
    return Scaffold(
      backgroundColor: const Color(0xFF0A1C3A),
      appBar: AppBar(
        title: const Text('Select Difficulty'),
        backgroundColor: const Color(0xFF040E25),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.keyboard_backspace_sharp, color: Colors.white),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BackgroundContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showDifficultyDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF040E25),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Select Difficulty', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    double _sliderValue = 0; // 0: Easy, 1: Medium, 2: Hard
    String _difficultyText = 'LOW'; // Displayed text
    Color _dotColor = Colors.green; // Color for the dot

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF5E2BFF), // Purple background as in the image
              title: const Text(
                'Level Difficult',
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.cyan,
                    size: 80,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _difficultyText,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: _sliderValue,
                    min: 0,
                    max: 2,
                    divisions: 2,
                    activeColor: _dotColor,
                    inactiveColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        if (_sliderValue == 0) {
                          _difficultyText = 'LOW';
                          _dotColor = Colors.green;
                        } else if (_sliderValue == 1) {
                          _difficultyText = 'MEDIUM';
                          _dotColor = Colors.yellow;
                        } else {
                          _difficultyText = 'HIGH';
                          _dotColor = Colors.red;
                        }
                      });
                    },
                  ),
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      String difficulty;
                      if (_sliderValue == 0) {
                        difficulty = 'easy';
                      } else if (_sliderValue == 1) {
                        difficulty = 'medium';
                      } else {
                        difficulty = 'hard';
                      }
                      Navigator.pop(context); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicTacToeGame(isAI: true, difficulty: difficulty),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
// import 'package:flutter/material.dart';
//
// import '../Widget/bg_container.dart';
// import 'game.dart';
// class DifficultySelectionScreen extends StatelessWidget {
//   const DifficultySelectionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A1C3A), // Dark blue Widget matching the logo
//       appBar: AppBar(
//         title: const Text('Select Difficulty'),
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
//       body: BackgroundContainer(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const TicTacToeGame(isAI: true, difficulty: 'easy'),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF040E25),
//                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//                 child: const Text('Easy',style: TextStyle(color: Colors.white),),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const TicTacToeGame(isAI: true, difficulty: 'medium'),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF040E25),
//                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//                 child: const Text('Medium',style: TextStyle(color: Colors.white),),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const TicTacToeGame(isAI: true, difficulty: 'hard'),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF040E25),
//                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//                 child: const Text('Hard',style: TextStyle(color: Colors.white),),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
//
// import 'game.dart';
// class DifficultySelectionScreen extends StatelessWidget {
//   const DifficultySelectionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A1C3A), // Dark blue Widget matching the logo
//       appBar: AppBar(
//         title: const Text('Select Difficulty'),
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
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const TicTacToeGame(isAI: true, difficulty: 'easy'),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF040E25),
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 textStyle: const TextStyle(fontSize: 18),
//               ),
//               child: const Text('Easy',style: TextStyle(color: Colors.white),),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const TicTacToeGame(isAI: true, difficulty: 'medium'),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF040E25),
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 textStyle: const TextStyle(fontSize: 18),
//               ),
//               child: const Text('Medium',style: TextStyle(color: Colors.white),),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const TicTacToeGame(isAI: true, difficulty: 'hard'),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF040E25),
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 textStyle: const TextStyle(fontSize: 18),
//               ),
//               child: const Text('Hard',style: TextStyle(color: Colors.white),),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }