import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/neobrutalism_theme.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String lottieAsset;
  final Color backgroundColor;
  final VoidCallback onPlay;

  const GameCard({
    super.key,
    required this.title,
    required this.lottieAsset,
    required this.onPlay,
    this.backgroundColor = NeoColors.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlay,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 160,
        height: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: NeoStyle.border(width: 3.5),
          boxShadow: NeoStyle.hardShadow(offset: const Offset(6, 6)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie en estado estático (sin animar)
            SizedBox(
              height: 60,
              width: 60,
              child: Lottie.asset(
                lottieAsset,
                animate: false, // Mantiene la animación estática
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: NeoColors.border,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
