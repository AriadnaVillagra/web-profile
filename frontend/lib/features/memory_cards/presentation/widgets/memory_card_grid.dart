import 'package:flutter/material.dart';

import '../../domain/models/memory_card_state.dart';
import 'memory_card_tile.dart';

class MemoryCardGrid extends StatelessWidget {
  final List<CardModel> cards;
  final Function(int) onCardTap;

  const MemoryCardGrid({
    super.key,
    required this.cards,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return MemoryCardTile(
              card: cards[index],
              onTap: () => onCardTap(index),
            );
          },
        ),
      ),
    );
  }
}
