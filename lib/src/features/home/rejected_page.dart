import 'package:flutter/material.dart';
import 'models/submission.dart';
import 'data/submissions_repository.dart';

class RejectedPage extends StatelessWidget {
  const RejectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = SubmissionsRepository();
    final rechazados = repo.byStatus(SubmissionStatus.rechazado);
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicios rechazados')),
      body: rechazados.isEmpty
          ? const Center(child: Text('No hay ejercicios rechazados'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rechazados.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final s = rechazados[i];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.cancel, color: Colors.redAccent),
                    title: Text(s.nombre),
                    subtitle: Text('Lenguaje: ${s.lenguaje}\nFecha: ${s.fecha.toLocal().toString().substring(0,16)}'),
                    trailing: const Text('Rechazado', style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () => Navigator.pushNamed(context, '/retro', arguments: {'envioId': int.tryParse(s.id) ?? 0}),
                  ),
                );
              },
            ),
    );
  }
}
