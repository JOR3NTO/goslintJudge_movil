import 'package:flutter/material.dart';

class SentPage extends StatelessWidget {
  const SentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicios enviados')),
      body: const Center(child: Text('Listado de ejercicios enviados (placeholder)')),
    );
  }
}
