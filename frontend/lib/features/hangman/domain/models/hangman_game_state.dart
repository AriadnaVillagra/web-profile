// frontend/lib/features/hangman/domain/models/hangman_game_state.dart

import 'dart:math';

import '../../../../core/games/game_rule.dart';
import '../../../../core/services/portfolio_access_service.dart';

class HangmanGameState implements GameRule {
  final String secretWord;
  final Set<String> guessedLetters;
  final int maxTries;

  HangmanGameState({
    required this.secretWord,
    required this.guessedLetters,
    this.maxTries = 6,
  });

  static const List<String> wordPool = [
    'FLUTTER',
    'LOTTIE',
    'BRUTALISM',
    'PLANKTON',
    'ARCADE',
    'WIDGET',
    'NEOPOP',
    'DART',
    'TAMAGOTCHI',
    'PIXEL',
  ];

  factory HangmanGameState.random() {
    final random = Random();
    final word = wordPool[random.nextInt(wordPool.length)].toUpperCase();
    return HangmanGameState(secretWord: word, guessedLetters: {});
  }

  int get wrongGuesses =>
      guessedLetters.where((letter) => !secretWord.contains(letter)).length;

  @override
  bool get isGameOver => wrongGuesses >= maxTries;

  @override
  bool get isWon =>
      secretWord.isNotEmpty &&
      secretWord.split('').every((letter) => guessedLetters.contains(letter));

  @override
  bool checkWinCondition() {
    if (isWon) {
      PortfolioAccessService().unlockPortfolio('Ahorcado');
      return true;
    }
    return false;
  }

  @override
  void resetGame() {
    // Al ser inmutable, el reset se hace instanciando una nueva partida en la vista
  }

  HangmanGameState guess(String letter) {
    final upperLetter = letter.toUpperCase();
    if (guessedLetters.contains(upperLetter) || isGameOver || isWon) {
      return this;
    }

    final newState = HangmanGameState(
      secretWord: secretWord,
      guessedLetters: Set<String>.from(guessedLetters)..add(upperLetter),
      maxTries: maxTries,
    );

    // Evaluamos si con este intento se ganó la partida
    newState.checkWinCondition();

    return newState;
  }
}
