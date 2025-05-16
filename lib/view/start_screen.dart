import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_tac_toe/view/modal_selection.dart';
import 'package:tic_tac_toe/view/upgrade.dart';

import '../Widget/bg_container.dart';
import '../Widget/custom_button.dart';
import '../Widget/setting_dialoug.dart';
import '../Widget/sound.dart';
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    print('start.dart');
    return Scaffold(
      body: BackgroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100.h),
            Image.asset(
              'assets/tic_tac_toe.png',
              width: 300.w,
              height: 300.h,
            ),
            SizedBox(height: 50.h),
            RoundedGradientButton(
              text: 'Play',
              leftIcon: Icon(Icons.play_arrow,
                  color: const Color(0xFF2C004C), size: 30),
              onPressed: () {
                // AudioHelper().playButtonClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ModeSelectionScreen()),
                );
              },
            ),
            SizedBox(height: 15.h),
            RoundedGradientButton(
              text: 'Settings',
              leftIcon: Icon(Icons.settings,
                  color: const Color(0xFF2C004C), size: 30),
              onPressed: () {
                // AudioHelper().playButtonClick();
                showDialog(
                  context: context,
                  builder: (context) => const SettingsDialog(),
                );
              },
            ),
            SizedBox(height: 15.h),
            RoundedGradientButton(
              text: 'Upgrade',
              leftIcon: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2C004C),
                        width: 2.5,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      color: const Color(0xFF2C004C),
                      size: 28,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                // AudioHelper().playButtonClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpgradeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}