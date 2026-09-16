// frontend/lib/core/games/game_rule.dart

/// Contrato abstracto que debe cumplir la lógica/controller de cualquier minijuego.
abstract class GameRule {
  /// Devuelve true si las condiciones de victoria del juego se cumplieron.
  bool get isWon;

  /// Devuelve true si el juego terminó en derrota.
  bool get isGameOver;

  /// Evalúa las reglas del juego y determina si el portafolio debe desbloquearse.
  bool checkWinCondition();

  /// Reinicia el juego a su estado inicial.
  void resetGame();
}
