import 'package:flutter/material.dart';
import 'models/submission.dart';
import 'data/submissions_repository.dart';

class ApprovedPage extends StatelessWidget {
  const ApprovedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = SubmissionsRepository();
    final aprobados = repo.byStatus(SubmissionStatus.aprobado);
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicios aprobados')),
      body: aprobados.isEmpty
          ? const Center(child: Text('No hay ejercicios aprobados'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: aprobados.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final s = aprobados[i];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(s.nombre),
                    subtitle: Text('Lenguaje: ${s.lenguaje}\nFecha: ${s.fecha.toLocal().toString().substring(0,16)}'),
                    trailing: Text('+${s.puntaje}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () => Navigator.pushNamed(context, '/retro', arguments: {'envioId': int.tryParse(s.id) ?? 0}),
                  ),
                );
              },
            ),
    );
  }
}
