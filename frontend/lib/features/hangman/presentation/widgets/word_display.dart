import 'package:flutter/material.dart';

import '../../../../core/theme/neobrutalism_theme.dart';

class WordDisplay extends StatelessWidget {
  final String word;
  final Set<String> guessedLetters;

  const WordDisplay({
    super.key,
    required this.word,
    required this.guessedLetters,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: word.split('').map((letter) {
        // Aseguramos la comparación en mayúsculas
        final upperLetter = letter.toUpperCase();
        final isGuessed = guessedLetters.contains(upperLetter);

        return Container(
          width: 42,
          height: 50,
          decoration: BoxDecoration(
            color: isGuessed ? NeoColors.cardBg : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: NeoStyle.border(width: 3),
            boxShadow: NeoStyle.hardShadow(offset: const Offset(3, 3)),
          ),
          child: Center(
            child: Text(
              isGuessed ? upperLetter : '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black, // <--- Color negro explícito para evitar problemas de contraste
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
