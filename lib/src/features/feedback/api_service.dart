import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _base = (baseUrl ?? 'http://149.130.167.81');

  final http.Client _client;
  final String _base;

  Uri _u(String path) => Uri.parse('$_base$path');

  Future<String> generarRetroalimentacionIA(int envioId) async {
    final res = await _client
        .post(_u('/api/retroalimentacion/ia/$envioId'))
        .timeout(const Duration(seconds: 10), onTimeout: () => http.Response('Timeout', 599));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.body; // texto plano con viñetas
    }
    throw Exception('Error ${res.statusCode} al generar retroalimentación');
  }

  Future<String> obtenerUltimaRetroalimentacionIA(int envioId) async {
    final res = await _client
        .get(_u('/api/retroalimentacion/ia/ultimo/$envioId'))
        .timeout(const Duration(seconds: 10), onTimeout: () => http.Response('Timeout', 599));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.body;
    }
    throw Exception('Error ${res.statusCode} al obtener última retroalimentación');
  }

  Future<List<Retroalimentacion>> listarRetroalimentaciones(int envioId) async {
    final res = await _client
        .get(_u('/api/retroalimentaciones/envio/$envioId'))
        .timeout(const Duration(seconds: 10), onTimeout: () => http.Response('Timeout', 599));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Retroalimentacion.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error ${res.statusCode} al listar retroalimentaciones');
  }

  Future<ResumenMaraton> obtenerResumenMaraton(int equipoId, int maratonId) async {
    final res = await _client
        .get(_u('/api/resumen/equipos/$equipoId/maratones/$maratonId'))
        .timeout(const Duration(seconds: 10), onTimeout: () => http.Response('Timeout', 599));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return ResumenMaraton.fromJson(data);
    }
    throw Exception('Error ${res.statusCode} al obtener resumen de maratón');
  }

  Future<ChatTurn> enviarMensajeChat(int maratonId, int equipoId, String mensaje) async {
    final res = await _client
        .post(
          _u('/api/chat/maraton/$maratonId/equipo/$equipoId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'mensaje': mensaje}),
        )
        .timeout(const Duration(seconds: 15), onTimeout: () => http.Response('Timeout', 599));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return ChatTurn.fromJson(data);
    }
    throw Exception('Error ${res.statusCode} al enviar mensaje');
  }

  Future<List<ChatTurn>> historialChat(int maratonId, int equipoId) async {
    final res = await _client
        .get(_u('/api/chat/maraton/$maratonId/equipo/$equipoId'))
        .timeout(const Duration(seconds: 10), onTimeout: () => http.Response('Timeout', 599));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => ChatTurn.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Error ${res.statusCode} al obtener historial de chat');
  }
}
