import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tic_tac_toe/view/modal_selection.dart';

void main() {
  runApp(const MaterialApp(
    home: StartScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1C3A), // Dark blue background like the logo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png', // Your Tic Tac Toe logo
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ModeSelectionScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF040E25), // Neon purple button color (matches the O in the logo)
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                // shadowColor: const Color(0xFFD81BDE), // Glow effect matching the button
                // elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(
                  color: const Color(0xFFFFFFFF), // Neon green text (matches the grid in the logo)
                  // shadows: [
                  //   Shadow(
                  //     color: const Color(0xFF39FF14),
                  //     blurRadius: 5,
                  //     offset: Offset(0, 0),
                  //   ),
                  // ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}