import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Widget/sound.dart';

class UpgradeOptionDialog extends StatelessWidget {
  final VoidCallback onDollarTap;
  final VoidCallback onCoinTap;

  const UpgradeOptionDialog({
    super.key,
    required this.onDollarTap,
    required this.onCoinTap,
  });

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
                  'Upgrade Option',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'How would you like to upgrade?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionButton(
                      icon: Icons.currency_rupee,
                       // Replace with your coin asset

                      label: 'Rs 200',
                      onTap: () {
                        AudioHelper().playButtonClick();
                        Navigator.of(context).pop();
                        onDollarTap();
                      },
                    ),
                    _buildOptionButton(
                      // icon: Icons.monetization_on_outlined,
                      imagePath: 'assets/coin.png',
                      label: '1000 Coins',
                      onTap: () {
                        AudioHelper().playButtonClick();
                        Navigator.of(context).pop();
                        onCoinTap();
                      },
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

  Widget _buildOptionButton({
    IconData? icon,
    String? imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF49E7F2), Color(0xFF423EB7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
            child: imagePath != null
                ? Image.asset(
              imagePath,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            )
                : Icon(
              icon,
              size: 30,
              color: const Color(0xFF2C004C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
