// frontend/lib/features/memory_card/presentation/views/memory_card_view.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/cat_dialogues.dart';
import '../../../../core/theme/neobrutalism_theme.dart';
import '../../../../core/widgets/neo_nav_buttons.dart';
import '../../../../core/widgets/wallpaper.dart';
import '../../../portfolio/presentation/views/portfolio_view.dart';
import '../../domain/models/memory_card_state.dart';
import '../widgets/memory_card_grid.dart';

class MemoryCardView extends StatefulWidget {
  const MemoryCardView({super.key});

  @override
  State<MemoryCardView> createState() => _MemoryCardViewState();
}

class _MemoryCardViewState extends State<MemoryCardView> {
  late MemoryCardGameState _state;
  late List<String> _dialogues;
  int _dialogueIndex = 0;

  @override
  void initState() {
    super.initState();
    _dialogues = CatDialogues.getDialoguesFor(GameType.memory);
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _state = MemoryCardGameState.initial();
      _dialogueIndex = 0;
    });
  }

  void _nextDialogue() {
    setState(() {
      _dialogueIndex = (_dialogueIndex + 1) % _dialogues.length;
    });
  }

  void _navigateToPortfolio() {
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const PortfolioView()));
  }

  void _onCardTap(int index) async {
    final card = _state.cards[index];

    if (_state.isBusy ||
        _state.isGameOver ||
        _state.isWon ||
        card.isFaceUp ||
        card.isMatched) {
      return;
    }

    // Primer clic
    if (_state.firstSelectedIndex == null) {
      setState(() {
        _state.cards[index] = card.copyWith(isFaceUp: true);
        _state = MemoryCardGameState(
          cards: _state.cards,
          firstSelectedIndex: index,
          moves: _state.moves,
          maxMoves: _state.maxMoves,
        );
      });
      return;
    }

    // Segundo clic
    final firstIndex = _state.firstSelectedIndex!;
    final firstCard = _state.cards[firstIndex];

    setState(() {
      _state.cards[index] = card.copyWith(isFaceUp: true);
      _state = MemoryCardGameState(
        cards: _state.cards,
        firstSelectedIndex: null,
        moves: _state.moves + 1,
        maxMoves: _state.maxMoves,
        isBusy: true,
      );
    });

    // ¿Es par?
    if (firstCard.iconEmoji == card.iconEmoji) {
      setState(() {
        _state.cards[firstIndex] = firstCard.copyWith(isMatched: true);
        _state.cards[index] = card.copyWith(isMatched: true);
        _state = MemoryCardGameState(
          cards: _state.cards,
          moves: _state.moves,
          maxMoves: _state.maxMoves,
          isBusy: false,
        );
      });

      // Evaluar victoria y redirigir
      if (_state.checkWinCondition()) {
        Future.delayed(const Duration(milliseconds: 1800), () {
          _navigateToPortfolio();
        });
      }
    } else {
      // Si fallan, ocultar nuevamente
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() {
        _state.cards[firstIndex] = firstCard.copyWith(isFaceUp: false);
        _state.cards[index] = card.copyWith(isFaceUp: false);
        _state = MemoryCardGameState(
          cards: _state.cards,
          moves: _state.moves,
          maxMoves: _state.maxMoves,
          isBusy: false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWon = _state.isWon;
    final bool isGameOver = _state.isGameOver;

    // Cambiar dinámicamente el mensaje del gato según el estado del juego
    String catText = _dialogues[_dialogueIndex];
    if (isWon) {
      catText = "¡Buena memoria! Te abro el portfolio...";
    } else if (isGameOver) {
      catText = "Te quedaste sin movimientos... Pez dorado.";
    }

    return Wallpaper(
      text: catText,
      onTap: _nextDialogue,
      groundHeightFactor: 0.20,
      catHeight: 150,
      bubbleHeight: 90,
      bubbleWidth: 90,
      catLeft: 365,
      renderBubbleInGround: true,
      child: Stack(
        children: [
          Column(
            children: [
              // Header superior con controles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const NeoBackButton(),
                  const Text(
                    'MEMORY HUB',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: NeoColors.border,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: NeoColors.border),
                    onPressed: _startNewGame,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'MOVIMIENTOS: ${_state.moves} / ${_state.maxMoves}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _state.moves >= _state.maxMoves - 2
                      ? Colors.red
                      : NeoColors.border,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: MemoryCardGrid(
                    cards: _state.cards,
                    onCardTap: _onCardTap,
                  ),
                ),
              ),
            ],
          ),

          // Modal Neobrutalista de Victoria / Derrota
          if (isWon || isGameOver)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
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
                            isWon ? '¡GANASTE! 🎉' : '¡PERDISTE! 💀',
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
                                : 'Te quedaste sin movimientos.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isWon
                                ? _navigateToPortfolio
                                : _startNewGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: NeoColors.cardBg,
                              foregroundColor: NeoColors.border,
                              side: const BorderSide(
                                width: 3,
                                color: NeoColors.border,
                              ),
                            ),
                            child: Text(
                              'REINTENTAR',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Animación de Confeti al Ganar
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
    );
  }
}
