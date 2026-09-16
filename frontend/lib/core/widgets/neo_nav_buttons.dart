import 'package:flutter/material.dart';

import '../theme/neobrutalism_theme.dart';

/// Botón de texto para retroceder (< ATRÁS)
class NeoBackButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const NeoBackButton({super.key, this.label = 'ATRÁS', this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      style: TextButton.styleFrom(
        foregroundColor: NeoColors.border,
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Botón de texto para avanzar (SIGUIENTE >)
class NeoNextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const NeoNextButton({
    super.key,
    this.label = 'SIGUIENTE',
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: NeoColors.border,
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
