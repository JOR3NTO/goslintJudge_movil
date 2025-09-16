import 'package:flutter/material.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
  home: const JudgeHomePage(),
    );
  }
}


// Nueva pantalla principal para el panel del juez/participante
class JudgeHomePage extends StatelessWidget {
  const JudgeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo
    final String participant = 'Juan Pérez';
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
            Text('Participante: $participant', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.emoji_events, color: Colors.amber),
                title: const Text('Puntaje'),
                trailing: Text('$score'),
                children: [
                  ListTile(
                    title: const Text('Ranking actual:'),
                    subtitle: const Text('5to lugar general'),
                  ),
                  ListTile(
                    title: const Text('Puntos por problema:'),
                    subtitle: const Text('A: 50, B: 40, C: 30'),
                  ),
                ],
              ),
            ),
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.send, color: Colors.blue),
                title: const Text('Envíos'),
                trailing: Text('$submissions'),
                children: [
                  ListTile(
                    title: const Text('A - 12:01pm'),
                    subtitle: const Text('Accepted'),
                  ),
                  ListTile(
                    title: const Text('B - 12:10pm'),
                    subtitle: const Text('Wrong Answer'),
                  ),
                  ListTile(
                    title: const Text('C - 12:20pm'),
                    subtitle: const Text('Time Limit Exceeded'),
                  ),
                ],
              ),
            ),
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Aceptados'),
                trailing: Text('$accepted'),
                children: [
                  ListTile(
                    title: const Text('A'),
                    subtitle: const Text('12:01pm'),
                  ),
                  ListTile(
                    title: const Text('C'),
                    subtitle: const Text('12:25pm'),
                  ),
                ],
              ),
            ),
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Rechazados'),
                trailing: Text('$rejected'),
                children: [
                  ListTile(
                    title: const Text('B'),
                    subtitle: const Text('Wrong Answer - 12:10pm'),
                  ),
                  ListTile(
                    title: const Text('C'),
                    subtitle: const Text('Time Limit Exceeded - 12:20pm'),
                  ),
                  ListTile(
                    title: const Text('C'),
                    subtitle: const Text('Runtime Error - 12:22pm'),
                  ),
                ],
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
