import 'package:flutter/material.dart';
import 'features/login/login_page.dart';
import 'features/home/home_page.dart';
import 'features/home/welcome_page.dart';
import 'features/home/sent_page.dart';
import 'features/home/approved_page.dart';
import 'features/home/rejected_page.dart';
import 'features/home/score_page.dart';
import '../screens/retroalimentacion_page.dart';
import '../screens/chat_coach_page.dart';
import '../screens/resumen_maraton_page.dart';
import 'core/backend_ids.dart';

class GoslintApp extends StatelessWidget {
  const GoslintApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = BackendIds();
    return BackendIdsScope(
      ids: ids,
      child: MaterialApp(
      title: 'Goslint Judge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/welcome': (context) => const WelcomePage(),
        '/panel': (context) => const HomePage(),
        '/sent': (context) => const SentPage(),
        '/approved': (context) => const ApprovedPage(),
        '/rejected': (context) => const RejectedPage(),
        '/score': (context) => const ScorePage(),
        '/retro': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final envioId = args != null ? (args['envioId'] as int? ?? 0) : 0;
          return RetroalimentacionPage(envioId: envioId);
        },
        '/coach': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final maratonId = args != null ? (args['maratonId'] as int? ?? 0) : 0;
          final equipoId = args != null ? (args['equipoId'] as int? ?? 0) : 0;
          return ChatCoachPage(maratonId: maratonId, equipoId: equipoId);
        },
        '/resumen': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final maratonId = args != null ? (args['maratonId'] as int? ?? 0) : 0;
          final equipoId = args != null ? (args['equipoId'] as int? ?? 0) : 0;
          return ResumenMaratonPage(maratonId: maratonId, equipoId: equipoId);
        },
      },
      ),
    );
  }
}
