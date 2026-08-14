import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../import/import_screen.dart';
import '../settings/settings_screen.dart';
import '../tax/tax_screen.dart';
import '../transactions/transactions_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  var _index = 0;
  static const _screens = <Widget>[
    DashboardScreen(),
    TransactionsScreen(),
    ImportScreen(),
    TaxScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Ledger AU'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Chip(label: Text('LOCAL-FIRST')),
          ),
        ],
      ),
      body: SafeArea(child: IndexedStack(index: _index, children: _screens)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Overview'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Ledger'),
          NavigationDestination(icon: Icon(Icons.upload_file_outlined), label: 'Import'),
          NavigationDestination(icon: Icon(Icons.account_balance_outlined), label: 'Tax'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
