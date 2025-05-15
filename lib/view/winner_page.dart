import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import '../Widget/bg_container.dart';
import '../Widget/custom_appbar.dart';
import '../Widget/setting_dialoug.dart';

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
    // Initialize the confetti controller with a duration of 5 seconds
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    // Start the confetti animation when the page loads
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient and fireworks
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //     ),
          //   ),
          //   child:
          BackgroundContainer(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top bar (similar to the game screen)
                  const SizedBox(height: 40),
                  CustomTopBar(
                    coins: 500,
                    onBack: () => Navigator.pop(context),
                    onSettings: () {
                      showDialog(
                        context: context,
                        builder: (context) => const SettingsDialog(),
                      );
                    },
                  ),
                  // Center content: "You Won!" and "Congratulations"
                  SizedBox(height: 220),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'YOU WON!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pridi',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Congratulations',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pridi',
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Coin reward button
                      GestureDetector(
                        onTap: widget.onContinue,
                        child: Container(
                          width: 112,
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
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Image.asset(
                                  'assets/coin.png', // Replace with your coin asset
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  '20',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C004C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: widget.onContinue,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      //     decoration: BoxDecoration(
                      //       gradient: const LinearGradient(
                      //         colors: [Color(0xFFF4B52E), Color(0xFFDAA520)],
                      //         begin: Alignment.topCenter,
                      //         end: Alignment.bottomCenter,
                      //       ),
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Image.asset(
                      //           'assets/coin.png', // Coin icon
                      //           height: 28,
                      //         ),
                      //         const SizedBox(width: 8),
                      //         Text(
                      //           '${widget.coinReward} Coin',
                      //           style: const TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold,
                      //             fontFamily: 'Pridi',
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  // Spacer to push content up, leaving room for fireworks at the bottom
                  const SizedBox(height: 100),
                ],
              ),
            ),
          // ),
          // Fireworks background (as an overlay)
          // Since I cannot generate the exact fireworks image, you can use a similar asset
          // Place the fireworks image at the top and bottom of the screen
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/fireworks.png',
              height: 150,
              width: 150,// Replace with your fireworks asset
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 110,
            left: 220,
            right: 0,
            child: Image.asset(
              'assets/fireworksRed.png',
              height: 120,
              width: 120,// Replace with your fireworks asset
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 110,
            right: 250,
            // right: 0,
            child: Image.asset(
              'assets/fireworksYellow.png',
              height: 120,
              width: 120,// Replace with your fireworks asset
              fit: BoxFit.contain,
            ),
          ),
          // Positioned(
          //   bottom: 130,
          //   left: 0,
          //   right: 0,
          //   child: Image.asset(
          //     'assets/fireworks.png', // Replace with your fireworks asset
          //     fit: BoxFit.contain,
          //     height: 100,
          //     width: 100,
          //   ),
          // ),
          // Positioned(
          //   bottom: 90,
          //   left: 50,
          //   // right: 0,
          //   child: Image.asset(
          //     'assets/fireworksRed.png',
          //     height: 100,
          //     width: 100,// Replace with your fireworks asset
          //     fit: BoxFit.contain,
          //   ),
          // ),
          // Positioned(
          //   bottom: 90,
          //   right: 50,
          //   // right: 0,
          //   child: Image.asset(
          //     'assets/fireworksYellow.png',
          //     height: 100,
          //     width: 100,// Replace with your fireworks asset
          //     fit: BoxFit.contain,
          //   ),
          // ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/fireworks.png',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 110,
            left: 220,
            right: 0,
            child: Image.asset(
              'assets/fireworksRed.png',
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 110,
            right: 250,
            child: Image.asset(
              'assets/fireworksYellow.png',
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
          ),

          // Confetti animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // Spread confetti everywhere
              shouldLoop: false, // Play animation once
              colors: const [
                Colors.blue,
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.purple,
              ], // Confetti colors
              numberOfParticles: 50,
              maxBlastForce: 50,
              minBlastForce: 20,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}