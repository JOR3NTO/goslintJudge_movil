import 'package:flutter/material.dart';
import 'models/submission.dart';
import 'data/submissions_repository.dart';

class SentPage extends StatelessWidget {
  const SentPage({super.key});

  List<Submission> get submissions => SubmissionsRepository().all();

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
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16,16,16,24),
        itemCount: submissions.length,
        itemBuilder: (context, i) {
          final s = submissions[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16,14,12,14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(statusIcon(s.estado), color: statusColor(s.estado), size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              const SizedBox(height:4),
                              Text('Lenguaje: ${s.lenguaje}', style: const TextStyle(color: Colors.white70)),
                              Text('Fecha: ${s.fecha.toLocal().toString().substring(0,16)}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(statusText(s.estado), style: TextStyle(color: statusColor(s.estado), fontWeight: FontWeight.bold)),
                            if (s.puntaje > 0)
                              Text('+${s.puntaje}', style: TextStyle(color: Colors.greenAccent.shade400, fontWeight: FontWeight.bold)),
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.more_vert, color: Colors.white70),
                              onSelected: (v) {
                                if (v == 'retro') {
                                  Navigator.of(context).pushNamed('/retro', arguments: {'envioId': int.tryParse(s.id) ?? 0});
                                } else if (v == 'coach') {
                                  Navigator.of(context).pushNamed('/coach', arguments: {'maratonId': 1, 'equipoId': 1});
                                }
                              },
                              itemBuilder: (c) => const [
                                PopupMenuItem(value: 'retro', child: Text('Retro IA')),
                                PopupMenuItem(value: 'coach', child: Text('Coach IA')),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
