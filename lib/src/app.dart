import 'package:flutter/material.dart';

import 'features/home/home_shell.dart';

class DriverLedgerApp extends StatelessWidget {
  const DriverLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xff0b6e69),
      brightness: Brightness.light,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driver Ledger AU',
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff6f8f7),
        cardTheme: const CardThemeData(margin: EdgeInsets.zero),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const HomeShell(),
    );
  }
}
