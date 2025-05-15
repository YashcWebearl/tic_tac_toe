import 'dart:async';
import 'package:flutter/material.dart';
class AdPlaybackPage extends StatefulWidget {
  final VoidCallback onAdComplete;

  const AdPlaybackPage({super.key, required this.onAdComplete});

  @override
  State<AdPlaybackPage> createState() => _AdPlaybackPageState();
}

class _AdPlaybackPageState extends State<AdPlaybackPage> {
  int _remainingSeconds = 15;
  late Timer _timer;
  bool _showCancelIcon = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _showCancelIcon = true;
          _timer.cancel();
          widget.onAdComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFA949F2), Color(0xFF3304B3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/SkipAd.png',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _showCancelIcon
                    ? GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                )
                    : Text(
                  '$_remainingSeconds',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}