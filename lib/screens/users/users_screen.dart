import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_loading.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Future<List<Map<String, dynamic>>>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final app = context.read<AppState>();
    _future = app.users.listUsers().then((data) {
      // Handle paginated response
      List list;
      if (data is Map && data.containsKey('results')) {
        list = data['results'] as List;
      } else {
        list = data as List;
      }
      return list.map((e) => (e as Map).cast<String, dynamic>()).toList();
    });
    setState(() {});
  }

  Future<void> _create() async {
    final phone = TextEditingController();
    String role = 'operator';
    bool isActive = true;

    final app = context.read<AppState>();

    Future<void> submit(BuildContext ctx) async {
      try {
        await app.users.createUser(phoneNumber: phone.text.trim(), role: role, isActive: isActive);
        if (!ctx.mounted) return;
        Navigator.pop(ctx);
        _reload();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User created')));
      } on ApiException catch (e) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(e.toString())));
      } catch (e) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomInset + 16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text('Create User', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone number', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: role,
                    items: const [
                      DropdownMenuItem(value: 'operator', child: Text('Operator')),
                      DropdownMenuItem(value: 'manager', child: Text('Manager')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    ],
                    onChanged: (v) => setSheetState(() => role = v ?? 'operator'),
                    decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: isActive,
                    onChanged: (v) => setSheetState(() => isActive = v),
                    title: const Text('Active'),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => submit(ctx), child: const Text('Create'))),
                ],
              ),
            );
          },
        );
      },
    );

    phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      floatingActionButton: FloatingActionButton(onPressed: _create, child: const Icon(Icons.add)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const AppLoadingView(label: 'Loading users...');
          }
          if (snap.hasError) {
            return AppErrorView(message: snap.error.toString(), onRetry: _reload);
          }

          final items = snap.data ?? const <Map<String, dynamic>>[];
          if (items.isEmpty) return const Center(child: Text('No users.'));

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final it = items[i];
                return ListTile(
                  title: Text((it['phone_number'] as String?) ?? ''),
                  subtitle: Text('${it['role']} • active: ${it['is_active']}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
