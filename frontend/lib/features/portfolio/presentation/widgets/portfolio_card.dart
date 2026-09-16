import 'package:flutter/material.dart';

import '../../../../core/theme/neobrutalism_theme.dart';
import '../../../../core/widgets/neo_card.dart';
import '../../../../core/widgets/neo_chip.dart';
import '../../data/models/portfolio_model.dart';
import 'device_mockup_player.dart';

class PortfolioCard extends StatelessWidget {
  final PortfolioModel portfolio;

  const PortfolioCard({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobileLayout = constraints.maxWidth < 700;

          final infoSection = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                portfolio.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NeoColors.border,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                portfolio.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              // Chips de Tecnologías
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: portfolio.technologies
                    .map((tech) => NeoChip(label: tech))
                    .toList(),
              ),
            ],
          );

          // Si el proyecto tiene video y marco de celular
          Widget? mockupWidget;
          if (portfolio.videoUrl != null && portfolio.deviceType == 'mobile') {
            mockupWidget = DeviceMockupPlayer(videoUrl: portfolio.videoUrl!);
          }

          if (isMobileLayout || mockupWidget == null) {
            return Column(
              children: [
                if (mockupWidget != null) ...[
                  mockupWidget,
                  const SizedBox(height: 20),
                ],
                infoSection,
              ],
            );
          }

          // En pantallas más anchas (Desktop / Web Desktop), mostramos el mockup a un lado
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 260, child: mockupWidget),
              const SizedBox(width: 24),
              Expanded(child: infoSection),
            ],
          );
        },
      ),
    );
  }
}
