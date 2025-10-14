import 'package:flutter/material.dart';
import 'models/submission.dart';

class SentPage extends StatelessWidget {
  const SentPage({super.key});

  List<Submission> get submissions => [
    Submission(
      id: '1',
      nombre: 'A - Suma de Pares',
      estado: SubmissionStatus.aprobado,
      fecha: DateTime.now().subtract(const Duration(minutes: 10)),
      puntaje: 100,
      lenguaje: 'Python',
    ),
    Submission(
      id: '2',
      nombre: 'B - Números Primos',
      estado: SubmissionStatus.rechazado,
      fecha: DateTime.now().subtract(const Duration(minutes: 30)),
      puntaje: 0,
      lenguaje: 'C++',
    ),
    Submission(
      id: '3',
      nombre: 'C - Ordenar Lista',
      estado: SubmissionStatus.pendiente,
      fecha: DateTime.now().subtract(const Duration(hours: 1)),
      puntaje: 0,
      lenguaje: 'Java',
    ),
    Submission(
      id: '4',
      nombre: 'D - Palíndromos',
      estado: SubmissionStatus.aprobado,
      fecha: DateTime.now().subtract(const Duration(hours: 2)),
      puntaje: 80,
      lenguaje: 'Python',
    ),
    Submission(
      id: '5',
      nombre: 'E - Caminos Mínimos',
      estado: SubmissionStatus.rechazado,
      fecha: DateTime.now().subtract(const Duration(hours: 3)),
      puntaje: 0,
      lenguaje: 'C++',
    ),
    Submission(
      id: '6',
      nombre: 'F - Anagramas',
      estado: SubmissionStatus.aprobado,
      fecha: DateTime.now().subtract(const Duration(hours: 4)),
      puntaje: 90,
      lenguaje: 'Java',
    ),
    Submission(
      id: '7',
      nombre: 'G - Árboles Binarios',
      estado: SubmissionStatus.pendiente,
      fecha: DateTime.now().subtract(const Duration(hours: 5)),
      puntaje: 0,
      lenguaje: 'Python',
    ),
    Submission(
      id: '8',
      nombre: 'H - Subcadenas',
      estado: SubmissionStatus.rechazado,
      fecha: DateTime.now().subtract(const Duration(hours: 6)),
      puntaje: 0,
      lenguaje: 'C++',
    ),
    Submission(
      id: '9',
      nombre: 'I - Matrices',
      estado: SubmissionStatus.aprobado,
      fecha: DateTime.now().subtract(const Duration(hours: 7)),
      puntaje: 70,
      lenguaje: 'Python',
    ),
    Submission(
      id: '10',
      nombre: 'J - Recursión',
      estado: SubmissionStatus.pendiente,
      fecha: DateTime.now().subtract(const Duration(hours: 8)),
      puntaje: 0,
      lenguaje: 'Java',
    ),
  ];

  Color statusColor(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.aprobado:
        return Colors.greenAccent.shade400;
      case SubmissionStatus.rechazado:
        return Colors.redAccent.shade200;
      case SubmissionStatus.pendiente:
        return Colors.amberAccent.shade700;
    }
  }

  IconData statusIcon(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.aprobado:
        return Icons.check_circle;
      case SubmissionStatus.rechazado:
        return Icons.cancel;
      case SubmissionStatus.pendiente:
        return Icons.hourglass_top;
    }
  }

  String statusText(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.aprobado:
        return 'Aprobado';
      case SubmissionStatus.rechazado:
        return 'Rechazado';
      case SubmissionStatus.pendiente:
        return 'Pendiente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicios enviados')),
      backgroundColor: Colors.black,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: submissions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final s = submissions[i];
          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: Icon(statusIcon(s.estado), color: statusColor(s.estado), size: 32),
              title: Text(s.nombre, style: const TextStyle(color: Colors.white)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lenguaje: ${s.lenguaje}', style: const TextStyle(color: Colors.white70)),
                  Text('Fecha: ${s.fecha.toLocal().toString().substring(0, 16)}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(statusText(s.estado), style: TextStyle(color: statusColor(s.estado), fontWeight: FontWeight.bold)),
                  if (s.puntaje > 0)
                    Text('+${s.puntaje}', style: TextStyle(color: Colors.greenAccent.shade400, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
