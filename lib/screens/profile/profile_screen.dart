import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../users/users_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _baseUrl = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _baseUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    if (!_seeded) {
      _baseUrl.text = app.baseUrl;
      _seeded = true;
    }

    final user = app.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (user != null) ...[
            Text('Phone: ${user.phoneNumber}'),
            Text('Role: ${user.role}'),
            const SizedBox(height: 16),
          ],
          TextField(
            controller: _baseUrl,
            decoration: const InputDecoration(
              labelText: 'API base URL',
              helperText: 'Example: http://127.0.0.1:8000',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await context.read<AppState>().setBaseUrl(_baseUrl.text);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Base URL saved')));
            },
            child: const Text('Save API URL'),
          ),
          const SizedBox(height: 16),
          if (app.isManagerOrAdmin)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UsersScreen()));
              },
              child: const Text('Manage users'),
            ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              await context.read<AppState>().logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
