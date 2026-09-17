import 'package:flutter/material.dart';
import 'package:frontend/core/helpers/url_helper.dart';

import '../../../../core/theme/neobrutalism_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/datasources/portfolio_remote_datasource.dart';
import '../../data/models/portfolio_model.dart';
import 'device_mockup_player.dart';

class PortfolioListWidget extends StatefulWidget {
  const PortfolioListWidget({super.key});

  @override
  State<PortfolioListWidget> createState() => _PortfolioListWidgetState();
}

class _PortfolioListWidgetState extends State<PortfolioListWidget> {
  final PortfolioRemoteDataSource _dataSource = PortfolioRemoteDataSource();
  late Future<List<PortfolioModel>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _dataSource.getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PortfolioModel>>(
      future: _projectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: NeoColors.border),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: NeoCard(
              backgroundColor: const Color(0xFFFFD1D1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: NeoColors.primary,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al conectar con la API: ${snapshot.error}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No hay proyectos registrados.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          );
        }

        final projects = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: NeoCard(
                backgroundColor: NeoColors.cardBg,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobileWidth = constraints.maxWidth < 700;

                    // Widget de demostración en celular (si contiene video y frame)
                    Widget? mockupWidget;
                    if (project.videoUrl != null &&
                        project.videoUrl!.isNotEmpty &&
                        project.deviceType == 'mobile') {
                      mockupWidget = DeviceMockupPlayer(
                        videoUrl: project.videoUrl!,
                      );
                    }

                    // Bloque con los detalles del proyecto (Título, Desc, Chips, Botones)
                    final detailsWidget = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                project.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: NeoColors.border,
                                ),
                              ),
                            ),
                            if (project.featured) ...[
                              const SizedBox(width: 8),
                              const NeoBadge(
                                text: 'Featured',
                                color: NeoColors.primary,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          project.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: NeoColors.border,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: project.technologies.map((tech) {
                            return NeoChip(
                              label: tech,
                              backgroundColor: NeoColors.accent,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            if (project.liveUrl != null &&
                                project.liveUrl!.isNotEmpty) ...[
                              NeoButton(
                                backgroundColor: NeoColors.secondary,
                                onPressed: () => UrlHelper.launchExternalUrl(
                                  project.liveUrl!,
                                ),
                                child: Text(
                                  (project.liveUrlLabel != null &&
                                          project.liveUrlLabel!.isNotEmpty)
                                      ? project.liveUrlLabel!
                                      : 'Ver Demo Live',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: NeoColors.border,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            if (project.githubUrl != null &&
                                project.githubUrl!.isNotEmpty) ...[
                              NeoButton(
                                backgroundColor: NeoColors.cardBg,
                                onPressed: () {
                                  // TODO: Abrir enlace githubUrl
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.code,
                                      size: 18,
                                      color: NeoColors.border,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'GitHub',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: NeoColors.border,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    );

                    // Disposición responsive: En móvil se apila verticalmente, en Web desktop lado a lado.
                    if (isMobileWidth || mockupWidget == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (mockupWidget != null) ...[
                            Center(child: mockupWidget),
                            const SizedBox(height: 20),
                          ],
                          detailsWidget,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 240, child: mockupWidget),
                        const SizedBox(width: 24),
                        Expanded(child: detailsWidget),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
