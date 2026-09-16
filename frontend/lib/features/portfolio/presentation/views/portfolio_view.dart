import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/neo_nav_buttons.dart';

import '../../../../core/theme/neobrutalism_theme.dart';
import '../widgets/portfolio_list_widget.dart';

class PortfolioView extends StatelessWidget {
  const PortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const NeoBackButton(),
        backgroundColor: NeoColors.cardBg,
        elevation: 0,
        leadingWidth: 70,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(color: NeoColors.border, height: 3.0),
        ),
      ),
      body: const PortfolioListWidget(),
    );
  }
}
