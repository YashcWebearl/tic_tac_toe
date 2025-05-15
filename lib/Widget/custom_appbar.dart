import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget {
  final int coins;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  const CustomTopBar({
    super.key,
    required this.coins,
    required this.onBack,
    required this.onSettings,
  });

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
          _buildRoundedIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),

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

          // Settings Button
          _buildRoundedIcon(
            icon: Icons.settings,
            onTap: onSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF400CB9), // Deep purple
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
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
