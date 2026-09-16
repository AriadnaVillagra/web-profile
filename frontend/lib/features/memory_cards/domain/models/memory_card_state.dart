// frontend/lib/features/memory_card/domain/models/memory_card_state.dart

import '../../../../core/games/game_rule.dart';
import '../../../../core/services/portfolio_access_service.dart';

class CardModel {
  final int id;
  final String iconEmoji;
  final bool isFaceUp;
  final bool isMatched;

  CardModel({
    required this.id,
    required this.iconEmoji,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  CardModel copyWith({bool? isFaceUp, bool? isMatched}) {
    return CardModel(
      id: id,
      iconEmoji: iconEmoji,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

class MemoryCardGameState implements GameRule {
  final List<CardModel> cards;
  final int? firstSelectedIndex;
  final int moves;
  final int maxMoves;
  final bool isBusy;

  MemoryCardGameState({
    required this.cards,
    this.firstSelectedIndex,
    this.moves = 0,
    this.maxMoves = 12, // Límite para desbloquear el portafolio
    this.isBusy = false,
  });

  factory MemoryCardGameState.initial() {
    final emojis = ['👾', '🎮', '🕹️', '⚡', '🚀', '🔥'];
    final cardPairs = [...emojis, ...emojis];
    cardPairs.shuffle();

    final initialCards = List.generate(
      cardPairs.length,
      (index) => CardModel(id: index, iconEmoji: cardPairs[index]),
    );

    return MemoryCardGameState(cards: initialCards);
  }

  @override
  bool get isWon => cards.isNotEmpty && cards.every((c) => c.isMatched);

  @override
  bool get isGameOver => moves >= maxMoves && !isWon;

  @override
  bool checkWinCondition() {
    if (isWon) {
      PortfolioAccessService().unlockPortfolio('Memory Cards');
      return true;
    }
    return false;
  }

  @override
  void resetGame() {
    // Se gestiona re-instanciando el estado initial en la vista
  }
}
