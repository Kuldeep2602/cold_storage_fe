import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import 'temperature_monitoring_screen.dart';

class TechnicianMenuScreen extends StatelessWidget {
  const TechnicianMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Directly show temperature monitoring screen
    return const TemperatureMonitoringScreen();
  }
}
