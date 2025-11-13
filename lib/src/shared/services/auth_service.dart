import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {

  Future<dynamic> login({required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data; // Se espera que data contenga el nombre
      } catch (_) {
        return {'error': 'Login exitoso, pero error al leer respuesta'};
      }
    } else {
      try {
        final data = jsonDecode(response.body);
        return {'error': data['message'] ?? 'Error desconocido'};
      } catch (_) {
        return {'error': 'Error al iniciar sesión'};
      }
    }
  }
  final String baseUrl;
  AuthService({required this.baseUrl});

    Future<String?> register({required String nombre, required String emailContacto, required String password}) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'emailContacto': emailContacto,
        'password': password,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return null; // Registro exitoso
    } else {
      try {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Error desconocido';
      } catch (_) {
        return 'Error al registrar';
      }
    }
  }
}
