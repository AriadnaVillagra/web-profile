import 'package:flutter/material.dart';

import 'features/projects/presentation/widgets/projects_list_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Profile Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Portafolio - Clean Architecture'),
          elevation: 2,
        ),
        body: const ProjectsListWidget(),
      ),
    );
  }
}
