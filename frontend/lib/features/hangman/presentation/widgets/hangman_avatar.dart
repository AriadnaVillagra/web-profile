import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HangmanAvatar extends StatelessWidget {
  final bool isGameOver;

  const HangmanAvatar({super.key, required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 140,
      child: Lottie.asset(
        isGameOver
            ? 'assets/animations/plankton_tongue.json'
            : 'assets/animations/plankton_evol.json',
        fit: BoxFit.contain,
      ),
    );
  }
}
