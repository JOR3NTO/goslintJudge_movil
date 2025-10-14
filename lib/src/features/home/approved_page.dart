import 'package:flutter/material.dart';

class ApprovedPage extends StatelessWidget {
  const ApprovedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicios aprobados')),
      body: const Center(child: Text('Listado de ejercicios aprobados (placeholder)')),
    );
  }
}
