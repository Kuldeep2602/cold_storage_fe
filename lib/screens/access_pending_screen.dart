import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class AccessPendingScreen extends StatelessWidget {
  const AccessPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final user = app.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Pending'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => app.logout(),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_empty, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              Text(
                'Access Pending',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Your account has been created but you don\'t have access yet.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Please contact your administrator to:'),
                      const SizedBox(height: 8),
                      const Text('• Assign you a role (Operator/Manager)'),
                      const Text('• Activate your account'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (user != null) ...[
                Text('Phone: ${user.phoneNumber}'),
                Text('Status: ${user.isActive ? "Active" : "Inactive"}'),
                Text('Role: ${user.role ?? "Not Assigned"}'),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  // Refresh user data to check if role was assigned
                  try {
                    await app.logout();
                  } catch (_) {}
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Logout & Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
