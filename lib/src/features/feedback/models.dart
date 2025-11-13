import 'dart:convert';

enum TipoRetro { ia, juez }

class Retroalimentacion {
  final int id;
  final int envioId;
  final TipoRetro tipo;
  final String comentario; // texto plano con viñetas
  final DateTime fecha;

  Retroalimentacion({
    required this.id,
    required this.envioId,
    required this.tipo,
    required this.comentario,
    required this.fecha,
  });

  factory Retroalimentacion.fromJson(Map<String, dynamic> j) {
    return Retroalimentacion(
      id: j['id'] as int,
      envioId: j['envioId'] as int,
      tipo: j['tipo'] == 'ia' ? TipoRetro.ia : TipoRetro.juez,
      comentario: j['comentario'] as String? ?? '',
      fecha: DateTime.parse(j['fecha'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'envioId': envioId,
        'tipo': tipo == TipoRetro.ia ? 'ia' : 'juez',
        'comentario': comentario,
        'fecha': fecha.toIso8601String(),
      };
}

class FeedbackItem {
  final int envioId;
  final int problemaId;
  final String problemaTitulo;
  final String comentario; // Resumen IA en viñetas

  FeedbackItem({
    required this.envioId,
    required this.problemaId,
    required this.problemaTitulo,
    required this.comentario,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> j) => FeedbackItem(
        envioId: j['envioId'] as int,
        problemaId: j['problemaId'] as int,
        problemaTitulo: j['problemaTitulo'] as String? ?? '',
        comentario: j['comentario'] as String? ?? '',
      );
}

class ResumenMaraton {
  final int equipoId;
  final int maratonId;
  final int totalProblemas;
  final int totalEnvios;
  final int aceptados;
  final double porcentajeAceptados;
  final int intentosFallidos;
  final List<FeedbackItem> recientes;

  ResumenMaraton({
    required this.equipoId,
    required this.maratonId,
    required this.totalProblemas,
    required this.totalEnvios,
    required this.aceptados,
    required this.porcentajeAceptados,
    required this.intentosFallidos,
    required this.recientes,
  });

  factory ResumenMaraton.fromJson(Map<String, dynamic> j) => ResumenMaraton(
        equipoId: j['equipoId'] as int,
        maratonId: j['maratonId'] as int,
        totalProblemas: j['totalProblemas'] as int,
        totalEnvios: j['totalEnvios'] as int,
        aceptados: j['aceptados'] as int,
        porcentajeAceptados: (j['porcentajeAceptados'] as num).toDouble(),
        intentosFallidos: j['intentosFallidos'] as int,
        recientes: (j['recientesFeedback'] as List? ?? [])
            .map((e) => FeedbackItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class ChatTurn {
  final int id;
  final String mensajeUsuario;
  final String respuestaIA; // viñetas en texto plano
  final DateTime fecha;

  ChatTurn({
    required this.id,
    required this.mensajeUsuario,
    required this.respuestaIA,
    required this.fecha,
  });

  factory ChatTurn.fromJson(Map<String, dynamic> j) => ChatTurn(
        id: j['id'] as int,
        mensajeUsuario: j['mensajeUsuario'] as String? ?? '',
        respuestaIA: j['respuestaIA'] as String? ?? '',
        fecha: DateTime.parse(j['fecha'] as String),
      );
}

/// Utilidad para parsear texto con viñetas en secciones.
/// Devuelve un mapa con claves: resumen, diagnostico, sugerencias, proximo.
Map<String, List<String>> parseBulletSections(String comentario) {
  final lines = const LineSplitter().convert(comentario.trim());
  String? currentKey;
  final Map<String, List<String>> result = {
    'resumen': [],
    'diagnostico': [],
    'sugerencias': [],
    'proximo': [],
    'otros': [],
  };

  final headerReg = RegExp(r'^-\s+(Resumen|Diagnóstico|Sugerencias|Próximo paso):?', caseSensitive: false);
  for (final raw in lines) {
    final line = raw.trim();
    final m = headerReg.firstMatch(line);
    if (m != null) {
      final section = m.group(1)!.toLowerCase();
      if (section.startsWith('resumen')) currentKey = 'resumen';
      else if (section.startsWith('diagn')) currentKey = 'diagnostico';
      else if (section.startsWith('suger')) currentKey = 'sugerencias';
      else if (section.startsWith('próximo') || section.startsWith('proximo')) currentKey = 'proximo';
      // remover el encabezado para contenido posterior
      final content = line.replaceFirst(headerReg, '').trim();
      if (content.isNotEmpty) {
        result[currentKey]!.add(content);
      }
      continue;
    }
    // Bullets internos "*" o "-" dentro de sección
  final bullet = line.replaceFirst(RegExp(r'^\s*[-*]\s*'), '').trim();
    if (currentKey != null && bullet.isNotEmpty) {
      result[currentKey]!.add(bullet);
    } else if (bullet.isNotEmpty) {
      result['otros']!.add(bullet);
    }
  }
  return result;
}
