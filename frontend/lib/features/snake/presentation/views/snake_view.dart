// frontend/lib/features/snake/presentation/views/snake_view.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/cat_dialogues.dart';
import '../../../../core/theme/neobrutalism_theme.dart';
import '../../../../core/widgets/neo_nav_buttons.dart';
import '../../../../core/widgets/wallpaper.dart';
import '../../../portfolio/presentation/views/portfolio_view.dart';
import '../../domain/model/snake_game_state.dart';
import '../widgets/snake_board.dart';
import '../widgets/snake_controls.dart';

class SnakeView extends StatefulWidget {
  const SnakeView({super.key});

  @override
  State<SnakeView> createState() => _SnakeViewState();
}

class _SnakeViewState extends State<SnakeView> {
  late SnakeGameState _gameState;
  Timer? _timer;
  final FocusNode _focusNode = FocusNode();
  Direction? _activeDirection;

  late List<String> _dialogues;
  int _dialogueIndex = 0;

  @override
  void initState() {
    super.initState();
    _dialogues = CatDialogues.getDialoguesFor(GameType.snake);
    _startNewGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startNewGame() {
    _timer?.cancel();
    setState(() {
      _gameState = SnakeGameState.initial();
      _activeDirection = null;
      _dialogueIndex = 0;
    });
    _focusNode.requestFocus();

    _timer = Timer.periodic(const Duration(milliseconds: 180), (_) {
      if (!_gameState.isGameOver && !_gameState.isWon) {
        setState(() {
          _gameState = _gameState.update();
        });

        if (_gameState.isWon) {
          _timer?.cancel();
          Future.delayed(const Duration(milliseconds: 1800), () {
            if (!mounted) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PortfolioView()),
            );
          });
        }
      }
    });
  }

  void _nextDialogue() {
    setState(() {
      _dialogueIndex = (_dialogueIndex + 1) % _dialogues.length;
    });
  }

  void _changeDirection(Direction direction) {
    setState(() {
      _gameState = _gameState.changeDirection(direction);
      _activeDirection = direction;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    final key = event.logicalKey;

    Direction? targetDirection;
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      targetDirection = Direction.up;
    } else if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.keyS) {
      targetDirection = Direction.down;
    } else if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.keyA) {
      targetDirection = Direction.left;
    } else if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.keyD) {
      targetDirection = Direction.right;
    }

    if (targetDirection != null) {
      if (event is KeyDownEvent) {
        _changeDirection(targetDirection);
      } else if (event is KeyUpEvent) {
        setState(() {
          _activeDirection = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWon = _gameState.isWon;
    final bool isGameOver = _gameState.isGameOver;

    String catText = _dialogues[_dialogueIndex];
    if (isWon) {
      catText =
          "¡Sorprendente! No te comiste la cola. Entrando al portfolio...";
    } else if (isGameOver) {
      catText = "Te chocaste solito... Cuestiono tus habilidades.";
    }

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Wallpaper(
        text: catText,
        onTap: _nextDialogue,
        groundHeightFactor: 0.12,
        catHeight: 150,
        bubbleWidth: 250,
        child: Stack(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -5) _changeDirection(Direction.up);
                if (details.delta.dy > 5) _changeDirection(Direction.down);
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx < -5) _changeDirection(Direction.left);
                if (details.delta.dx > 5) _changeDirection(Direction.right);
              },
              child: Column(
                children: [
                  // 1. Barra superior
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const NeoBackButton(),
                      const Text(
                        'SNAKE HUB',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: NeoColors.border,
                          fontFamily: 'Courier',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: NeoColors.border,
                        ),
                        onPressed: _startNewGame,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PUNTAJE: ${_gameState.score} / ${_gameState.targetScore}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: NeoColors.border,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 2. Tablero + Controles contenidos de forma flexible
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: SnakeBoard(gameState: _gameState),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SnakeControls(
                          onDirectionChanged: _changeDirection,
                          activeDirection: _activeDirection,
                        ),
                      ],
                    ),
                  ),

                  // 3. Espacio reservado para el gato y la viñeta
                  const SizedBox(height: 140),
                ],
              ),
            ),

            // Modal Neobrutalista Game Over / Victoria
            if (isGameOver || isWon)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: NeoStyle.border(width: 3.5),
                          boxShadow: NeoStyle.hardShadow(
                            offset: const Offset(6, 6),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isWon ? '¡GANASTE! 🎉' : '¡GAME OVER! 💀',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isWon
                                    ? const Color(0xFFA3E635)
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isWon
                                  ? '¡Redirigiendo al Portafolio...'
                                  : 'Puntaje Final: ${_gameState.score}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: NeoColors.border,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (isGameOver)
                              ElevatedButton(
                                onPressed: _startNewGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: NeoColors.cardBg,
                                  foregroundColor: NeoColors.border,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  elevation: 0,
                                  side: const BorderSide(
                                    width: 3,
                                    color: NeoColors.border,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'JUGAR OTRA VEZ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Confeti al Ganar
            if (isWon)
              Positioned.fill(
                child: IgnorePointer(
                  child: Lottie.asset(
                    'assets/animations/confeti.json',
                    repeat: false,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
