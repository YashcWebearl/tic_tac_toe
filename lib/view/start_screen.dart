import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/view/modal_selection.dart';
import 'package:tic_tac_toe/view/upgrade.dart';
import 'package:http/http.dart' as http;

import '../Widget/base.dart';
import '../Widget/bg_container.dart';
import '../Widget/coin_add_service.dart';
import '../Widget/custom_button.dart';
import '../Widget/setting_dialoug.dart';
import '../Widget/sound.dart';

class StartScreen extends StatefulWidget {
  final bool? coinadd;

   StartScreen({super.key,this.coinadd = false});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
    _addCoins(widget.coinadd == true ? 50 : 0);
    _checkAndGiveDailyReward();
  }
  Future<void> _checkAndGiveDailyReward() async {
    final prefs = await SharedPreferences.getInstance();
    final lastClaimDate = prefs.getString('last_claim_date');
    print('last claim date:-$lastClaimDate');

    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";

    if (lastClaimDate != todayString) {
      // Not claimed today
      await _addCoins(20); // Daily reward: 20 coins
      _showCoinReceivedDialog(20, "Daily Reward");
      await prefs.setString('last_claim_date', todayString);
    }
  }

  Future<void> _addCoins(int coins) async {
    if(widget.coinadd == true) {
      try {
        await CoinService.addCoins(coins: 50);
        print("Coins successfully added.");
        _showCoinReceivedDialog(coins, "Coins Added");
      } catch (e) {
        print("Error adding coins: $e");
      }
    }
  }
  // Future<void> _getCoin() async {
  //   if (widget.coinadd == true) {
  //     final uri = Uri.parse('$LURL/api/coin/display');
  //
  //     // Retrieve token from SharedPreferences
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('auth_token');
  //
  //     final response = await http.get(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': token ?? '',
  //       },
  //     );
  //
  //     print('status code:-${response.statusCode}');
  //     print('response body:-${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       final int coins = jsonResponse['coins'];
  //
  //       // ✅ Save coins to SharedPreferences
  //       await prefs.setInt('user_coins', coins);
  //       print('Coins saved: $coins');
  //       _showCoinReceivedDialog(coins);
  //     } else {
  //       print('API error: ${response.statusCode}, ${response.body}');
  //     }
  //   }
  // }

  void _showCoinReceivedDialog(int coins,String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 380,
            height: 225,
            padding: const EdgeInsets.all(16),
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
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                       Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Pridi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // const SizedBox(height: 10),
                      // Image.asset("assets/coin.png", height: 40),
                      // const SizedBox(height: 10),
                      // Text(
                      //   "+$coins",
                      //   style: const TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.w600,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      Container(
                        width: 100,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Image.asset(
                                'assets/coin.png', // Replace with your coin asset
                                width: 25,
                                height: 25,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$coins',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C004C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // CustomIconButton(
                      //   width: 140,
                      //   height: 45,
                      //   onTap: () {
                      //     Navigator.pop(context); // Just close the dialog
                      //   },
                      //   label: "Continue",
                      //   labelColor: Colors.white,
                      //   iconWidget: const Icon(Icons.arrow_forward, color: Colors.white),
                      // ),
                      RoundedGradientButton(
                        text: 'Continue',
                        leftIcon: Icon(Icons.play_arrow,
                            color: const Color(0xFF2C004C), size: 30),
                        onPressed: () {
                          // AudioHelper().playButtonClick();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    print('token is:-${prefs.getString('auth_token')}');
    return prefs.getString('auth_token');
  }

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
