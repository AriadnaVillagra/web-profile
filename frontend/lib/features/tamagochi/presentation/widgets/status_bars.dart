import 'package:flutter/material.dart';

import '../../../../core/theme/neobrutalism_theme.dart';

class StatusBars extends StatelessWidget {
  final double hunger;
  final double happiness;

  const StatusBars({super.key, required this.hunger, required this.happiness});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatBar('Hambre 🐟', hunger, NeoColors.primary),
        const SizedBox(height: 12),
        _buildStatBar('Felicidad ❤️', happiness, NeoColors.secondary),
      ],
    );
  }

  Widget _buildStatBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 16,
            backgroundColor: Colors.grey.shade300,
            color: color,
          ),
        ),
      ],
    );
  }
}
