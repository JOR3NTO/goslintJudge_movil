import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../feedback/models.dart'; // ChatTurn, ResumenMaraton, FeedbackItem, Retroalimentacion

// BASE_URL: cambiar aquí si se mueve el backend.
// Base URL central del backend (actualizado a ngrok HTTPS)
const String baseUrl = 'https://unopressible-elia-wispily.ngrok-free.dev';

class BackendException implements Exception {
  final String message;
  final int? statusCode;
  BackendException(this.message, {this.statusCode});
  @override
  String toString() => 'BackendException($statusCode): $message';
}

class BackendApi {
  BackendApi({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  /// Obtiene (maratonId, equipoId). Intenta en orden:
  /// 1. Cache local
  /// 2. GET maratones/equipos (con un retry corto)
  /// 3. POST seed/full y luego reintenta GET
  /// Si seed falla, aún intenta un último GET antes de rendirse.
  Future<(int maratonId, int equipoId)> ensureSeed() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedMaraton = prefs.getInt('maratonId');
    final cachedEquipo = prefs.getInt('equipoId');
    if (cachedMaraton != null && cachedEquipo != null) {
      _log('CACHE', 'Usando IDs cacheados m=$cachedMaraton e=$cachedEquipo');
      return (cachedMaraton, cachedEquipo);
    }

    Future<int?> leerMaraton() async {
      try {
        final res = await _safeGet(Uri.parse('$baseUrl/api/maratones'), retry: 1);
        if (_isOk(res.statusCode)) {
          final list = jsonDecode(res.body) as List;
          if (list.isNotEmpty) {
            return (list.first as Map<String, dynamic>)['id'] as int;
          }
        }
      } catch (_) {}
      return null;
    }

    Future<int?> leerEquipo() async {
      try {
        final res = await _safeGet(Uri.parse('$baseUrl/api/equipos'), retry: 1);
        if (_isOk(res.statusCode)) {
          final list = jsonDecode(res.body) as List;
          if (list.isNotEmpty) {
            return (list.first as Map<String, dynamic>)['id'] as int;
          }
        }
      } catch (_) {}
      return null;
    }

    var maratonId = await leerMaraton();
    var equipoId = await leerEquipo();
    if (maratonId != null && equipoId != null) {
      await prefs.setInt('maratonId', maratonId);
      await prefs.setInt('equipoId', equipoId);
      return (maratonId, equipoId);
    }

    // Intentar seed
    _log('SEED', 'Intentando /api/admin/seed/full');
    http.Response? seedRes;
    try {
      seedRes = await _safePost(Uri.parse('$baseUrl/api/admin/seed/full'));
    } catch (e) {
      _log('SEED_ERR', e.toString());
    }
    if (seedRes != null && _isOk(seedRes.statusCode)) {
      try {
        final data = jsonDecode(seedRes.body) as Map<String, dynamic>;
        maratonId = data['maratonId'] as int?;
        equipoId = data['equipoId'] as int?;
      } catch (e) {
        _log('SEED_PARSE', e.toString());
      }
      if (maratonId != null && equipoId != null) {
        await prefs.setInt('maratonId', maratonId);
        await prefs.setInt('equipoId', equipoId);
        return (maratonId, equipoId);
      }
    }

    // Relectura final por si el backend ya tenía datos aunque seed falle.
    maratonId ??= await leerMaraton();
    equipoId ??= await leerEquipo();
    if (maratonId != null && equipoId != null) {
      await prefs.setInt('maratonId', maratonId);
      await prefs.setInt('equipoId', equipoId);
      return (maratonId, equipoId);
    }

    throw BackendException('No fue posible obtener IDs (maratón/equipo). Verifique backend o ingrese manualmente.');
  }

  Future<List<ChatTurn>> fetchChatHistory(int maratonId, int equipoId) async {
    final uri = Uri.parse('$baseUrl/api/chat/maraton/$maratonId/equipo/$equipoId');
    final res = await _safeGet(uri, retry: 1); // 1 retry para historial
    _throwIfHttpError(res, notFoundMsg: 'ID no encontrado');
    final data = jsonDecode(res.body) as List;
    return data.map((e) => ChatTurn.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ChatTurn> sendChatMessage(int maratonId, int equipoId, String mensaje) async {
    // Algunos despliegues requieren GET con query ?mensaje=... en lugar de POST con body.
    final getUri = Uri.parse('$baseUrl/api/chat/maraton/$maratonId/equipo/$equipoId')
        .replace(queryParameters: {'mensaje': mensaje});
    try {
      final getRes = await _safeGet(getUri);
      if (_isOk(getRes.statusCode)) {
        final data = jsonDecode(getRes.body) as Map<String, dynamic>;
        return ChatTurn.fromJson(data);
      }
    } catch (_) {
      // Ignorar y probar POST
    }
    final postUri = Uri.parse('$baseUrl/api/chat/maraton/$maratonId/equipo/$equipoId');
    final res = await _safePost(postUri, body: {'mensaje': mensaje});
    _throwIfHttpError(res, notFoundMsg: 'ID no encontrado');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return ChatTurn.fromJson(data);
  }

  Future<ResumenMaraton> fetchResumen(int equipoId, int maratonId) async {
    final uri = Uri.parse('$baseUrl/api/resumen/equipos/$equipoId/maratones/$maratonId');
    final res = await _safeGet(uri);
    _throwIfHttpError(res, notFoundMsg: 'Resumen no encontrado');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return ResumenMaraton.fromJson(data);
  }

  Future<String> ultimaRetroIA(int envioId) async {
    final uri = Uri.parse('$baseUrl/api/retroalimentacion/ia/ultimo/$envioId');
    final res = await _safeGet(uri);
    _throwIfHttpError(res, notFoundMsg: 'Retro IA no encontrada');
    return res.body; // texto plano
  }

  Future<String> generarRetroIA(int envioId) async {
    final uri = Uri.parse('$baseUrl/api/retroalimentacion/ia/$envioId');
    final res = await _safePost(uri);
    _throwIfHttpError(res, notFoundMsg: 'No se pudo generar retro IA');
    return res.body; // texto plano
  }

  Future<List<Retroalimentacion>> listarRetroalimentaciones(int envioId) async {
    final uri = Uri.parse('$baseUrl/api/retroalimentaciones/envio/$envioId');
    final res = await _safeGet(uri);
    _throwIfHttpError(res, notFoundMsg: 'Historial vacío');
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Retroalimentacion.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ---- Helpers HTTP ----
  bool _isOk(int code) => code >= 200 && code < 300;

  void _throwIfHttpError(http.Response res, {String? notFoundMsg}) {
    if (res.statusCode == 404) {
      throw BackendException(notFoundMsg ?? 'ID no encontrado', statusCode: 404);
    }
    if (res.statusCode >= 500) {
      throw BackendException('Error interno', statusCode: res.statusCode);
    }
    if (!_isOk(res.statusCode)) {
      throw BackendException('Error HTTP ${res.statusCode}', statusCode: res.statusCode);
    }
  }

  Future<http.Response> _safeGet(Uri uri, {int retry = 0}) async {
    int attempt = 0;
    while (true) {
      attempt++;
      try {
        _log('GET', uri.toString());
        final res = await _client.get(uri).timeout(const Duration(seconds: 10));
        _log('RES ${res.statusCode}', res.body);
        return res;
      } on TimeoutException {
        _log('TIMEOUT', uri.toString());
        if (attempt > retry) rethrow;
      } on SocketException {
        _log('SOCKET', uri.toString());
        if (attempt > retry) rethrow;
      }
    }
  }

  Future<http.Response> _safePost(Uri uri, {Map<String, dynamic>? body}) async {
    try {
      _log('POST', uri.toString());
      final res = await _client
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 10));
      _log('RES ${res.statusCode}', res.body);
      return res;
    } on TimeoutException {
      _log('TIMEOUT', uri.toString());
      throw BackendException('Timeout');
    } on SocketException {
      _log('SOCKET', uri.toString());
      throw BackendException('SocketException');
    }
  }

  void _log(String tag, String body) {
    final truncated = body.length > 300 ? body.substring(0, 300) + '…' : body;
    // ignore: avoid_print
    print('[BackendApi][$tag] $truncated');
  }
}

// ---- IA Text Parsing ----
/// Parsea texto plano de IA en secciones. Devuelve mapa con claves: resumen, diagnostico, sugerencias, proximo.
Map<String, List<String>> parseIaSections(String raw) {
  final lines = raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  String current = 'otros';
  final result = {
    'resumen': <String>[],
    'diagnostico': <String>[],
    'sugerencias': <String>[],
    'proximo': <String>[],
    'otros': <String>[],
  };
  final header = RegExp(r'^(Resumen|Diagnóstico|Sugerencias|Próximo paso|Proximo paso)[:]?$', caseSensitive: false);
  for (final l in lines) {
    final hl = l.replaceAll('-', '').trim();
    if (header.hasMatch(hl)) {
      final key = hl.toLowerCase();
      if (key.startsWith('resumen')) current = 'resumen';
      else if (key.startsWith('diagn')) current = 'diagnostico';
      else if (key.startsWith('suger')) current = 'sugerencias';
      else if (key.startsWith('próximo') || key.startsWith('proximo')) current = 'proximo';
      continue;
    }
    final cleaned = l.replaceFirst(RegExp(r'^[-*]\s*'), '').trim();
    result[current]!.add(cleaned);
  }
  return result;
}

