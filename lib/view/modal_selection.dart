import 'package:flutter/material.dart';

import 'difficulty_screen.dart';
import 'game.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1C3A), // Dark blue background matching the logo
      appBar: AppBar(
        title: const Text('Select Mode'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TicTacToeGame(isAI: false)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF040E25), // Neon orange button (matches the X in the logo)
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                // shadowColor: const Color(0xFFFF6F00), // Glow effect matching the button
                // elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Two Players',
                style: TextStyle(
                  color: Colors.white, // Neon green text (matches the grid in the logo)
                  // shadows: [
                  //   Shadow(
                  //     color: Color(0xFF39FF14),
                  //     blurRadius: 5,
                  //     offset: Offset(0, 0),
                  //   ),
                  // ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DifficultySelectionScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF040E25), // Neon orange button (matches the X in the logo)
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                // shadowColor: const Color(0xFFFF6F00), // Glow effect matching the button
                // elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Play with AI',
                style: TextStyle(
                  color: Colors.white, // Neon green text (matches the grid in the logo)
                  // shadows: [
                  //   Shadow(
                  //     color: Color(0xFF39FF14),
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





// import 'package:flutter/material.dart';
//
// import 'difficulty_screen.dart';
// import 'game.dart';
// class ModeSelectionScreen extends StatelessWidget {
//   const ModeSelectionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple[50],
//       appBar: AppBar(
//         title: const Text('Select Mode'),
//         backgroundColor: Colors.deepPurple,
//         centerTitle: true,
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
//                 backgroundColor: Colors.deepPurple,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 textStyle: const TextStyle(fontSize: 18),
//               ),
//               child: const Text('Two Players'),
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
//                 backgroundColor: Colors.deepPurple,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 textStyle: const TextStyle(fontSize: 18),
//               ),
//               child: const Text('Play with AI'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }