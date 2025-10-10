import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Principal'),
      ),
      body: const Center(
        child: Text('¡Bienvenido a Goslint Judge!', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
