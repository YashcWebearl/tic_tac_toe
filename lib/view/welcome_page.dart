import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_tac_toe/Widget/bg_container.dart';
import 'package:tic_tac_toe/Widget/custom_button.dart';

import 'google_sign_in.dart';
import 'login_page.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      body: BackgroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/tic_tac_toe.png',
            //   width: 300,
            //   height: 100,
            // ),
            Image.asset(
              'assets/XOXO.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 60.h),
            RoundedGradientButton(
              text: 'Register',
              leftIcon: Icon(Icons.app_registration,
                  color: const Color(0xFF2C004C), size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInDemo(isRegistration:true)),
                );
              },
            ),
            SizedBox(height: 20.h),
            RoundedGradientButton(
              text: 'Login',
              leftIcon: Icon(Icons.login,
                  color: const Color(0xFF2C004C), size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SignInDemo(isRegistration: false,)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
