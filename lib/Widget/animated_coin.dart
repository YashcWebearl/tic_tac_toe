import 'package:flutter/material.dart';
class AnimatedCoin extends StatefulWidget {
  final Offset startPosition;
  final Offset targetPosition;
  final VoidCallback onComplete;

  const AnimatedCoin({
    super.key,
    required this.startPosition,
    required this.targetPosition,
    required this.onComplete,
  });

  @override
  State<AnimatedCoin> createState() => _AnimatedCoinState();
}

class _AnimatedCoinState extends State<AnimatedCoin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curvedValue = Curves.easeInOut.transform(_controller.value);

        return Positioned(
          left: widget.startPosition.dx +
              (widget.targetPosition.dx - widget.startPosition.dx) * curvedValue,
          top: widget.startPosition.dy +
              (widget.targetPosition.dy - widget.startPosition.dy) * curvedValue,
          child: Transform.scale(
            scale: 1 - curvedValue * 0.5,
            child: Opacity(
              opacity: 1 - curvedValue,
              child: Image.asset(
                'assets/coin.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}