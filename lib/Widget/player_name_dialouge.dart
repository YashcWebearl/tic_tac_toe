import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_button.dart';

class PlayerNamesDialog extends StatefulWidget {
  final bool isAi; // NEW PARAMETER

  const PlayerNamesDialog({super.key, this.isAi = false});

  @override
  _PlayerNamesDialogState createState() => _PlayerNamesDialogState();
}

class _PlayerNamesDialogState extends State<PlayerNamesDialog> {
  final TextEditingController _xNameController = TextEditingController();
  final TextEditingController _oNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Enter Player Names',
              style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Pridi'),
            ),
            const SizedBox(height: 20),

            // Player X Input
            TextField(
              controller: _xNameController,
              maxLength: 10,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              decoration: InputDecoration(
                labelText: 'X Player Name',
                labelStyle: const TextStyle(color: Colors.white),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 10),

            // Conditionally render Player O input if not playing with AI
            if (!widget.isAi)
              TextField(
                controller: _oNameController,
                maxLength: 10,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                decoration: InputDecoration(
                  labelText: 'O Player Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                ),
                style: const TextStyle(color: Colors.white),
              ),

            const SizedBox(height: 20),

            // Play Button
            RoundedGradientButton(
              text: 'Play',
              onPressed: () {
                String xName = _xNameController.text.trim().isEmpty
                    ? 'Player 1'
                    : _xNameController.text.trim();
                String oName = widget.isAi
                    ? 'AI'
                    : (_oNameController.text.trim().isEmpty ? 'Player 2' : _oNameController.text.trim());

                Navigator.pop(context, {'x': xName, 'o': oName});
              },
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// import 'custom_button.dart';
// class PlayerNamesDialog extends StatefulWidget {
//   @override
//   _PlayerNamesDialogState createState() => _PlayerNamesDialogState();
// }
//
// class _PlayerNamesDialogState extends State<PlayerNamesDialog> {
//   final TextEditingController _xNameController = TextEditingController();
//   final TextEditingController _oNameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.transparent,
//       contentPadding: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       content: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Enter Player Names',
//                 style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Pridi')),
//             SizedBox(height: 20),
//             TextField(
//               controller: _xNameController,
//               decoration: InputDecoration(
//                 labelText: 'X Player Name',
//                 labelStyle: TextStyle(color: Colors.white),
//                 border: OutlineInputBorder(),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.2),
//               ),
//               style: TextStyle(color: Colors.white),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _oNameController,
//               decoration: InputDecoration(
//                 labelText: 'O Player Name',
//                 labelStyle: TextStyle(color: Colors.white),
//                 border: OutlineInputBorder(),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.2),
//               ),
//               style: TextStyle(color: Colors.white),
//             ),
//             SizedBox(height: 20),
//             RoundedGradientButton(
//               text: 'Play',
//               onPressed: () {
//                 String xName = _xNameController.text.trim().isEmpty
//                     ? 'Player 1'
//                     : _xNameController.text.trim();
//                 String oName = _oNameController.text.trim().isEmpty
//                     ? 'Player 2'
//                     : _oNameController.text.trim();
//                 Navigator.pop(context, {'x': xName, 'o': oName});
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }