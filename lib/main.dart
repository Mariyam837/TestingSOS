import 'package:flutter/material.dart';

import 'screens/routine_activity_page.dart';
import 'widgets/portal_ui.dart';

void main() {
  runApp(const PortalAiApp());
}

class PortalAiApp extends StatelessWidget {
  const PortalAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PortalAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: PortalColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PortalColors.purple,
          surface: PortalColors.surface,
        ),
        fontFamily: 'Roboto',
      ),
      home: const RoutineActivityPage(),
    );
  }
}
