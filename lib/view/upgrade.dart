import 'package:flutter/material.dart';
import '../Widget/bg_container.dart';
import '../Widget/upgrade_card.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Top-right cancel icon
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Pops back to StartScreen
                  },
                  child: const Icon(
                    Icons.close,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  PackageCard(
                    title: "Free Package",
                    price: "",
                    imagePath: "assets/free.png",
                    isFree: true,
                  ),
                  PackageCard(
                    title: "Prime Package",
                    price: "\$22",
                    imagePath: "assets/preimium.png",
                    isFree: false,
                    isPrime: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
