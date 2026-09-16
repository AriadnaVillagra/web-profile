import 'package:flutter/material.dart';
import '../theme/neobrutalism_theme.dart';

class NeoChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const NeoChip({
    super.key,
    required this.label,
    this.backgroundColor = NeoColors.accent,
    this.textColor = NeoColors.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: NeoStyle.border(width: 2.0),
        boxShadow: NeoStyle.hardShadow(offset: const Offset(2, 2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}