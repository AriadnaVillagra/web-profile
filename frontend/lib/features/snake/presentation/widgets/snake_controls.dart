import 'package:flutter/material.dart';
import 'package:frontend/features/snake/domain/model/snake_game_state.dart';

import '../../../../core/theme/neobrutalism_theme.dart';

class SnakeControls extends StatelessWidget {
  final ValueChanged<Direction> onDirectionChanged;
  final Direction?
  activeDirection; // Dirección activa actualmente por teclado o toque

  const SnakeControls({
    super.key,
    required this.onDirectionChanged,
    this.activeDirection,
  });

  Widget _buildButton(IconData icon, Direction direction) {
    final isPressed = activeDirection == direction;

    return GestureDetector(
      onTapDown: (_) => onDirectionChanged(direction),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isPressed
              ? const Color(0xFFA3E635)
              : NeoColors.cardBg, // Cambia a verde al presionar
          borderRadius: BorderRadius.circular(10),
          border: NeoStyle.border(width: 2.5),
          boxShadow: isPressed
              ? [] // Remueve la sombra para simular el hundimiento
              : NeoStyle.hardShadow(offset: const Offset(3, 3)),
        ),
        child: Icon(icon, color: NeoColors.border, size: 28),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(Icons.arrow_upward, Direction.up),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(Icons.arrow_back, Direction.left),
            const SizedBox(width: 50),
            _buildButton(Icons.arrow_forward, Direction.right),
          ],
        ),
        const SizedBox(height: 6),
        _buildButton(Icons.arrow_downward, Direction.down),
      ],
    );
  }
}
