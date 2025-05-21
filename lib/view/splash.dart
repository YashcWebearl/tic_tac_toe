import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/Widget/bg_container.dart';
import 'package:tic_tac_toe/view/start_screen.dart';
import 'package:tic_tac_toe/view/welcome_page.dart';
import 'package:tic_tac_toe/Widget/custom_button.dart';

import '../Widget/base.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAppCode();
  }
  Future<String> getAppCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber; // This fetches versionCode from build.gradle
  }
  Future<void> _checkAppCode() async {
    try {
      String _bAppCode = await getAppCode();
      print('app code is from build:-$_bAppCode');
      final response = await http.get(Uri.parse('$LURL/api/user/slash'));
      print('call api');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final String appCode = jsonData['data']['app_code'] ?? "0";
        print('call api 11111111111111111');
        print('current app code is:- $_bAppCode');
        if (appCode == _bAppCode) {
          print('app code is :- $appCode');
          _navigateToNext();
        } else {
          _showUpdateDialog();
        }
      } else {
        // Fallback in case of API failure
        _navigateToNext();
      }
    } catch (e) {
      // Fallback on exception
      _navigateToNext();
    }
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2)); // Short delay before navigating

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  StartScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'UPDATE REQUIRED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Please update the SaptaVidhi app to continue.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // CustomButton(
              //   text: 'Update',
              //   onPressed: () {
              //     // Replace with your update URL
              //     // You could use: launch("https://your-update-url.com");
              //   },
              //   bradius: BorderRadius.circular(25),
              //   gradient: const LinearGradient(
              //     colors: [
              //       Color.fromRGBO(254, 21, 6, 0.51),
              //       Color.fromRGBO(242, 25, 239, 0.77),
              //       Color.fromRGBO(242, 25, 246, 0.24),
              //     ],
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     stops: [0.0, 1.0, 2.0],
              //   ),
              // ),
              RoundedGradientButton(
                text: 'Update',
                leftIcon: Icon(Icons.play_arrow,
                    color: const Color(0xFF2C004C), size: 30),
                onPressed: () {
                  // AudioHelper().playButtonClick();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const ModeSelectionScreen()),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      body: BackgroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset('assets/tic_tac_toe.png', width: 300, height: 100),
                // SizedBox(height: 30.h),
                Image.asset(
                  'assets/XOXO.png',
                  width: 300.w,
                  height: 300.h,
                ),
                // SizedBox(height: 30.h),
                // Image.asset(
                //   'assets/XverseO.png',
                //   width: 300.w,
                //   height: 50.h,
                // ),
                // Image.asset('assets/tic.png', width: 300, height: 300),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: const Text(
                "WebEarl Technologies Pvt Ltd",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff0180d6),
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3.0,
                      color: Colors.white, // White shadow
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tic_tac_toe/Widget/bg_container.dart';
// import 'package:tic_tac_toe/view/start_screen.dart';
// import 'package:tic_tac_toe/view/welcome_page.dart'; // This contains your login/register options
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 3), _navigateToNext);
//   }
//
//   Future<void> _navigateToNext() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//
//     if (token != null && token.isNotEmpty) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) =>  StartScreen()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context);
//
//     return Scaffold(
//       body: BackgroundContainer(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const SizedBox(),
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset(
//                   'assets/tic_tac_toe.png',
//                   width: 300,
//                   height: 100,
//                 ),
//                 SizedBox(height: 30.h),
//                 Image.asset(
//                   'assets/tic.png',
//                   width: 300,
//                   height: 300,
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: 20.h),
//               child: const Text(
//                 "WebEarl Technologies Pvt Ltd",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
