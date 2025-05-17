// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tic_tac_toe/view/start_screen.dart';
// import '../Widget/bg_container.dart';
// import '../Widget/custom_appbar.dart';
// import '../Widget/custom_button.dart';
// import '../Widget/player_name_dialouge.dart';
// import '../Widget/setting_dialoug.dart';
// import '../main.dart';
// import 'difficulty_screen.dart';
// import 'game.dart';
//
// class ModeSelectionScreen extends StatefulWidget {
//   final bool fromWinner;
//
//   const ModeSelectionScreen({super.key, this.fromWinner = false});
//
//   @override
//   State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
// }
//
// class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
//   void _showDifficultyDialog(BuildContext context) {
//     double _sliderValue = 0; // 0: Easy, 1: Medium, 2: Hard
//     String _difficultyText = 'LOW'; // Displayed text
//     Color _dotColor = Color(0xff00eeff); // Color for the dot and icon
//     Color _textColor = Color(0xff00eeff); // Color for the text
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               // Apply gradient background
//               backgroundColor: Colors.transparent,
//               // Make background transparent to show gradient
//               contentPadding: EdgeInsets.zero,
//               // Remove default padding
//               titlePadding: EdgeInsets.zero,
//               // Remove default title padding
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               content: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xFFA949F2), // Top color
//                       Color(0xFF3304B3), // Bottom color
//                     ],
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Level Difficulty',
//                         style: TextStyle(color: Colors.white,
//                             fontSize: 30,
//                             fontFamily: 'Pridi',
//                             fontWeight: FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 10),
//                       Icon(
//                         Icons.sentiment_very_satisfied,
//                         color: _dotColor, // Match icon color with difficulty
//                         size: 120,
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         _difficultyText,
//                         style: TextStyle(color: _textColor,
//                             fontSize: 20,
//                             fontFamily: 'Pridi',
//                             fontWeight: FontWeight.w500),
//                         // Match text color with difficulty
//                         textAlign: TextAlign.center,
//                       ),
//                       // const SizedBox(height: 20),
//                       Slider(
//                         value: _sliderValue,
//                         min: 0,
//                         max: 2,
//                         divisions: 2,
//                         activeColor: _dotColor,
//                         inactiveColor: Colors.white,
//                         onChanged: (value) {
//                           setState(() {
//                             _sliderValue = value;
//                             if (_sliderValue == 0) {
//                               _difficultyText = 'LOW';
//                               _dotColor = Color(0xff00eeff); // Blue for LOW
//                               _textColor = Color(0xff00eeff);
//                             } else if (_sliderValue == 1) {
//                               _difficultyText = 'MEDIUM';
//                               _dotColor =
//                                   Color(0xffbbff00); // Yellow for MEDIUM
//                               _textColor = Color(0xffbbff00);
//                             } else {
//                               _difficultyText = 'HIGH';
//                               _dotColor = Color(0xffff0000); // Red for HIGH
//                               _textColor = Color(0xffff0000);
//                             }
//                           });
//                         },
//                       ),
//                       // const SizedBox(height: 20),
//                       RoundedGradientButton(
//                         width: 112,
//                         text: 'OK',
//                         onPressed: () {
//                           String difficulty;
//                           if (_sliderValue == 0) {
//                             difficulty = 'Easy';
//                           } else if (_sliderValue == 1) {
//                             difficulty = 'Medium';
//                           } else {
//                             difficulty = 'Hard';
//                           }
//                           Navigator.pop(context); // Close the dialog
//
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   TicTacToeGame(
//                                       isAI: true, difficulty: difficulty),
//                             ),
//                           );
//                         },
//                       ),
//                       // Move the OK button into the content
//                       // ElevatedButton(
//                       //   onPressed: () {
//                       //     String difficulty;
//                       //     if (_sliderValue == 0) {
//                       //       difficulty = 'easy';
//                       //     } else if (_sliderValue == 1) {
//                       //       difficulty = 'medium';
//                       //     } else {
//                       //       difficulty = 'hard';
//                       //     }
//                       //     Navigator.pop(context); // Close the dialog
//                       //     Navigator.push(
//                       //       context,
//                       //       MaterialPageRoute(
//                       //         builder: (context) => TicTacToeGame(isAI: true, difficulty: difficulty),
//                       //       ),
//                       //     );
//                       //   },
//                       //   style: ElevatedButton.styleFrom(
//                       //     backgroundColor: Colors.cyan,
//                       //     shape: const CircleBorder(),
//                       //     padding: const EdgeInsets.all(20),
//                       //   ),
//                       //   child: const Text(
//                       //     'OK',
//                       //     style: TextStyle(color: Colors.white, fontSize: 18),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Remove the actions section since the button is now in content
//               actions: [],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('modal_selection.dart');
//     ScreenUtil.init(context);
//     return WillPopScope(
//       onWillPop: () async {
//         if (widget.fromWinner) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const StartScreen()),
//           );
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         body: BackgroundContainer(
//           child: SingleChildScrollView(
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                 const SizedBox(height: 40),
//             CustomTopBar(
//               coins: 500,
//               onBack: () => Navigator.pop(context),
//               onSettings: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => const SettingsDialog(),
//                 );
//               },
//             ),
//             SizedBox(height: 30),
//             Text('SELECT LEVEL', style: TextStyle(
//                 fontFamily: 'Pridi',
//                 fontSize: 36,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500
//             ),),
//             const SizedBox(height: 15),
//             Image.asset(
//               'assets/tic.png',
//               width: 300,
//               height: 300,
//             ),
//             SizedBox(height: 80),
//             RoundedGradientButton(
//               text: 'VS',
//               leftIcon: const Icon(Icons.person,
//                   color: Color(0xFF2C004C), size: 30),
//               rightIcon: Image.asset('assets/bot.png', width: 30, height: 30),
//
//               onPressed: () {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (
//                 //       context) => const DifficultySelectionScreen()),
//                 // );
//                 _showDifficultyDialog(context);
//               },
//             ),
//             SizedBox(height: 15),
//             RoundedGradientButton(
//               text: 'VS',
//               leftIcon: const Icon(Icons.person,
//                   color: Color(0xFF2C004C), size: 30),
//               rightIcon: const Icon(Icons.person,
//                   color: Color(0xFF2C004C), size: 30),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const TicTacToeGame(isAI: false,difficulty: '',)),
//                 );
//               },
//             ),
//
//             // RoundedGradientButton(
//             //   text: 'VS',
//             //   leftIcon: const Icon(Icons.person, color: Color(0xFF2C004C)),
//             //     rightIcon: Icon(Icons.person, color: Color(0xFF2C004C)),
//             //   onPressed: () {
//             //   showDialog(
//             //     context: context,
//             //     builder: (context) => PlayerNamesDialog(),
//             //   ).then((result) {
//             //     if (result != null) {
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(
//             //           builder: (context) =>
//             //               TicTacToeGame(
//             //                 isAI: false,
//             //                 playerXName: result['x'],
//             //                 playerOName: result['o'],
//             //               ),
//             //         ),
//             //       );
//             //     }
//             //   });
//             // },
//             // )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_tac_toe/view/start_screen.dart';
import '../Widget/bg_container.dart';
import '../Widget/custom_appbar.dart';
import '../Widget/custom_button.dart';
import '../Widget/player_name_dialouge.dart';
import '../Widget/setting_dialoug.dart';
import 'difficulty_screen.dart';
import 'game.dart';

class ModeSelectionScreen extends StatefulWidget {
  final bool fromWinner;

  const ModeSelectionScreen({super.key, this.fromWinner = false});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  void _showDifficultyDialog(BuildContext context) {
    double _sliderValue = 0;
    String _difficultyText = 'LOW';
    Color _dotColor = const Color(0xff00eeff);
    Color _textColor = const Color(0xff00eeff);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
                    colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Level Difficulty',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Pridi',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Icon(
                        Icons.sentiment_very_satisfied,
                        color: _dotColor,
                        size: 120,
                      ),
                      SizedBox(height: 10),
                      Text(
                        _difficultyText,
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 20,
                          fontFamily: 'Pridi',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                              _dotColor = const Color(0xff00eeff);
                              _textColor = const Color(0xff00eeff);
                            } else if (_sliderValue == 1) {
                              _difficultyText = 'MEDIUM';
                              _dotColor = const Color(0xffbbff00);
                              _textColor = const Color(0xffbbff00);
                            } else {
                              _difficultyText = 'HIGH';
                              _dotColor = const Color(0xffff0000);
                              _textColor = const Color(0xffff0000);
                            }
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      RoundedGradientButton(
                        width: 112,
                        text: 'OK',
                        onPressed: () {
                          String difficulty;
                          if (_sliderValue == 0) {
                            difficulty = 'Easy';
                          } else if (_sliderValue == 1) {
                            difficulty = 'Medium';
                          } else {
                            difficulty = 'Hard';
                          }
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicTacToeGame(
                                isAI: true,
                                difficulty: difficulty,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromWinner) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  StartScreen()),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: BackgroundContainer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                CustomTopBar(
                  // coins: 500,
                  onBack: () => Navigator.pop(context),
                  onSettings: () {
                    showDialog(
                      context: context,
                      builder: (context) => const SettingsDialog(),
                    );
                  },
                ),
                SizedBox(height: 30),
                Text(
                  'SELECT LEVEL',
                  style: TextStyle(
                    fontFamily: 'Pridi',
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/tic.png',
                  width: 300,
                  height: 300,
                ),
                SizedBox(height: 80),
                RoundedGradientButton(
                  text: 'VS',
                  leftIcon: Icon(Icons.person,
                      color: const Color(0xFF2C004C), size: 30),
                  rightIcon: Image.asset('assets/bot.png',
                      width: 30, height: 30),
                  onPressed: () {
                    _showDifficultyDialog(context);
                  },
                ),
                SizedBox(height: 15),
                RoundedGradientButton(
                  text: 'VS',
                  leftIcon: Icon(Icons.person,
                      color: const Color(0xFF2C004C), size: 30),
                  rightIcon: Icon(Icons.person,
                      color: const Color(0xFF2C004C), size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const TicTacToeGame(isAI: false, difficulty: ''),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import '../Widget/bg_container.dart';
// import '../Widget/custom_appbar.dart';
// import '../Widget/custom_button.dart';
// import 'difficulty_screen.dart';
// import 'game.dart';
//
// class ModeSelectionScreen extends StatelessWidget {
//   const ModeSelectionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Select Mode'),
//       //   backgroundColor: const Color(0xFF040E25),
//       //   centerTitle: true,
//       //   automaticallyImplyLeading: false,
//       //   leading: GestureDetector(
//       //     onTap: () {
//       //       Navigator.pop(context);
//       //     },
//       //     child: const Icon(Icons.keyboard_backspace_sharp, color: Colors.white),
//       //   ),
//       //   titleTextStyle: const TextStyle(
//       //     color: Colors.white,
//       //     fontSize: 20,
//       //     fontWeight: FontWeight.bold,
//       //   ),
//       // ),
//       body: BackgroundContainer(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: 10),
//               CustomTopBar(
//                 coins: 500,
//                 onBack: () => Navigator.pop(context),
//                 onSettings: () {
//                   // Open settings
//                 },
//               ),
//               SizedBox(height: 30),
//               Text('SELECT LEVEL',style: TextStyle(
//                 fontFamily: 'Pridi',
//                 fontSize: 36,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500
//               ),),
//               const SizedBox(height: 15),
//               Image.asset(
//                 'assets/tic.png',
//                 width: 246,
//                 height: 246,
//               ),
//               SizedBox(height: 60),
//               RoundedGradientButton(
//                 text: 'VS',
//                 // leftIcon: Image.asset('assets/icons/person.png', width: 30, height: 30),
//                 leftIcon: const Icon(Icons.person,
//                     color: Color(0xFF2C004C), size: 30),
//                 rightIcon: Image.asset('assets/bot.png', width: 30, height: 30),
//
//                 onPressed: () {
//                   Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const DifficultySelectionScreen()),
//                 );
//                   // Handle match type
//                 },
//               ),
//               SizedBox(height: 15),
//               RoundedGradientButton(
//                 text: 'VS',
//                 // leftIcon: Image.asset('assets/icons/person.png', width: 30, height: 30),
//                 leftIcon: const Icon(Icons.person,
//                     color: Color(0xFF2C004C), size: 30),
//                 rightIcon: const Icon(Icons.person,
//                     color: Color(0xFF2C004C), size: 30),
//                 onPressed: () {
//                   Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const TicTacToeGame(isAI: false)),
//                 );
//                   // Handle match type
//                 },
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
// import 'difficulty_screen.dart';
// import 'game.dart';
//
// class ModeSelectionScreen extends StatelessWidget {
//   const ModeSelectionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A1C3A), // Dark blue Widget matching the logo
//       appBar: AppBar(
//         title: const Text('Select Mode'),
//         backgroundColor: const Color(0xFF040E25), // Neon purple app bar (matches the O in the logo)
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         leading: GestureDetector(
//           onTap: (){
//             Navigator.pop(context);
//           },
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
//                   MaterialPageRoute(builder: (context) => const TicTacToeGame(isAI: false)),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF040E25), // Neon orange button (matches the X in the logo)
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 textStyle: const TextStyle(fontSize: 18),
//                 // shadowColor: const Color(0xFFFF6F00), // Glow effect matching the button
//                 // elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: const Text(
//                 'Two Players',
//                 style: TextStyle(
//                   color: Colors.white, // Neon green text (matches the grid in the logo)
//                   // shadows: [
//                   //   Shadow(
//                   //     color: Color(0xFF39FF14),
//                   //     blurRadius: 5,
//                   //     offset: Offset(0, 0),
//                   //   ),
//                   // ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const DifficultySelectionScreen()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF040E25), // Neon orange button (matches the X in the logo)
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 textStyle: const TextStyle(fontSize: 18),
//                 // shadowColor: const Color(0xFFFF6F00), // Glow effect matching the button
//                 // elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: const Text(
//                 'Play with AI',
//                 style: TextStyle(
//                   color: Colors.white, // Neon green text (matches the grid in the logo)
//                   // shadows: [
//                   //   Shadow(
//                   //     color: Color(0xFF39FF14),
//                   //     blurRadius: 5,
//                   //     offset: Offset(0, 0),
//                   //   ),
//                   // ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }