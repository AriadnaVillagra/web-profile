// lib/features/arcade/presentation/views/arcade_hub_view.dart

import 'package:flutter/material.dart';
import 'package:frontend/features/memory_cards/presentation/views/memory_card_view.dart';
import 'package:frontend/features/snake/presentation/views/snake_view.dart';
import 'package:frontend/features/tamagochi/presentation/views/tamagotchi_view.dart';

import '../../../../core/constants/cat_dialogues.dart';
import '../../../../core/widgets/wallpaper.dart';
import '../../../hangman/presentation/views/hangman_view.dart';
import '../widgets/game_card.dart';

class ArcadeHubView extends StatefulWidget {
  const ArcadeHubView({super.key});

  @override
  State<ArcadeHubView> createState() => _ArcadeHubViewState();
}

class _ArcadeHubViewState extends State<ArcadeHubView> {
  late final List<String> _dialogues;
  int _dialogueIndex = 0;

  @override
  void initState() {
    super.initState();
    _dialogues = CatDialogues.getDialoguesFor(GameType.hub);
  }

  void _nextDialogue() {
    setState(() {
      _dialogueIndex = (_dialogueIndex + 1) % _dialogues.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wallpaper(
      text: _dialogues[_dialogueIndex], // <-- Cambiado de displayedText a text
      onTap: _nextDialogue,
      // Variables opcionales para evitar superposiciones en el Hub:
      groundHeightFactor:
          0.22, // Achicamos un poco el suelo para dar más espacio a las cards
      catHeight: 150, // Michi más compacto
      bubbleHeight: 80, // Viñeta compacta
      child: Center(
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              GameCard(
                title: 'Ahorcado',
                lottieAsset: 'assets/animations/plankton_evol.json',
                onPlay: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HangmanView()),
                  );
                },
              ),
              GameCard(
                title: 'Snake',
                lottieAsset: 'assets/animations/plankton_evol.json',
                onPlay: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const SnakeView()));
                },
              ),
              GameCard(
                title: 'Memory',
                lottieAsset: 'assets/animations/plankton_evol.json',
                onPlay: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MemoryCardView()),
                  );
                },
              ),
              GameCard(
                title: 'Tamagotchi',
                lottieAsset: 'assets/animations/plankton_evol.json',
                onPlay: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TamagotchiView()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
