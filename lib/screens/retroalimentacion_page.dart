import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';

class RetroalimentacionPage extends StatelessWidget {
  const RetroalimentacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retroalimentación'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Chat con IA (demo)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Aquí verás sugerencias y explicaciones para mejorar tu desempeño. '
                  'Puedes preguntar, por ejemplo:\n'
                  '• ¿Cómo mejorar mi estrategia para el problema B?\n'
                  '• ¿Qué significan mis errores más comunes?\n'
                  '• Dame recomendaciones para optimizar mis envíos.\n'
                  '• Explícame por qué falló el caso C a las 12:20pm.',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ChatBubble(
                  isAi: true,
                  text:
                      'Hola, soy tu asistente. Veo que tuviste 3 rechazos y 2 aceptados. '
                      'Te sugiero revisar los límites de tiempo del problema C y validar entradas. '
                      '¿Sobre qué problema quieres recomendaciones primero?',
                ),
                SizedBox(height: 12),
                ChatBubble(
                  isAi: false,
                  text: 'Quiero entender por qué falló el problema C.',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Escribe tu pregunta…',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      enabled: false, // Placeholder deshabilitado por ahora
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Próximamente: chat con IA'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
