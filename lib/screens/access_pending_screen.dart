import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class AccessPendingScreen extends StatelessWidget {
  const AccessPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final user = app.user;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.accessPending ?? 'Access Pending'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => app.logout(),
            tooltip: l10n?.logout ?? 'Logout',
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
                l10n?.accessPending ?? 'Access Pending',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                l10n?.accountCreatedNoAccess ?? 'Your account has been created but you don\'t have access yet.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(l10n?.contactAdminTo ?? 'Please contact your administrator to:'),
                      const SizedBox(height: 8),
                      Text('• ${l10n?.assignRole ?? "Assign you a role (Operator/Manager)"}'),
                      Text('• ${l10n?.activateAccount ?? "Activate your account"}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (user != null) ...[
                Text('${l10n?.phone ?? "Phone"}: ${user.phoneNumber}'),
                Text('${l10n?.statusLabel ?? "Status"}: ${user.isActive ? (l10n?.active ?? "Active") : (l10n?.inactive ?? "Inactive")}'),
                Text('${l10n?.roleLabel ?? "Role"}: ${user.role ?? (l10n?.notAssigned ?? "Not Assigned")}'),
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
                label: Text(l10n?.logoutTryAgain ?? 'Logout & Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
