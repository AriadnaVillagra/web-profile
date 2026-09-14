import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';

class ProjectRemoteDataSource {
  static const String baseUrl = 'http://localhost:3000/api';
  final http.Client client;

  ProjectRemoteDataSource({http.Client? client}) 
      : client = client ?? http.Client();

  Future<List<ProjectModel>> getProjects() async {
    final response = await http.get(
      Uri.parse('$baseUrl/projects'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar los proyectos desde la API');
    }
  }
}