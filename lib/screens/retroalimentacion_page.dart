import 'package:flutter/material.dart';
import '../src/features/feedback/models.dart';
import '../src/features/chat/backend_api.dart';

class RetroalimentacionPage extends StatefulWidget {
  final int envioId;
  const RetroalimentacionPage({super.key, required this.envioId});

  @override
  State<RetroalimentacionPage> createState() => _RetroalimentacionPageState();
}

class _RetroalimentacionPageState extends State<RetroalimentacionPage> {
  final _api = BackendApi();
  String? _retroTexto;
  bool _generando = false;
  String? _error;
  List<Retroalimentacion> _historial = [];
  bool _cargandoHistorial = false;
  bool _cargandoUltima = false; // podría usarse para mostrar spinner específico si se desea

  Future<void> _generar() async {
    setState(() { _generando = true; _error = null; });
    try {
      final txt = await _api.generarRetroIA(widget.envioId);
      setState(() { _retroTexto = txt; });
      await _cargarHistorial();
    } catch (e) {
      setState(() { _error = _mapError(e); });
    } finally {
      setState(() { _generando = false; });
    }
  }

  Future<void> _cargarUltima() async {
    setState(() { _cargandoUltima = true; _error = null; });
    try {
      final txt = await _api.ultimaRetroIA(widget.envioId);
      setState(() { _retroTexto = txt; });
    } catch (e) {
      setState(() { _error = _mapError(e); });
    } finally {
      setState(() { _cargandoUltima = false; });
    }
  }

  Future<void> _cargarHistorial() async {
    setState(() { _cargandoHistorial = true; _error = null; });
    try {
      final list = await _api.listarRetroalimentaciones(widget.envioId);
      setState(() { _historial = list; });
    } catch (e) {
      setState(() { _error = _mapError(e); });
    } finally {
      setState(() { _cargandoHistorial = false; });
    }
  }

  String _mapError(Object e) {
    final s = e.toString();
    if (s.contains('SocketException')) return 'No se puede conectar al servidor';
    if (s.contains('Timeout')) return 'Servidor no responde, intenta de nuevo';
    if (s.contains('404')) return 'Retro/Historial no encontrado';
    if (s.contains('500') || s.contains('interno')) return 'Error interno del servidor';
    return 'Error: $s';
  }

  @override
  void initState() {
    super.initState();
    _cargarUltima();
    _cargarHistorial();
  }

  @override
  Widget build(BuildContext context) {
  final parsed = _retroTexto != null ? parseIaSections(_retroTexto!) : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Retroalimentación IA')),
      body: Column(
        children: [
          if (_error != null)
            MaterialBanner(
              content: Text(_error!),
              actions: [
                TextButton(onPressed: () => setState(() => _error = null), child: const Text('Cerrar')),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generando ? null : _generar,
                    icon: const Icon(Icons.auto_fix_high),
                    label: _generando
                        ? const SizedBox(height:16,width:16,child:CircularProgressIndicator(strokeWidth:2))
                        : const Text('Generar Retro IA'),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: 'Refrescar historial',
                  onPressed: _cargandoHistorial ? null : _cargarHistorial,
                  icon: _cargandoHistorial
                      ? const SizedBox(height:20,width:20,child:CircularProgressIndicator(strokeWidth:2))
                      : const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                if (parsed != null) ...[
                  const Text('Última retroalimentación', style: TextStyle(fontSize:16,fontWeight:FontWeight.bold)),
                  const SizedBox(height:8),
                  if (parsed['resumen']!.isNotEmpty)
                    _SectionWidget(title: 'Resumen', items: parsed['resumen']!),
                  if (parsed['diagnostico']!.isNotEmpty)
                    _SectionWidget(title: 'Diagnóstico', items: parsed['diagnostico']!),
                  if (parsed['sugerencias']!.isNotEmpty)
                    _SectionWidget(title: 'Sugerencias', items: parsed['sugerencias']!),
                  if (parsed['proximo']!.isNotEmpty)
                    _SectionWidget(title: 'Próximo paso', items: parsed['proximo']!),
                  const Divider(height:32),
                ],
                Text('Historial (${_historial.length})', style: const TextStyle(fontSize:16,fontWeight:FontWeight.bold)),
                const SizedBox(height:8),
                if (_historial.isEmpty && !_cargandoHistorial)
                  const Text('No hay retroalimentaciones aún.'),
                for (final r in _historial.reversed)
                  Card(
                    margin: const EdgeInsets.only(bottom:12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('#${r.id} • ${r.tipo == TipoRetro.ia ? 'IA' : 'Juez'}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height:6),
                          Text(r.comentario),
                          const SizedBox(height:6),
                          Text(r.fecha.toLocal().toString(),
                              style: TextStyle(color: Colors.grey.shade600,fontSize:12)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height:24),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/coach', arguments: {'envioId': widget.envioId});
                  },
                  child: const Text('Abrir Coach IA (Chat)'),
                ),
                const SizedBox(height:24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final String title;
  final List<String> items;
  const _SectionWidget({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height:4),
          for (final i in items)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(i)),
              ],
            ),
        ],
      ),
    );
  }
}

