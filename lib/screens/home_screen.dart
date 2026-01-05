import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inventory/inventory_screen.dart';
import 'ledger/ledger_screen.dart';
import 'manager/manager_dashboard_screen.dart';
import 'operator/operator_menu_screen.dart';
import 'owner/owner_dashboard_screen.dart';
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
    
    // Route based on user role
    final userRole = appState.user?.role;
    
    // Operators get operator menu
    if (userRole == 'operator') {
      return const OperatorMenuScreen();
    }
    
    // Technicians get technician menu
    if (userRole == 'technician') {
      return const TechnicianMenuScreen();
    }
    
    // Managers get manager dashboard
    if (userRole == 'manager') {
      return const ManagerDashboardScreen();
    }
    
    // Owners and Admins get owner dashboard (multi-cold-storage management)
    if (userRole == 'owner' || userRole == 'admin') {
      return const OwnerDashboardScreen();
    }
    
    // Fallback for users without specific roles - show basic navigation
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
