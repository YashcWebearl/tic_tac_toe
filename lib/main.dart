// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tic_tac_toe/view/google_sign_in.dart';
// import 'package:tic_tac_toe/view/start_screen.dart';
//
// import 'Widget/sound.dart';
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('sound fetch');
//   await AudioHelper().initialize();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]).then((_) {
//     runApp(const MyApp());
//   });
//   // runApp(
//   //   const MyApp(),
//   // );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return  MaterialApp(
//           debugShowCheckedModeBanner: false,
//           // home: StartScreen(),
//           home: SignInDemo(),
//         );
import 'dart:async';

//       },
//     );
//   }
// }



import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_tac_toe/view/game.dart';
import 'package:tic_tac_toe/view/google_sign_in.dart';
import 'package:tic_tac_toe/view/splash.dart';
import 'package:tic_tac_toe/view/start_screen.dart';
import 'package:tic_tac_toe/view/welcome_page.dart';
import 'package:tic_tac_toe/view/winner_page.dart';

import 'Widget/coin_noti.dart';
import 'Widget/sound.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('sound fetch');

  await AudioHelper().initialize();

  // Set portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await CoinNotifier.initialize();
  MobileAds.instance.initialize();
  runApp(const MyApp()); // ← No need to pass login state here
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final isOffline = results.contains(ConnectivityResult.none);
      if (isOffline) {
        Fluttertoast.showToast(msg: "You're offline");
      }
    });
    _checkLoginStatus();
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('token is: $token');
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return SafeArea(
          bottom: true,
          top: false,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // home: isLoggedIn == null
            //     ? const Scaffold(
            //   body: Center(child: CircularProgressIndicator()),
            // )
            //     : isLoggedIn!
            //     ?  StartScreen()
            //     :  WelcomeScreen()

            home: const SplashScreen(),

          ),
        );
      },
    );
  }
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('sound fetch');
//
//   await AudioHelper().initialize();
//
//   // Set portrait orientation
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//
//   // Get auth token
//   final prefs = await SharedPreferences.getInstance();
//   final String? token = prefs.getString('auth_token');
//   print('token is:-$token');
//   // Run app and pass token status
//   runApp(MyApp(isLoggedIn: token != null && token.isNotEmpty));
// }
// class MyApp extends StatelessWidget {
//   final bool isLoggedIn;
//
//   const MyApp({super.key, required this.isLoggedIn});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: isLoggedIn ?  StartScreen() :  SignInDemo(),
//           // home: StartScreen(),
//         );
//       },
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:tic_tac_toe/view/modal_selection.dart';
// import 'package:tic_tac_toe/view/upgrade.dart';
// import 'Widget/bg_container.dart';
// import 'Widget/custom_button.dart';
// import 'Widget/setting_dialoug.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     home: StartScreen(),
//     debugShowCheckedModeBanner: false,
//   ));
// }
//
// class StartScreen extends StatelessWidget {
//   const StartScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BackgroundContainer(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 150),
//             Image.asset(
//               'assets/tic_tac_toe.png',
//               width: 300,
//               height: 300,
//             ),
//             const SizedBox(height: 50),
//             RoundedGradientButton(
//               text: 'Play',
//               leftIcon: const Icon(Icons.play_arrow,
//                   color: Color(0xFF2C004C), size: 30),
//               onPressed: () {
//                 // Handle play
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ModeSelectionScreen()),
//                 );
//               },
//             ),
//             SizedBox(height: 15),
//             RoundedGradientButton(
//               text: 'Settings',
//               leftIcon: const Icon(Icons.settings,
//                   color: Color(0xFF2C004C), size: 30),
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => const SettingsDialog(),
//                 );
//               },
//             ),
//             SizedBox(height: 15),
//             RoundedGradientButton(
//               text: 'Upgrade',
//               leftIcon: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: const BoxDecoration(
//                  color: Colors.transparent
//                 ),
//                 child: Center(
//                   child: Container(
//                     width: 40,
//                     height: 30,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Color(0xFF2C004C), // Dark border
//                         width: 2.5,
//                       ),
//                     ),
//                     child: Icon(
//                       Icons.arrow_upward,
//                       color: Color(0xFF2C004C),
//                       size: 28,
//                     ),
//                   ),
//                 ),
//               ),
//               // leftIcon: const Icon(Icons.win,
//               //     color: Color(0xFF2C004C), size: 30),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const UpgradeScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class StartScreen extends StatelessWidget {
//   const StartScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BackgroundContainer(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 109),
//             Image.asset(
//               'assets/tic_tac_toe.png',
//               width: 200,
//               height: 200,
//             ),
//             const SizedBox(height: 30),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => const ModeSelectionScreen()),
//             //     );
//             //   },
//             //   style: ElevatedButton.styleFrom(
//             //     backgroundColor: const Color(0xFF040E25),
//             //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//             //     textStyle: const TextStyle(fontSize: 18),
//             //     shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(30),
//             //     ),
//             //   ),
//             //   child: const Text(
//             //     'Start Game',
//             //     style: TextStyle(
//             //       color: Color(0xFFFFFFFF),
//             //     ),
//             //   ),
//             // ),
//             // RoundedGradientButton(
//             //   text: 'Play',
//             //   icon: Icons.play_arrow,
//             //   onPressed: () {
//             //     // Your logic here
//             //     Navigator.push(
//             //               context,
//             //               MaterialPageRoute(builder: (context) => const ModeSelectionScreen()),
//             //             );
//             //   },
//             // ),
//             RoundedGradientButton(
//               text: 'Play',
//               leftIcon: const Icon(Icons.play_arrow,
//                   color: Color(0xFF2C004C), size: 30),
//               onPressed: () {
//                 // Handle play
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ModeSelectionScreen()),
//                 );
//               },
//             ),
//             SizedBox(height: 15),
//             RoundedGradientButton(
//               text: 'Settings',
//               leftIcon: const Icon(Icons.play_arrow,
//                   color: Color(0xFF2C004C), size: 30),
//               onPressed: () {
//                 // Handle play
//                 // Navigator.push(
//                 //           context,
//                 //           MaterialPageRoute(builder: (context) => const ModeSelectionScreen()),
//                 //         );
//               },
//             )
//             // RoundedGradientButton(
//             //   text: 'Settings',
//             //   icon: Icons.settings,
//             //   onPressed: () {
//             //     // Your logic here
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => const ModeSelectionScreen()),
//             //     );
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }






// class StartScreen extends StatelessWidget {
//   const StartScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A1C3A), // Dark blue Widget like the logo
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/tic_tac_toe.png', // Your Tic Tac Toe logo
//               width: 200,
//               height: 200,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ModeSelectionScreen()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF040E25), // Neon purple button color (matches the O in the logo)
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 textStyle: const TextStyle(fontSize: 18),
//                 // shadowColor: const Color(0xFFD81BDE), // Glow effect matching the button
//                 // elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: const Text(
//                 'Start Game',
//                 style: TextStyle(
//                   color: const Color(0xFFFFFFFF), // Neon green text (matches the grid in the logo)
//                   // shadows: [
//                   //   Shadow(
//                   //     color: const Color(0xFF39FF14),
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
