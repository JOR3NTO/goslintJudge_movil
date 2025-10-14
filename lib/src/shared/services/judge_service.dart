import 'package:http/http.dart' as http;
import 'dart:convert';

class JudgeService {
  final String baseUrl;
  JudgeService({required this.baseUrl});

  Future<int> getSentExercises(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/judge/$userId/sent'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['count'] as int;
    }
    throw Exception('Error al obtener ejercicios enviados');
  }

  Future<int> getApprovedExercises(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/judge/$userId/approved'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['count'] as int;
    }
    throw Exception('Error al obtener ejercicios aprobados');
  }

  Future<int> getRejectedExercises(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/judge/$userId/rejected'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['count'] as int;
    }
    throw Exception('Error al obtener ejercicios rechazados');
  }

  Future<int> getScore(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/judge/$userId/score'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['score'] as int;
    }
    throw Exception('Error al obtener puntaje');
  }
}
