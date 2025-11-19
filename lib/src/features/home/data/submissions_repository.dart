import '../models/submission.dart';

/// Fuente central de ejercicios enviados. En futuro se reemplaza con llamadas HTTP.
class SubmissionsRepository {
  static final SubmissionsRepository _instance = SubmissionsRepository._internal();
  factory SubmissionsRepository() => _instance;
  SubmissionsRepository._internal();

  final List<Submission> _all = [
    Submission(id: '1', nombre: 'A - Suma de Pares', estado: SubmissionStatus.aprobado, fecha: DateTime.now().subtract(const Duration(minutes: 10)), puntaje: 100, lenguaje: 'Python'),
    Submission(id: '2', nombre: 'B - Números Primos', estado: SubmissionStatus.rechazado, fecha: DateTime.now().subtract(const Duration(minutes: 30)), puntaje: 0, lenguaje: 'C++'),
    Submission(id: '3', nombre: 'C - Ordenar Lista', estado: SubmissionStatus.pendiente, fecha: DateTime.now().subtract(const Duration(hours: 1)), puntaje: 0, lenguaje: 'Java'),
    Submission(id: '4', nombre: 'D - Palíndromos', estado: SubmissionStatus.aprobado, fecha: DateTime.now().subtract(const Duration(hours: 2)), puntaje: 80, lenguaje: 'Python'),
    Submission(id: '5', nombre: 'E - Caminos Mínimos', estado: SubmissionStatus.rechazado, fecha: DateTime.now().subtract(const Duration(hours: 3)), puntaje: 0, lenguaje: 'C++'),
    Submission(id: '6', nombre: 'F - Anagramas', estado: SubmissionStatus.aprobado, fecha: DateTime.now().subtract(const Duration(hours: 4)), puntaje: 90, lenguaje: 'Java'),
    Submission(id: '7', nombre: 'G - Árboles Binarios', estado: SubmissionStatus.pendiente, fecha: DateTime.now().subtract(const Duration(hours: 5)), puntaje: 0, lenguaje: 'Python'),
    Submission(id: '8', nombre: 'H - Subcadenas', estado: SubmissionStatus.rechazado, fecha: DateTime.now().subtract(const Duration(hours: 6)), puntaje: 0, lenguaje: 'C++'),
    Submission(id: '9', nombre: 'I - Matrices', estado: SubmissionStatus.aprobado, fecha: DateTime.now().subtract(const Duration(hours: 7)), puntaje: 70, lenguaje: 'Python'),
    Submission(id: '10', nombre: 'J - Recursión', estado: SubmissionStatus.pendiente, fecha: DateTime.now().subtract(const Duration(hours: 8)), puntaje: 0, lenguaje: 'Java'),
  ];

  List<Submission> all() => List.unmodifiable(_all);
  List<Submission> byStatus(SubmissionStatus s) => _all.where((e) => e.estado == s).toList();
}
