import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_loading.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  Future<List<Map<String, dynamic>>>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final app = context.read<AppState>();
    _future = app.payments.listRequests().then((data) {
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

  Future<void> _open(int id) async {
    final app = context.read<AppState>();
    try {
      final data = await app.payments.getRequest(id);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Payment Request #$id'),
          content: SingleChildScrollView(
            child: Text(data.toString()),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const AppLoadingView(label: 'Loading payment requests...');
          }
          if (snap.hasError) {
            return AppErrorView(message: snap.error.toString(), onRetry: _reload);
          }

          final items = snap.data ?? const <Map<String, dynamic>>[];
          if (!app.isManagerOrAdmin) {
            return const Center(child: Text('Payments are manager/admin only.'));
          }
          if (items.isEmpty) return const Center(child: Text('No payment requests yet.'));

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final it = items[i];
                final id = (it['id'] as num).toInt();
                final outward = it['outward_entry'];
                final status = it['status'];
                final method = it['method'];
                final createdAt = DateTime.tryParse((it['created_at'] as String?) ?? '');
                return ListTile(
                  title: Text('Outward: $outward • $status'),
                  subtitle: Text('${method ?? ''}${createdAt == null ? '' : ' • ${fmtDateTime(createdAt)}'}'),
                  onTap: () => _open(id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
