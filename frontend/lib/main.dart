import 'package:flutter/material.dart';
import 'package:frontend/features/cat_intro/presentation/views/cat_intro_view.dart';

import 'core/theme/neobrutalism_theme.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portafolio Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: NeoColors.background,
        useMaterial3: true,
      ),
      home: const CatIntroView(),
    );
  }
}
