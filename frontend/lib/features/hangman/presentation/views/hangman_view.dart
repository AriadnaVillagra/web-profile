// lib/features/hangman/presentation/views/hangman_view.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/cat_dialogues.dart';
import '../../../../core/widgets/wallpaper.dart';
import '../../domain/models/hangman_game_state.dart';
import '../widgets/hangman_widgets.dart';

class HangmanView extends StatefulWidget {
  const HangmanView({super.key});

  @override
  State<HangmanView> createState() => _HangmanViewState();
}

class _HangmanViewState extends State<HangmanView> {
  late HangmanGameState _gameState;
  late List<String> _dialogues;
  int _dialogueIndex = 0;

  @override
  void initState() {
    super.initState();
    _dialogues = CatDialogues.getDialoguesFor(GameType.ahorcado);
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _gameState = HangmanGameState.random();
    });
  }

  void _handleGuess(String letter) {
    setState(() {
      _gameState = _gameState.guess(letter);
    });
  }

  void _nextDialogue() {
    setState(() {
      _dialogueIndex = (_dialogueIndex + 1) % _dialogues.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentText = _dialogues[_dialogueIndex];

    if (_gameState.isWon) {
      currentText = "¡Sorprendente! Ganaste... Ya podés ver el portfolio.";
    } else if (_gameState.isGameOver) {
      currentText = "Perdiste. Ni para adivinar palabras servís...";
    }

    return Wallpaper(
      text: currentText, // <-- Cambiado de displayedText a text
      onTap: _nextDialogue,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 28,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Text(
                'AHORCADO',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black, size: 28),
                onPressed: _startNewGame,
              ),
            ],
          ),

          Expanded(
            child: Center(
              child: HangmanAvatar(isGameOver: _gameState.isGameOver),
            ),
          ),

          Text(
            'INTENTOS RESTANTES: ${_gameState.maxTries - _gameState.wrongGuesses}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          WordDisplay(
            word: _gameState.secretWord,
            guessedLetters: _gameState.guessedLetters,
          ),
          const SizedBox(height: 16),
          if (_gameState.isGameOver || _gameState.isWon)
            ElevatedButton(
              onPressed: _startNewGame,
              child: const Text('REINTENTAR'),
            )
          else
            KeyboardGrid(
              guessedLetters: _gameState.guessedLetters,
              secretWord: _gameState.secretWord,
              onLetterPressed: _handleGuess,
            ),
        ],
      ),
    );
  }
}
