import 'package:flutter/material.dart';

class RejectedPage extends StatelessWidget {
  const RejectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicios rechazados')),
      body: const Center(child: Text('Listado de ejercicios rechazados (placeholder)')),
    );
  }
}
