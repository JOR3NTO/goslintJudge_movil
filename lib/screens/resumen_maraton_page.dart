import 'package:flutter/material.dart';
import '../src/features/feedback/api_service.dart';
import '../src/features/feedback/models.dart';

class ResumenMaratonPage extends StatefulWidget {
  final int equipoId;
  final int maratonId;
  const ResumenMaratonPage({super.key, required this.equipoId, required this.maratonId});

  @override
  State<ResumenMaratonPage> createState() => _ResumenMaratonPageState();
}

class _ResumenMaratonPageState extends State<ResumenMaratonPage> {
  final _api = ApiService();
  ResumenMaraton? _resumen;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await _api.obtenerResumenMaraton(widget.equipoId, widget.maratonId);
      setState(() { _resumen = r; });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumen Maratón')),
      body: _loading && _resumen == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetch,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_error != null)
                    Card(color: Colors.red.shade50, child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(_error!, style: const TextStyle(color: Colors.red)),
                    )),
                  if (_resumen != null) ...[
                    Text('Equipo ${_resumen!.equipoId} • Maratón ${_resumen!.maratonId}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _StatTile(label: 'Problemas', value: _resumen!.totalProblemas.toString()),
                        _StatTile(label: 'Envíos', value: _resumen!.totalEnvios.toString()),
                        _StatTile(label: 'Aceptados', value: _resumen!.aceptados.toString()),
                        _StatTile(label: '% Aceptados', value: _resumen!.porcentajeAceptados.toStringAsFixed(1)),
                        _StatTile(label: 'Fallidos', value: _resumen!.intentosFallidos.toString()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Feedback Reciente', style: TextStyle(fontSize:16,fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    if (_resumen!.recientes.isEmpty) const Text('Sin feedback reciente.'),
                    for (final f in _resumen!.recientes)
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Envío ${f.envioId} • Problema ${f.problemaTitulo}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(f.comentario),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
