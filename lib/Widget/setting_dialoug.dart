import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Widget/undobutton.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

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
                  'SETTING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // _settingIcon(Icons.volume_up_outlined),
                    // _settingIcon(Icons.vibration),
                    CustomIconButton(
                      onTap: () {},
                      iconWidget: Icon(Icons.volume_up_outlined, size: 35, color: Colors.black),
                      width: 60,
                      height: 60,
                    ),
                    CustomIconButton(
                      onTap: () {},
                      iconWidget: Icon(Icons.vibration, size: 35, color: Colors.black),
                      width: 60,
                      height: 60,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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

  Widget _settingIcon(IconData iconData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFF49BFEF), Color(0xFF486EF9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(iconData, color: Colors.black, size: 40),
    );
  }
}
