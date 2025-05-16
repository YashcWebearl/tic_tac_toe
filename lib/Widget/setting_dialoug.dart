// import 'package:flutter/material.dart';
// import 'package:tic_tac_toe/Widget/sound.dart';
// import 'package:tic_tac_toe/Widget/undobutton.dart';
// import 'custom_button.dart';
//
// class SettingsDialog extends StatefulWidget {
//   const SettingsDialog({super.key});
//
//   @override
//   State<SettingsDialog> createState() => _SettingsDialogState();
// }
//
// class _SettingsDialogState extends State<SettingsDialog> {
//   bool _isSoundOn = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _isSoundOn = AudioHelper().isSoundOn;
//   }
//
//   void _toggleSound() async {
//     await AudioHelper().toggleSound();
//     setState(() {
//       _isSoundOn = AudioHelper().isSoundOn;
//     });
//   }
//
//   void _showLogoutConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => const LogoutConfirmationDialog(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Stack(
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 10),
//                 const Text(
//                   'SETTING',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     CustomIconButton(
//                       onTap: _toggleSound,
//                       iconWidget: Icon(
//                         _isSoundOn ? Icons.volume_up_outlined : Icons.volume_off_outlined,
//                         size: 35,
//                         color: Colors.black,
//                       ),
//                       width: 60,
//                       height: 60,
//                     ),
//                     CustomIconButton(
//                       onTap: () {}, // For vibration toggle (optional)
//                       iconWidget: Icon(Icons.vibration, size: 35, color: Colors.black),
//                       width: 60,
//                       height: 60,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 RoundedGradientButton(
//                   text: 'Log Out',
//                   leftIcon: Icon(Icons.exit_to_app_rounded,
//                       color: const Color(0xFF2C004C), size: 30),
//                   onPressed: () {
//                     AudioHelper().playButtonClick();
//                     _showLogoutConfirmationDialog();
//                   },
//                 ),
//               ],
//             ),
//             Positioned(
//               right: 0,
//               top: 0,
//               child: GestureDetector(
//                 onTap: () => Navigator.of(context).pop(),
//                 child: const Icon(Icons.close, color: Colors.white, size: 28),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class LogoutConfirmationDialog extends StatelessWidget {
//   const LogoutConfirmationDialog({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Stack(
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 10),
//                 const Text(
//                   'LOG OUT',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Are you sure you want to log out?',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     RoundedGradientButton(
//                       text: 'Yes',
//                       onPressed: () {
//                         AudioHelper().playButtonClick();
//                         // Add logout logic here (e.g., clear user session, navigate to login screen)
//                         Navigator.of(context).pop(); // Close confirmation dialog
//                         Navigator.of(context).pop(); // Close settings dialog
//                         // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//                       },
//                       width: 100,
//                     ),
//                     RoundedGradientButton(
//                       text: 'No',
//                       onPressed: () {
//                         AudioHelper().playButtonClick();
//                         Navigator.of(context).pop(); // Close confirmation dialog
//                       },
//                       width: 100,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Positioned(
//               right: 0,
//               top: 0,
//               child: GestureDetector(
//                 onTap: () => Navigator.of(context).pop(),
//                 child: const Icon(Icons.close, color: Colors.white, size: 28),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Widget/sound.dart';
import 'package:tic_tac_toe/Widget/undobutton.dart';
import 'custom_button.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool _isSoundOn = true;
  String _selectedTheme = 'Free'; // Default theme

  @override
  void initState() {
    super.initState();
    _isSoundOn = AudioHelper().isSoundOn;
  }

  void _toggleSound() async {
    await AudioHelper().toggleSound();
    setState(() {
      _isSoundOn = AudioHelper().isSoundOn;
    });
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => const LogoutConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'SETTING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onTap: _toggleSound,
                      iconWidget: Icon(
                        _isSoundOn ? Icons.volume_up_outlined : Icons.volume_off_outlined,
                        size: 35,
                        color: Colors.black,
                      ),
                      width: 60,
                      height: 60,
                    ),
                    CustomIconButton(
                      onTap: () {}, // For vibration toggle (optional)
                      iconWidget: Icon(Icons.vibration, size: 35, color: Colors.black),
                      width: 60,
                      height: 60,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'THEME:-',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 5),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Premium',
                          groupValue: _selectedTheme,
                          onChanged: (value) {
                            setState(() {
                              _selectedTheme = value!;
                              AudioHelper().playButtonClick();
                              // Add theme change logic here
                            });
                          },
                          activeColor: Colors.white,
                        ),
                        const Text(
                          'Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Free',
                          groupValue: _selectedTheme,
                          onChanged: (value) {
                            setState(() {
                              _selectedTheme = value!;
                              AudioHelper().playButtonClick();
                              // Add theme change logic here
                            });
                          },
                          activeColor: Colors.white,
                        ),
                        const Text(
                          'Free',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RoundedGradientButton(
                  text: 'Log Out',
                  leftIcon: Icon(Icons.exit_to_app_rounded,
                      color: const Color(0xFF2C004C), size: 30),
                  onPressed: () {
                    AudioHelper().playButtonClick();
                    _showLogoutConfirmationDialog();
                  },
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'LOG OUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(


                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundedGradientButton(
                      text: 'Yes',
                      onPressed: () {
                        AudioHelper().playButtonClick();
                        // Add logout logic here (e.g., clear user session, navigate to login screen)
                        Navigator.of(context).pop(); // Close confirmation dialog
                        Navigator.of(context).pop(); // Close settings dialog
                        // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      width: 100,
                    ),
                    RoundedGradientButton(
                      text: 'No',
                      onPressed: () {
                        AudioHelper().playButtonClick();
                        Navigator.of(context).pop(); // Close confirmation dialog
                      },
                      width: 100,
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:tic_tac_toe/Widget/sound.dart';
// import 'package:tic_tac_toe/Widget/undobutton.dart';
//
// import 'custom_button.dart';
//
// class SettingsDialog extends StatefulWidget {
//   const SettingsDialog({super.key});
//
//   @override
//   State<SettingsDialog> createState() => _SettingsDialogState();
// }
//
// class _SettingsDialogState extends State<SettingsDialog> {
//   bool _isSoundOn = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _isSoundOn = AudioHelper().isSoundOn;
//   }
//
//   void _toggleSound() async {
//     await AudioHelper().toggleSound();
//     setState(() {
//       _isSoundOn = AudioHelper().isSoundOn;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Stack(
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 10),
//                 const Text(
//                   'SETTING',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     CustomIconButton(
//                       onTap: _toggleSound,
//                       iconWidget: Icon(
//                         _isSoundOn ? Icons.volume_up_outlined : Icons.volume_off_outlined,
//                         size: 35,
//                         color: Colors.black,
//                       ),
//                       width: 60,
//                       height: 60,
//                     ),
//                     CustomIconButton(
//                       onTap: () {}, // For vibration toggle (optional)
//                       iconWidget: Icon(Icons.vibration, size: 35, color: Colors.black),
//                       width: 60,
//                       height: 60,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 RoundedGradientButton(
//                   width: 200,
//                   text: 'Log Out ',
//                   leftIcon: Icon(Icons.exit_to_app_rounded,
//                       color: const Color(0xFF2C004C), size: 30),
//                   onPressed: () {
//                     // AudioHelper().playButtonClick();
//                     // showDialog(
//                     //   context: context,
//                     //   builder: (context) => const SettingsDialog(),
//                     // );
//                   },
//                 ),
//               ],
//             ),
//             Positioned(
//               right: 0,
//               top: 0,
//               child: GestureDetector(
//                 onTap: () => Navigator.of(context).pop(),
//                 child: const Icon(Icons.close, color: Colors.white, size: 28),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:tic_tac_toe/Widget/undobutton.dart';
// //
// // class SettingsDialog extends StatelessWidget {
// //   const SettingsDialog({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       backgroundColor: Colors.transparent,
// //       child: Container(
// //         padding: const EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           gradient: const LinearGradient(
// //             colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         child: Stack(
// //           children: [
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 const SizedBox(height: 10),
// //                 const Text(
// //                   'SETTING',
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 22,
// //                     fontWeight: FontWeight.bold,
// //                     letterSpacing: 1,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 30),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     // _settingIcon(Icons.volume_up_outlined),
// //                     // _settingIcon(Icons.vibration),
// //                     CustomIconButton(
// //                       onTap: () {},
// //                       iconWidget: Icon(Icons.volume_up_outlined, size: 35, color: Colors.black),
// //                       width: 60,
// //                       height: 60,
// //                     ),
// //                     CustomIconButton(
// //                       onTap: () {},
// //                       iconWidget: Icon(Icons.vibration, size: 35, color: Colors.black),
// //                       width: 60,
// //                       height: 60,
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //             Positioned(
// //               right: 0,
// //               top: 0,
// //               child: GestureDetector(
// //                 onTap: () => Navigator.of(context).pop(),
// //                 child: const Icon(Icons.close, color: Colors.white, size: 28),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _settingIcon(IconData iconData) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(15),
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFF49BFEF), Color(0xFF486EF9)],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //       ),
// //       child: Icon(iconData, color: Colors.black, size: 40),
// //     );
// //   }
// // }
