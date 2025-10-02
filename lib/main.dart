import 'package:flutter/material.dart';
import 'screens/retroalimentacion_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const JudgeHomePage(),
    );
  }
}

// Nueva pantalla principal para el panel del juez/participante
class JudgeHomePage extends StatefulWidget {
  const JudgeHomePage({super.key});

  @override
  State<JudgeHomePage> createState() => _JudgeHomePageState();
}

class _JudgeHomePageState extends State<JudgeHomePage> {
  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo
    final String usuarios = 'Goslint Team';
    final int score = 120;
    final int submissions = 5;
    final int accepted = 2;
    final int rejected = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Participante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/Logo Goslint Black.png',
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text('Equipo: $usuarios',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            // Acordeón: al abrir una sección, las demás se cierran automáticamente
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              child: ExpansionPanelList.radio(
                expandedHeaderPadding: EdgeInsets.zero,
                elevation: 0,
                children: [
                  ExpansionPanelRadio(
                    value: 'puntaje',
                    headerBuilder: (context, isExpanded) => ListTile(
                      leading:
                          const Icon(Icons.emoji_events, color: Colors.amber),
                      title: const Text('Puntaje'),
                      trailing: Text('$score'),
                    ),
                    body: const Column(
                      children: [
                        ListTile(
                          title: Text('Ranking actual:'),
                          subtitle: Text('5to lugar general'),
                        ),
                        ListTile(
                          title: Text('Puntos por problema:'),
                          subtitle: Text('A: 50, B: 40, C: 30'),
                        ),
                      ],
                    ),
                    canTapOnHeader: true,
                  ),
                  ExpansionPanelRadio(
                    value: 'envios',
                    headerBuilder: (context, isExpanded) => ListTile(
                      leading: const Icon(Icons.send, color: Colors.blue),
                      title: const Text('Envíos'),
                      trailing: Text('$submissions'),
                    ),
                    body: const Column(
                      children: [
                        ListTile(
                          title: Text('A - 12:01pm'),
                          subtitle: Text('Accepted'),
                        ),
                        ListTile(
                          title: Text('B - 12:10pm'),
                          subtitle: Text('Wrong Answer'),
                        ),
                        ListTile(
                          title: Text('C - 12:20pm'),
                          subtitle: Text('Time Limit Exceeded'),
                        ),
                      ],
                    ),
                    canTapOnHeader: true,
                  ),
                  ExpansionPanelRadio(
                    value: 'aceptados',
                    headerBuilder: (context, isExpanded) => ListTile(
                      leading:
                          const Icon(Icons.check_circle, color: Colors.green),
                      title: const Text('Aceptados'),
                      trailing: Text('$accepted'),
                    ),
                    body: const Column(
                      children: [
                        ListTile(
                          title: Text('A'),
                          subtitle: Text('12:01pm'),
                        ),
                        ListTile(
                          title: Text('C'),
                          subtitle: Text('12:25pm'),
                        ),
                      ],
                    ),
                    canTapOnHeader: true,
                  ),
                  ExpansionPanelRadio(
                    value: 'rechazados',
                    headerBuilder: (context, isExpanded) => ListTile(
                      leading: const Icon(Icons.cancel, color: Colors.red),
                      title: const Text('Rechazados'),
                      trailing: Text('$rejected'),
                    ),
                    body: const Column(
                      children: [
                        ListTile(
                          title: Text('B'),
                          subtitle: Text('Wrong Answer - 12:10pm'),
                        ),
                        ListTile(
                          title: Text('C'),
                          subtitle: Text('Time Limit Exceeded - 12:20pm'),
                        ),
                        ListTile(
                          title: Text('C'),
                          subtitle: Text('Runtime Error - 12:22pm'),
                        ),
                      ],
                    ),
                    canTapOnHeader: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RetroalimentacionPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Retroalimentación'),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
