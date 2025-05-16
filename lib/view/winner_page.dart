// import 'package:flutter/material.dart';
// import 'package:confetti/confetti.dart';
// import '../Widget/bg_container.dart';
// import '../Widget/custom_appbar.dart';
// import '../Widget/custom_button.dart';
// import '../Widget/setting_dialoug.dart';
// import 'modal_selection.dart';
//
// class WinnerPage extends StatefulWidget {
//   final int coinReward;
//   final VoidCallback onContinue;
//
//   const WinnerPage({
//     super.key,
//     required this.coinReward,
//     required this.onContinue,
//   });
//
//   @override
//   State<WinnerPage> createState() => _WinnerPageState();
// }
//
// class _WinnerPageState extends State<WinnerPage> {
//   late ConfettiController _confettiController;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the confetti controller with a duration of 5 seconds
//     _confettiController = ConfettiController(duration: const Duration(seconds: 5));
//     // Start the confetti animation when the page loads
//     _confettiController.play();
//   }
//
//   @override
//   void dispose() {
//     _confettiController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       WillPopScope(
//         onWillPop: () async {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const ModeSelectionScreen(fromWinner: true),
//             ),
//           );
//           return false;
//         },
//         child: Scaffold(
//           body: Stack(
//             children: [
//               BackgroundContainer(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 40),
//                     CustomTopBar(
//                       coins: 500,
//                       isWinner:true,
//                       onBack: (){
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const ModeSelectionScreen(fromWinner: true),
//                           ),
//                         );
//                       },
//                       onSettings: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) => const SettingsDialog(),
//                         );
//                       },
//                     ),
//                     // Center content: "You Won!" and "Congratulations"
//                     // SizedBox(height: 100),
//
//                     // Spacer to push content up, leaving room for fireworks at the bottom
//                     // const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 top: 150,
//                 left: 0,
//                 right: 0,
//                 child: Image.asset(
//                   'assets/fireworks.png',
//                   height: 150,
//                   width: 150,// Replace with your fireworks asset
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Positioned(
//                 top: 110,
//                 left: 220,
//                 right: 0,
//                 child: Image.asset(
//                   'assets/fireworksRed.png',
//                   height: 120,
//                   width: 120,// Replace with your fireworks asset
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Positioned(
//                 top: 110,
//                 right: 250,
//                 // right: 0,
//                 child: Image.asset(
//                   'assets/fireworksYellow.png',
//                   height: 120,
//                   width: 120,// Replace with your fireworks asset
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Positioned(
//                 bottom: 100,
//                 left: 0,
//                 right: 0,
//                 child: Image.asset(
//                   'assets/fireworks.png',
//                   height: 150,
//                   width: 150,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Positioned(
//                 bottom: 70,
//                 left: 220,
//                 right: 0,
//                 child: Image.asset(
//                   'assets/fireworksRed.png',
//                   height: 120,
//                   width: 120,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Positioned(
//                 bottom: 70,
//                 right: 250,
//                 child: Image.asset(
//                   'assets/fireworksYellow.png',
//                   height: 120,
//                   width: 120,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'YOU WON!',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 48,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Pridi',
//                       ),
//                     ),
//                     // const SizedBox(height: 10),
//                     const Text(
//                       'Congratulations',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Pridi',
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     // Coin reward button
//                     GestureDetector(
//                       // onTap: widget.onContinue,
//                       child: Container(
//                         width: 112,
//                         height: 50,
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF56D8FF), Color(0xFF2E9AFF)],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                         child: Row(
//                           // crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(top: 0.0),
//                               child: Image.asset(
//                                 'assets/coin.png', // Replace with your coin asset
//                                 width: 25,
//                                 height: 25,
//                               ),
//                             ),
//                             const SizedBox(width: 5),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 5.0),
//                               child: Text(
//                                 '20',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF2C004C),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         RoundedGradientButton(
//                           width: 115,
//                           text: 'Home',
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const ModeSelectionScreen(fromWinner: true),
//                               ),
//                             );
//                           },
//                         ),
//                         RoundedGradientButton(
//                           width: 115,
//                           text: 'Replay',
//                           onPressed: () {
//                             widget.onContinue;
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Confetti animation
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: ConfettiWidget(
//                   confettiController: _confettiController,
//                   blastDirectionality: BlastDirectionality.explosive, // Spread confetti everywhere
//                   shouldLoop: false, // Play animation once
//                   colors: const [
//                     Colors.blue,
//                     Colors.red,
//                     Colors.yellow,
//                     Colors.green,
//                     Colors.purple,
//                   ], // Confetti colors
//                   numberOfParticles: 50,
//                   maxBlastForce: 50,
//                   minBlastForce: 20,
//                   gravity: 0.3,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//   }
// }


import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../Widget/bg_container.dart';
import '../Widget/custom_appbar.dart';
import '../Widget/custom_button.dart';
import '../Widget/setting_dialoug.dart';
import '../Widget/sound.dart';
import 'modal_selection.dart';

class WinnerPage extends StatefulWidget {
  final int coinReward;
  final VoidCallback onContinue;

  const WinnerPage({
    super.key,
    required this.coinReward,
    required this.onContinue,
  });

  @override
  State<WinnerPage> createState() => _WinnerPageState();
}

class _WinnerPageState extends State<WinnerPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('winner_page.dart');
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ModeSelectionScreen(fromWinner: true),
          ),
        );
        return false;
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                BackgroundContainer(
                  child: Column(
                    children: [
                      SizedBox(height: screenSize.height * 0.04),
                      CustomTopBar(
                        coins: 500,
                        isWinner: true,
                        onBack: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ModeSelectionScreen(fromWinner: true),
                            ),
                          );
                        },
                        onSettings: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SettingsDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Fireworks positioning
                ..._buildFireworks(screenSize, isPortrait),

                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'YOU WON!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isPortrait
                                ? screenSize.width * 0.12
                                : screenSize.height * 0.12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pridi',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // SizedBox(height: screenSize.height * 0.01),
                        Text(
                          'Congratulations',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isPortrait
                                ? screenSize.width * 0.06
                                : screenSize.height * 0.06,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pridi',
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        _buildCoinRewardButton(screenSize),
                        SizedBox(height: screenSize.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RoundedGradientButton(
                              width: 115,
                              text: 'Home',
                              onPressed: () {
                                AudioHelper().stopWinOrLoseSound();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ModeSelectionScreen(fromWinner: true),
                                  ),
                                );
                              },
                            ),
                            RoundedGradientButton(
                              width: 115,
                              text: 'Replay',
                              onPressed: () {
                                AudioHelper().stopWinOrLoseSound();
                                widget.onContinue(); // This triggers the game reset
                              },
                            ),
                            // RoundedGradientButton(
                            //   width: 115,
                            //   text: 'Replay',
                            //   onPressed: () {
                            //     AudioHelper().stopWinOrLoseSound();
                            //     print('click on replay');
                            //     // widget.onContinue;
                            //     Navigator.pop(context);
                            //
                            //   },
                            // ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                      ],
                    ),
                  ),
                ),

                // Confetti animation
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.blue,
                      Colors.red,
                      Colors.yellow,
                      Colors.green,
                      Colors.purple,
                    ],
                    numberOfParticles: 50,
                    maxBlastForce: 50,
                    minBlastForce: 20,
                    gravity: 0.3,
                    emissionFrequency: 0.05,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildFireworks(Size screenSize, bool isPortrait) {
    return [
      Positioned(
        top: screenSize.height * 0.2 ,
        left: screenSize.width * 0.35,
        child: _buildFireworkImage('assets/fireworks.png', screenSize),
      ),
      Positioned(
        top: screenSize.height * 0.15,
        right: screenSize.width * 0.15,
        child: _buildFireworkImage('assets/fireworksRed.png', screenSize),
      ),
      Positioned(
        top: screenSize.height * 0.15,
        left: screenSize.width * 0.15,
        child: _buildFireworkImage('assets/fireworksYellow.png', screenSize),
      ),
      Positioned(
        bottom:  screenSize.height * 0.2,
        right: screenSize.width * 0.35,
        child: _buildFireworkImage('assets/fireworks.png', screenSize),
      ),
      Positioned(
        bottom: screenSize.height * 0.15,
        left: screenSize.width * 0.15,
        child: _buildFireworkImage('assets/fireworksRed.png', screenSize),
      ),
      Positioned(
        bottom: screenSize.height * 0.15 ,
        right: screenSize.width * 0.15,
        child: _buildFireworkImage('assets/fireworksYellow.png', screenSize),
      ),
    ];
  }

  Widget _buildFireworkImage(String asset, Size screenSize) {
    return Image.asset(
      asset,
      height: screenSize.height * 0.15,
      width: screenSize.height * 0.15,
      fit: BoxFit.contain,
    );
  }

  Widget _buildCoinRewardButton(Size screenSize) {
    return GestureDetector(
      onTap: (){
        AudioHelper().playMoneySound();
      },
      child: Container(
        width: 100,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF56D8FF), Color(0xFF2E9AFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/coin.png',
              width: 30,
              height: 30,
            ),
            SizedBox(width: 5),
            Text(
              widget.coinReward.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C004C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:confetti/confetti.dart';
// import '../Widget/bg_container.dart';
// import '../Widget/custom_appbar.dart';
// import '../Widget/setting_dialoug.dart';
// import 'modal_selection.dart';
//
// class WinnerPage extends StatefulWidget {
//   final int coinReward;
//   final VoidCallback onContinue;
//   const WinnerPage({
//     super.key,
//     required this.coinReward,
//     required this.onContinue,
//   });
//   @override
//   State<WinnerPage> createState() => _WinnerPageState();
// }
// class _WinnerPageState extends State<WinnerPage> {
//   late ConfettiController _confettiController;
//   @override
//   void initState() {
//     super.initState();
//     _confettiController = ConfettiController(duration: const Duration(seconds: 5));
//     _confettiController.play();
//   }
//   @override
//   void dispose() {
//     _confettiController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const ModeSelectionScreen(fromWinner: true),
//           ),
//         );
//         return false;
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             BackgroundContainer(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   CustomTopBar(
//                     coins: 500,
//                     onBack: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ModeSelectionScreen(fromWinner: true),
//                         ),
//                       );
//                     },
//                     onSettings: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => const SettingsDialog(),
//                       );
//                     },
//                   ),
//                   SizedBox(height: 180),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'YOU WON!',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 48,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Pridi',
//                         ),
//                       ),
//                       const Text(
//                         'Congratulations',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Pridi',
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: widget.onContinue,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 0.0),
//                                   child: Image.asset(
//                                     'assets/coin.png', // Replace with your coin asset
//                                     width: 50,
//                                     height: 50,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 0.0),
//                                   child: Image.asset(
//                                     'assets/20.png',
//                                     height: 80,
//                                     width: 80,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Image.asset(
//                         'assets/Box.png',
//                         height: 200,
//                         width: 200,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//
//             Positioned(
//               top: 150,
//               left: 0,
//               right: 0,
//               child: Image.asset(
//                 'assets/fireworks.png',
//                 height: 150,
//                 width: 150,// Replace with your fireworks asset
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Positioned(
//               top: 110,
//               left: 220,
//               right: 0,
//               child: Image.asset(
//                 'assets/fireworksRed.png',
//                 height: 120,
//                 width: 120,// Replace with your fireworks asset
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Positioned(
//               top: 110,
//               right: 250,
//               child: Image.asset(
//                 'assets/fireworksYellow.png',
//                 height: 120,
//                 width: 120,// Replace with your fireworks asset
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Positioned(
//               bottom: 150,
//               left: 0,
//               right: 0,
//               child: Image.asset(
//                 'assets/fireworks.png',
//                 height: 150,
//                 width: 150,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Positioned(
//               bottom: 110,
//               left: 220,
//               right: 0,
//               child: Image.asset(
//                 'assets/fireworksRed.png',
//                 height: 120,
//                 width: 120,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Positioned(
//               bottom: 110,
//               right: 250,
//               child: Image.asset(
//                 'assets/fireworksYellow.png',
//                 height: 120,
//                 width: 120,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Align(
//               alignment: Alignment.topCenter,
//               child: ConfettiWidget(
//                 confettiController: _confettiController,
//                 blastDirectionality: BlastDirectionality.explosive, // Spread confetti everywhere
//                 shouldLoop: false, // Play animation once
//                 colors: const [
//                   Colors.blue,
//                   Colors.red,
//                   Colors.yellow,
//                   Colors.green,
//                   Colors.purple,
//                 ], // Confetti colors
//                 numberOfParticles: 50,
//                 maxBlastForce: 50,
//                 minBlastForce: 20,
//                 gravity: 0.3,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



