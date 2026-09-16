// frontend/lib/features/snake/domain/models/snake_game_state.dart

import 'dart:math';

import '../../../../core/games/game_rule.dart';
import '../../../../core/services/portfolio_access_service.dart';

enum Direction { up, down, left, right }

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class SnakeGameState implements GameRule {
  final List<Point> snake;
  final Point food;
  final Direction direction;
  final int score;
  final int targetScore;
  @override
  final bool isGameOver;
  final int gridSize;

  SnakeGameState({
    required this.snake,
    required this.food,
    required this.direction,
    required this.score,
    this.targetScore = 50, // Puntos necesarios para ganar
    required this.isGameOver,
    this.gridSize = 20,
  });

  factory SnakeGameState.initial({int gridSize = 20}) {
    final initialSnake = [
      Point(gridSize ~/ 2, gridSize ~/ 2),
      Point(gridSize ~/ 2, (gridSize ~/ 2) + 1),
    ];
    return SnakeGameState(
      snake: initialSnake,
      food: _generateFood(initialSnake, gridSize),
      direction: Direction.up,
      score: 0,
      isGameOver: false,
      gridSize: gridSize,
    );
  }

  static Point _generateFood(List<Point> snake, int gridSize) {
    final random = Random();
    Point newFood;
    do {
      newFood = Point(random.nextInt(gridSize), random.nextInt(gridSize));
    } while (snake.contains(newFood));
    return newFood;
  }

  @override
  bool get isWon => score >= targetScore;

  @override
  bool checkWinCondition() {
    if (isWon) {
      PortfolioAccessService().unlockPortfolio('Snake');
      return true;
    }
    return false;
  }

  @override
  void resetGame() {}

  SnakeGameState changeDirection(Direction newDirection) {
    if ((direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up) ||
        (direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left)) {
      return this;
    }
    return SnakeGameState(
      snake: snake,
      food: food,
      direction: newDirection,
      score: score,
      targetScore: targetScore,
      isGameOver: isGameOver,
      gridSize: gridSize,
    );
  }

  SnakeGameState update() {
    if (isGameOver || isWon) return this;

    final head = snake.first;
    Point newHead;

    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Colisión con bordes
    if (newHead.x < 0 ||
        newHead.x >= gridSize ||
        newHead.y < 0 ||
        newHead.y >= gridSize) {
      return SnakeGameState(
        snake: snake,
        food: food,
        direction: direction,
        score: score,
        targetScore: targetScore,
        isGameOver: true,
        gridSize: gridSize,
      );
    }

    // Colisión consigo misma
    if (snake.contains(newHead)) {
      return SnakeGameState(
        snake: snake,
        food: food,
        direction: direction,
        score: score,
        targetScore: targetScore,
        isGameOver: true,
        gridSize: gridSize,
      );
    }

    final newSnake = [newHead, ...snake];

    // Comer alimento
    if (newHead == food) {
      final newScore = score + 10;
      final newState = SnakeGameState(
        snake: newSnake,
        food: _generateFood(newSnake, gridSize),
        direction: direction,
        score: newScore,
        targetScore: targetScore,
        isGameOver: false,
        gridSize: gridSize,
      );

      // Evaluamos el desbloqueo al sumar puntos
      newState.checkWinCondition();
      return newState;
    } else {
      newSnake.removeLast();
      return SnakeGameState(
        snake: newSnake,
        food: food,
        direction: direction,
        score: score,
        targetScore: targetScore,
        isGameOver: false,
        gridSize: gridSize,
      );
    }
  }
}
