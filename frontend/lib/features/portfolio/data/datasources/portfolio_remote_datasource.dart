import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/portfolio_model.dart';

class PortfolioRemoteDataSource {
  // Apuntamos a la ruta completa del recurso portfolio
  static const String baseUrl = 'http://localhost:3001/api/portfolio';
  final http.Client client;

  PortfolioRemoteDataSource({http.Client? client})
    : client = client ?? http.Client();

  Future<List<PortfolioModel>> getProjects() async {
    final response = await client.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => PortfolioModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar los proyectos desde la API');
    }
  }
}
