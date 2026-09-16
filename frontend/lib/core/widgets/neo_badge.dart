import 'package:flutter/material.dart';

import '../theme/neobrutalism_theme.dart';

class NeoBadge extends StatelessWidget {
  final String text;
  final Color color;

  const NeoBadge({
    super.key,
    required this.text,
    this.color = NeoColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: NeoStyle.border(width: 2.0),
        boxShadow: NeoStyle.hardShadow(offset: const Offset(3, 3)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
