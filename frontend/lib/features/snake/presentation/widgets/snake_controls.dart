import 'package:flutter/material.dart';
import 'package:frontend/features/snake/domain/model/snake_game_state.dart';

import '../../../../core/theme/neobrutalism_theme.dart';

class SnakeControls extends StatelessWidget {
  final ValueChanged<Direction> onDirectionChanged;
  final Direction? activeDirection;

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
          color: isPressed ? const Color(0xFFA3E635) : NeoColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: NeoStyle.border(width: 2.5),
          boxShadow: isPressed
              ? []
              : NeoStyle.hardShadow(offset: const Offset(3, 3)),
        ),
        child: Icon(icon, color: NeoColors.border, size: 28),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment
          .centerLeft, // 👈 Obliga a todo el pad a alinearse a la izquierda
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
        ), // Un pequeño margen respecto al borde
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment
              .start, // 👈 Alinea los hijos de la columna al inicio
          children: [
            // Para centrar la flecha Arriba respecto a la fila de Izq/Der
            Padding(
              padding: const EdgeInsets.only(
                left: 50.0,
              ), // (Ancho botón 50 + espaciado 50) / 2 = offset
              child: _buildButton(Icons.arrow_upward, Direction.up),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildButton(Icons.arrow_back, Direction.left),
                const SizedBox(width: 50),
                _buildButton(Icons.arrow_forward, Direction.right),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: _buildButton(Icons.arrow_downward, Direction.down),
            ),
          ],
        ),
      ),
    );
  }
}
