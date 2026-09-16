import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/neobrutalism_theme.dart';
import '../../domain/models/memory_card_state.dart';

class MemoryCardTile extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const MemoryCardTile({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final isUnder =
                  (ValueKey(card.isFaceUp || card.isMatched) != child?.key);
              var value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
              return Transform(
                transform: Matrix4.rotationY(value),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: card.isFaceUp || card.isMatched
            ? _buildFrontCard(key: const ValueKey(true))
            : _buildBackCard(key: const ValueKey(false)),
      ),
    );
  }

  Widget _buildFrontCard({required Key key}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: card.isMatched ? const Color(0xFFA3E635) : NeoColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: NeoStyle.border(width: 3),
        boxShadow: NeoStyle.hardShadow(offset: const Offset(3, 3)),
      ),
      child: Center(
        child: Text(card.iconEmoji, style: const TextStyle(fontSize: 32)),
      ),
    );
  }

  Widget _buildBackCard({required Key key}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: NeoStyle.border(width: 3),
        boxShadow: NeoStyle.hardShadow(offset: const Offset(4, 4)),
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: NeoColors.border,
          ),
        ),
      ),
    );
  }
}
