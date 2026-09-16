import 'package:flutter/material.dart';
import 'package:frontend/features/snake/domain/model/snake_game_state.dart';

import '../../../../core/theme/neobrutalism_theme.dart';

class SnakeBoard extends StatelessWidget {
  final SnakeGameState gameState;

  const SnakeBoard({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: NeoStyle.border(width: 3.5),
          boxShadow: NeoStyle.hardShadow(offset: const Offset(6, 6)),
        ),
        padding: const EdgeInsets.all(4),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gameState.gridSize * gameState.gridSize,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gameState.gridSize,
          ),
          itemBuilder: (context, index) {
            final x = index % gameState.gridSize;
            final y = index ~/ gameState.gridSize;
            final point = Point(x, y);

            final isHead =
                gameState.snake.isNotEmpty && gameState.snake.first == point;
            final isSnake = gameState.snake.contains(point);
            final isFood = gameState.food == point;

            Color cellColor = Colors.transparent;
            if (isHead) {
              cellColor = const Color(0xFFA3E635); // Verde Neobrutalista
            } else if (isSnake) {
              cellColor = Colors.black;
            } else if (isFood) {
              cellColor = Colors.redAccent;
            }

            return Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: cellColor,
                borderRadius: BorderRadius.circular(isFood || isHead ? 4 : 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
