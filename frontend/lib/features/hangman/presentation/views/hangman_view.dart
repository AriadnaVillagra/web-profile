// lib/features/hangman/presentation/views/hangman_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/widgets/neo_nav_buttons.dart';

import '../../../../core/constants/cat_dialogues.dart';
import '../../../../core/widgets/wallpaper.dart';
import '../../../portfolio/presentation/views/portfolio_view.dart';
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
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _dialogues = CatDialogues.getDialoguesFor(GameType.ahorcado);
    _startNewGame();

    // Escucha eventos del teclado físico globalmente
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _focusNode.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && !_gameState.isGameOver && !_gameState.isWon) {
      final character = event.character?.toUpperCase();
      // Verificamos que sea una letra de la A a la Z
      if (character != null && RegExp(r'^[A-Z]$').hasMatch(character)) {
        _handleGuess(character);
        return true;
      }
    }
    return false;
  }

  void _startNewGame() {
    setState(() {
      _gameState = HangmanGameState.random();
    });
    _focusNode.requestFocus();
  }

  void _handleGuess(String letter) {
    if (_gameState.isGameOver || _gameState.isWon) return;

    setState(() {
      _gameState = _gameState.guess(letter);
    });

    // Redirección al portfolio si gana
    if (_gameState.isWon) {
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PortfolioView()),
        );
      });
    }

    _focusNode.requestFocus();
  }

  void _nextDialogue() {
    setState(() {
      _dialogueIndex = (_dialogueIndex + 1) % _dialogues.length;
    });
    _focusNode.requestFocus();
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
      text: currentText,
      groundHeightFactor: 0.12,
      catHeight: 150,
      bubbleHeight: 80,
      onTap: _nextDialogue,
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        child: Column(
          children: [
            // 1. Header (Atrás, Título, Reiniciar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const NeoBackButton(),
                const Text(
                  'AHORCADO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Courier',
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.black,
                    size: 28,
                  ),
                  onPressed: _startNewGame,
                ),
              ],
            ),

            // 2. Contenido interactivo
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HangmanAvatar(isGameOver: _gameState.isGameOver),
                      const SizedBox(height: 12),
                      Text(
                        'INTENTOS RESTANTES: ${_gameState.maxTries - _gameState.wrongGuesses}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      WordDisplay(
                        word: _gameState.secretWord,
                        guessedLetters: _gameState.guessedLetters,
                      ),
                      const SizedBox(height: 16),
                      if (_gameState.isGameOver)
                        ElevatedButton(
                          onPressed: _gameState.isWon
                              ? () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const PortfolioView(),
                                    ),
                                  );
                                }
                              : _startNewGame,
                          child: Text('REINTENTAR'),
                        )
                      else
                        KeyboardGrid(
                          guessedLetters: _gameState.guessedLetters,
                          secretWord: _gameState.secretWord,
                          onLetterPressed: _handleGuess,
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Espacio reservado para el gato
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}
