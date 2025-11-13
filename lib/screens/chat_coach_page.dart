import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../src/features/feedback/models.dart';
import '../src/features/chat/backend_api.dart';
import '../src/core/backend_ids.dart';

class ChatCoachPage extends StatefulWidget {
  final int maratonId;
  final int equipoId;
  const ChatCoachPage({super.key, required this.maratonId, required this.equipoId});

  @override
  State<ChatCoachPage> createState() => _ChatCoachPageState();
}

class _ChatCoachPageState extends State<ChatCoachPage> {
  final _api = BackendApi();
  final _controller = TextEditingController();
  final List<ChatTurn> _turnos = [];
  bool _cargando = false;
  bool _inicializando = true; // mientras se hace seed / carga inicial
  String? _error;
  bool _enviando = false;
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration.zero); // asegurar contexto
    final ids = BackendIdsScope.of(context);
    if (!ids.isReady) {
      try {
        final (maratonId, equipoId) = await _api.ensureSeed();
        ids.setIds(maraton: maratonId, equipo: equipoId);
      } catch (e) {
        setState(() { _error = 'Seed error: $e'; _inicializando = false; });
        return;
      }
    }
    if (ids.isReady) {
      await _cargarHistorial();
    }
    if (mounted) setState(() { _inicializando = false; });
  }

  Future<void> _cargarHistorial() async {
    setState(() { _cargando = true; _error = null; });
    try {
      final ids = BackendIdsScope.of(context);
      if (!ids.isReady) throw BackendException('IDs no inicializados');
      final h = await _api.fetchChatHistory(ids.maratonId!, ids.equipoId!);
      setState(() { _turnos
        ..clear()
        ..addAll(h); });
    } catch (e) {
      setState(() { _error = 'No se pudo cargar historial: $e'; });
    } finally {
      if (mounted) setState(() { _cargando = false; });
    }
  }

  Future<void> _enviar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    setState(() { _enviando = true; _error = null; });
    try {
      final ids = BackendIdsScope.of(context);
      if (!ids.isReady) throw BackendException('IDs no inicializados');
      final turno = await _api.sendChatMessage(ids.maratonId!, ids.equipoId!, texto);
      if (mounted) {
        setState(() {
          _turnos.add(turno);
          _controller.clear();
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scroll.hasClients) {
            _scroll.animateTo(
              _scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      String msg;
      if (e.toString().contains('SocketException')) {
        msg = 'No se puede conectar al servidor';
      } else if (e.toString().contains('Timeout')) {
        msg = 'El servidor no respondió, reintenta';
      } else if (e.toString().contains('no inicializados')) {
        msg = 'IDs no listos, intenta recargar';
      } else if (e.toString().contains('404')) {
        msg = 'IDs inválidos (maratón/equipo)';
      } else if (e.toString().contains('500') || e.toString().contains('interno')) {
        msg = 'Error interno del servidor';
      } else {
        msg = 'Error: $e';
      }
      setState(() { _error = msg; });
    } finally {
      setState(() { _enviando = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coach IA')),
      body: Column(
        children: [
          if (_error != null)
            MaterialBanner(
              content: Text(_error!),
              actions: [
                TextButton(onPressed: () => setState(() => _error = null), child: const Text('Cerrar')),
                if (!_inicializando)
                  TextButton(
                    onPressed: () {
                      setState(() { _error = null; _inicializando = true; });
                      _init();
                    },
                    child: const Text('Reintentar'),
                  ),
                if (_error != null && _error!.contains('ingrese manualmente'))
                  TextButton(
                    onPressed: _mostrarDialogoManual,
                    child: const Text('Configurar IDs'),
                  ),
              ],
            ),
          Expanded(
            child: (_inicializando)
                ? const Center(child: CircularProgressIndicator())
                : _cargando && _turnos.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _cargarHistorial,
                    child: ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.all(16),
                      itemCount: _turnos.length,
                      itemBuilder: (c, i) {
                        final t = _turnos[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ChatBubble(isAi: false, text: t.mensajeUsuario),
                              const SizedBox(height: 6),
                              _IaResponseBubble(text: t.respuestaIA),
                            ],
                          ),
                        );
                      },
                    ),
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
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Escribe tu pregunta…',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      onSubmitted: (_) => _enviar(),
                      enabled: !_enviando,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: (_enviando || _inicializando) ? null : _enviar,
                    icon: const Icon(Icons.send),
                    label: _enviando ? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2)) : const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoManual() {
    final maratonCtrl = TextEditingController();
    final equipoCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('IDs manuales'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: maratonCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Maratón ID'),
            ),
            TextField(
              controller: equipoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Equipo ID'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final m = int.tryParse(maratonCtrl.text.trim());
              final e = int.tryParse(equipoCtrl.text.trim());
              if (m != null && e != null) {
                final ids = BackendIdsScope.of(context);
                ids.setIds(maraton: m, equipo: e);
                setState(() { _error = null; _inicializando = false; });
                Navigator.pop(ctx);
                _cargarHistorial();
              }
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }
}

class _IaResponseBubble extends StatelessWidget {
  final String text;
  const _IaResponseBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(
                    child: Text(
                      l.replaceFirst(RegExp(r'^[-*]\s*'), ''),
                      style: TextStyle(
                        fontWeight: (l.startsWith('- Resumen') || l.startsWith('- Próximo') || l.startsWith('- Proximo'))
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
