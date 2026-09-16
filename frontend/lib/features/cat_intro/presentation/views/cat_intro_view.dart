// lib/features/intro/presentation/views/cat_intro_view.dart

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/cat_dialogues.dart';
import 'package:frontend/core/widgets/wallpaper.dart';

import 'package:frontend/features/arcade/presentation/views/arcade_hub_view.dart';

class CatIntroView extends StatefulWidget {
  const CatIntroView({super.key});

  @override
  State<CatIntroView> createState() => _CatIntroViewState();
}

class _CatIntroViewState extends State<CatIntroView> {
  late final List<String> _dialogues;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _dialogues = CatDialogues.getDialoguesFor(GameType.intro);
  }

  void _onTap() {
    if (_currentIndex < _dialogues.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ArcadeHubView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wallpaper(
      text: _dialogues[_currentIndex],
      onTap: _onTap,
      child: const SizedBox.shrink(), // No hay widget adicional en la vista de intro
    );
  }
}
