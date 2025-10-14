import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntaje')),
      body: const Center(child: Text('Detalle de puntaje (placeholder)')),
    );
  }
}
