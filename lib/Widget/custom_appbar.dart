import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/Widget/sound.dart';
import 'package:http/http.dart' as http;

import 'base.dart';
import 'coin_noti.dart';

class CustomTopBar extends StatefulWidget {
  // final int coins;
  final VoidCallback onBack;
  final VoidCallback onSettings;
  final bool isGame; // NEW
  final bool isWinner;

  const CustomTopBar({
    super.key,
    // required this.coins,
    required this.onBack,
    required this.onSettings,
    this.isGame = false,
    this.isWinner = false,
  });

  @override
  State<CustomTopBar> createState() => _CustomTopBarState();
}

class _CustomTopBarState extends State<CustomTopBar> {
  int coins = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCoin();
  }
  Future<void> _getCoin() async {
    final uri = Uri.parse('$LURL/api/coin/display');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('token is 11111111:- ${prefs.getString('auth_token')}');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token ?? '',
      },
    );
    print('coin is :- ${coins}');
    print('response is :- ${response.statusCode}');
    print('response  data is :- ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final int fetchedCoins = jsonResponse['coins'];

      // Update the notifier
      CoinNotifier.coins.value = fetchedCoins;

      // Cache the new value
      await prefs.setInt('user_coins', fetchedCoins);
    } else {
      print('API error: ${response.statusCode}, ${response.body}');
    }
  }

  // Future<void> _getCoin() async {
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
  //       coins = jsonResponse['coins'];
  //       setState(() {
  //         coins = coins;
  //       });
  //
  //       // ✅ Save coins to SharedPreferences
  //       await prefs.setInt('user_coins', coins);
  //       print('Coins saved: $coins');
  //
  //       // _showCoinReceivedDialog(coins);
  //     } else {
  //       print('API error: ${response.statusCode}, ${response.body}');
  //     }
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
      color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          widget.isWinner == true ?
      SizedBox(width: 48)
          :
          _buildRoundedIcon(
            icon: widget.isGame ? Icons.close_rounded : Icons.arrow_back_ios_new_rounded,
            onTap: widget.onBack,
          ),
          // _buildRoundedIcon(
          //   icon: Icons.arrow_back_ios_new_rounded,
          //   onTap: onBack,
          // ),

          // Coins Display
          Container(
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
                ValueListenableBuilder<int>(
                    valueListenable: CoinNotifier.coins,
                    builder: (context, coinsValue, child) {
                    return Text(
                      '$coinsValue',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C004C),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),

          // Settings Button
          _buildRoundedIcon(
            icon: Icons.settings,
            onTap: widget.onSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: (){
        AudioHelper().playButtonClick();
        onTap();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF400CB9), // Deep purple
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
