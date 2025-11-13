import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Holds IDs needed to call backend (maratón/equipo) and notifies listeners.
class BackendIds extends ChangeNotifier {
  int? maratonId;
  int? equipoId;

  bool get isReady => maratonId != null && equipoId != null;

  void setIds({required int maraton, required int equipo}) {
    maratonId = maraton;
    equipoId = equipo;
    notifyListeners();
  }
}

/// Simple inherited scope to access BackendIds without external packages.
class BackendIdsScope extends InheritedWidget {
  final BackendIds ids;
  const BackendIdsScope({super.key, required this.ids, required Widget child}) : super(child: child);

  static BackendIds of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<BackendIdsScope>();
    assert(scope != null, 'BackendIdsScope not found');
    return scope!.ids;
  }

  @override
  bool updateShouldNotify(covariant BackendIdsScope oldWidget) => oldWidget.ids != ids;
}
