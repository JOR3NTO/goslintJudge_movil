import 'package:flutter/material.dart';
import '../../shared/services/judge_service.dart';
import '../../core/backend_ids.dart';
import '../../core/theme_controller.dart';
import '../../features/chat/backend_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _judge = JudgeService(baseUrl: baseUrl); // reutilizamos baseUrl del BackendApi
  bool _loadingStats = true;
  String? _errorStats;
  int _sent = 0, _approved = 0, _rejected = 0, _score = 0;

  @override
  void initState() {
    super.initState();
    _cargarStats();
  }

  Future<void> _cargarStats() async {
    setState(() { _loadingStats = true; _errorStats = null; });
    try {
      // Placeholder: hasta que haya userId real usamos 'demo'.
      const userId = 'demo';
      final sent = await _judge.getSentExercises(userId);
      final approved = await _judge.getApprovedExercises(userId);
      final rejected = await _judge.getRejectedExercises(userId);
      final score = await _judge.getScore(userId);
      if (mounted) {
        setState(() { _sent = sent; _approved = approved; _rejected = rejected; _score = score; });
      }
    } catch (e) {
      setState(() { _errorStats = 'No se pudieron cargar estadísticas'; });
    } finally {
      if (mounted) setState(() { _loadingStats = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF6C63FF);
    final cardColor = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.15);
    final iconSize = 30.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Principal'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _loadingStats ? null : _cargarStats,
            icon: _loadingStats ? const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2)) : const Icon(Icons.refresh),
          )
        ],
      ),
      drawer: _buildDrawer(context, accentColor),
      body: RefreshIndicator(
        onRefresh: _cargarStats,
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final isWide = constraints.maxWidth > 600;
            final crossAxisCount = isWide ? 3 : 2;
            final items = [
              _InfoCardData(Icons.send, 'Enviados', _sent.toString(), () => Navigator.pushNamed(context, '/sent')),
              _InfoCardData(Icons.check_circle, 'Aprobados', _approved.toString(), () => Navigator.pushNamed(context, '/approved')),
              _InfoCardData(Icons.cancel, 'Rechazados', _rejected.toString(), () => Navigator.pushNamed(context, '/rejected')),
              _InfoCardData(Icons.emoji_events, 'Puntaje', _score.toString(), () => Navigator.pushNamed(context, '/score')),
              _InfoCardData(Icons.psychology, 'Retro IA', '', () => Navigator.pushNamed(context, '/retro', arguments: {'envioId': 1})),
              _InfoCardData(Icons.chat, 'Coach IA', '', () => Navigator.pushNamed(context, '/coach', arguments: {'maratonId': 1, 'equipoId': 1})),
            ];
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/logo_goslint.png', height: 60),
                            const SizedBox(width: 12),
                            Text('Bienvenido', style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_errorStats != null)
                          MaterialBanner(
                            content: Text(_errorStats!),
                            actions: [TextButton(onPressed: _cargarStats, child: const Text('Reintentar'))],
                          ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (c, i) {
                        final data = items[i];
                        return _InfoCard(
                          icon: data.icon,
                          label: data.label,
                          value: _loadingStats && data.value.isNotEmpty ? '...' : data.value,
                          color: accentColor,
                          cardColor: cardColor,
                          iconSize: iconSize,
                          onTap: data.onTap,
                        );
                      },
                      childCount: items.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, Color accentColor) {
    final ids = BackendIdsScope.of(context);
    final themeCtl = ThemeControllerScope.of(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo_goslint.png', height: 56),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Goslint Judge', style: Theme.of(context).textTheme.titleMedium),
                      Text(ids.isReady ? 'Maratón: ${ids.maratonId}  Equipo: ${ids.equipoId}' : 'IDs no listos', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Panel'), onTap: () => Navigator.pop(context)),
          const Divider(),
          ListTile(leading: const Icon(Icons.send), title: const Text('Enviados'), onTap: () => Navigator.pushNamed(context, '/sent')),
          ListTile(leading: const Icon(Icons.check_circle), title: const Text('Aprobados'), onTap: () => Navigator.pushNamed(context, '/approved')),
          ListTile(leading: const Icon(Icons.cancel), title: const Text('Rechazados'), onTap: () => Navigator.pushNamed(context, '/rejected')),
          ListTile(leading: const Icon(Icons.emoji_events), title: const Text('Puntaje'), onTap: () => Navigator.pushNamed(context, '/score')),
          ListTile(leading: const Icon(Icons.psychology), title: const Text('Retro IA'), onTap: () => Navigator.pushNamed(context, '/retro', arguments: {'envioId': 1})),
          ListTile(leading: const Icon(Icons.chat), title: const Text('Coach IA'), onTap: () => Navigator.pushNamed(context, '/coach', arguments: {'maratonId': ids.maratonId ?? 1, 'equipoId': ids.equipoId ?? 1})),
          SwitchListTile(
            title: Text(themeCtl.isDark ? 'Tema oscuro' : 'Tema claro'),
            secondary: const Icon(Icons.brightness_6),
            value: themeCtl.isDark,
            onChanged: (_) => themeCtl.toggle(),
          ),
          const Spacer(),
          ListTile(leading: const Icon(Icons.logout), title: const Text('Cerrar sesión'), onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false)),
        ],
      ),
    );
  }
}

class _InfoCardData {
  final IconData icon; final String label; final String value; final VoidCallback onTap;
  _InfoCardData(this.icon, this.label, this.value, this.onTap);
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color? cardColor;
  final double iconSize;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.cardColor,
    this.iconSize = 32,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
    onTap: onTap,
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
