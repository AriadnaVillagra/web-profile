import 'package:flutter/material.dart';

import '../../../../core/theme/neobrutalism_theme.dart';

class KeyboardGrid extends StatelessWidget {
  final Set<String> guessedLetters;
  final String secretWord;
  final ValueChanged<String> onLetterPressed;

  const KeyboardGrid({
    super.key,
    required this.guessedLetters,
    required this.secretWord,
    required this.onLetterPressed,
  });

  static const List<String> alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: alphabet.map((letter) {
        final isPressed = guessedLetters.contains(letter);
        final isCorrect =
            isPressed && secretWord.toUpperCase().contains(letter);

        Color btnColor = NeoColors.cardBg;
        if (isPressed) {
          btnColor = isCorrect ? const Color(0xFFA3E635) : Colors.grey.shade400;
        }

        return Focus(
          canRequestFocus: false, // <-- Impide que la tecla robe el foco
          child: GestureDetector(
            onTap: isPressed ? null : () => onLetterPressed(letter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 38,
              height: 44,
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(6),
                border: NeoStyle.border(width: 2.5),
                boxShadow: isPressed
                    ? []
                    : NeoStyle.hardShadow(offset: const Offset(2.5, 2.5)),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPressed ? Colors.black45 : NeoColors.border,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
