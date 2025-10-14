import 'package:flutter/material.dart';
import 'features/login/login_page.dart';
import 'features/home/home_page.dart';
import 'features/home/welcome_page.dart';
import 'features/home/sent_page.dart';
import 'features/home/approved_page.dart';
import 'features/home/rejected_page.dart';
import 'features/home/score_page.dart';

class GoslintApp extends StatelessWidget {
  const GoslintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
