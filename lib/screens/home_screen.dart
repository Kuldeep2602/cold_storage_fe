import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inventory/inventory_screen.dart';
import 'ledger/ledger_screen.dart';
import 'manager/manager_menu_screen.dart';
import 'operator/operator_menu_screen.dart';
import 'payments/payments_screen.dart';
import 'profile/profile_screen.dart';
import 'technician/technician_menu_screen.dart';
import 'temperature/temperature_screen.dart';
import '../state/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    
    // Route to role-specific screens
    if (appState.user?.isOperator ?? false) {
      return const OperatorMenuScreen();
    }
    
    if (appState.user?.isTechnician ?? false) {
      return const TechnicianMenuScreen();
    }
    
    if (appState.user?.isManager ?? false) {
      return const ManagerMenuScreen();
    }
    
    // Owner and Admin get full navigation
    final screens = <Widget>[
      const InventoryScreen(),
      const TemperatureScreen(),
      const LedgerScreen(),
      const PaymentsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.thermostat), label: 'Temp'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Ledger'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
