import 'package:flutter_test/flutter_test.dart';
import 'package:goslint_movile/src/features/feedback/models.dart';

void main() {
  test('parseBulletSections basic', () {
    const texto = '- Resumen: fallo por borde\n- Diagnóstico:\n  * Caso extremo no validado\n- Sugerencias:\n  * Verificar límites\n  * Optimizar E/S\n- Próximo paso: reescribir función';
    final m = parseBulletSections(texto);
    expect(m['resumen'], isNotEmpty);
    expect(m['diagnostico'], contains('Caso extremo no validado'));
    expect(m['sugerencias']!.length, 2);
    expect(m['proximo']!.first.contains('reescribir'), true);
  });
}
