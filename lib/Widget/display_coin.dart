import 'package:flutter/material.dart';

import 'coin_noti.dart';

class CoinDisplay extends StatelessWidget {
  final Key? keyWidget;

  const CoinDisplay({super.key, this.keyWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: keyWidget,
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
              'assets/coin.png', // Update this path if needed
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
            },
          ),
        ],
      ),
    );
  }
}
