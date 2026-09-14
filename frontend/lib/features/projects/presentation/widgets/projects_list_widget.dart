import 'package:flutter/material.dart';

import '../../data/datasources/project_remote_datasource.dart';
import '../../data/models/project_model.dart';

class ProjectsListWidget extends StatefulWidget {
  const ProjectsListWidget({super.key});

  @override
  State<ProjectsListWidget> createState() => _ProjectsListWidgetState();
}

class _ProjectsListWidgetState extends State<ProjectsListWidget> {
  final ProjectRemoteDataSource _dataSource = ProjectRemoteDataSource();
  late Future<List<ProjectModel>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _dataSource.getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProjectModel>>(
      future: _projectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Error al conectar con la API: ${snapshot.error}'),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay proyectos registrados.'));
        }

        final projects = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(project.description),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      children: project.technologies.map((tech) {
                        return Chip(
                          label: Text(tech),
                          backgroundColor: Colors.deepPurple.shade50,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
