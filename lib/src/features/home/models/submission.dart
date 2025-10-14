enum SubmissionStatus { aprobado, rechazado, pendiente }

class Submission {
  final String id;
  final String nombre;
  final SubmissionStatus estado;
  final DateTime fecha;
  final int puntaje;
  final String lenguaje;

  Submission({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.fecha,
    required this.puntaje,
    required this.lenguaje,
  });
}
