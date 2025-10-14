import 'package:flutter/material.dart';
// import '../../shared/services/judge_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF6C63FF);
    final cardColor = Colors.grey[900];
    final iconSize = 32.0;
    // Valores de ejemplo
    final sent = 12;
    final approved = 8;
    final rejected = 4;
    final score = 120;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Panel Principal', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[850],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey[900]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/logo_goslint.png', height: 48),
                  const SizedBox(height: 8),
                  const Text('Goslint Judge', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.send, color: Colors.white),
              title: const Text('Ejercicios enviados', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pushNamed('/sent'),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.white),
              title: const Text('Aprobados', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pushNamed('/approved'),
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.white),
              title: const Text('Rechazados', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pushNamed('/rejected'),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.white),
              title: const Text('Puntaje', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pushNamed('/score'),
            ),
            ListTile(
              leading: const Icon(Icons.psychology, color: Colors.white),
              title: const Text('Retroalimentación IA', style: TextStyle(color: Colors.white)),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente: IA'))),
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_goslint.png', height: 80),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/sent'),
                    child: _InfoCard(
                      icon: Icons.send,
                      label: 'Ejercicios enviados',
                      value: sent.toString(),
                      color: accentColor,
                      cardColor: cardColor,
                      iconSize: iconSize,
                    ),
                  ),
                  _InfoCard(
                    icon: Icons.check_circle,
                    label: 'Aprobados',
                    value: approved.toString(),
                    color: Colors.greenAccent.shade400,
                    cardColor: cardColor,
                    iconSize: iconSize,
                  ),
                  _InfoCard(
                    icon: Icons.cancel,
                    label: 'Rechazados',
                    value: rejected.toString(),
                    color: Colors.redAccent.shade200,
                    cardColor: cardColor,
                    iconSize: iconSize,
                  ),
                  _InfoCard(
                    icon: Icons.emoji_events,
                    label: 'Puntaje',
                    value: score.toString(),
                    color: Colors.amber,
                    cardColor: cardColor,
                    iconSize: iconSize,
                  ),
                  _InfoCard(
                    icon: Icons.psychology,
                    label: 'Ver retroalimentación IA',
                    value: '',
                    color: accentColor,
                    cardColor: cardColor,
                    iconSize: iconSize,
                    isButton: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color? cardColor;
  final double iconSize;
  final bool isButton;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.cardColor,
    this.iconSize = 32,
    this.isButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isButton
            ? () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente: retroalimentación IA')),)
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: iconSize),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              if (value.isNotEmpty)
                Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
