import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_loading.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  Future<List<Map<String, dynamic>>>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final app = context.read<AppState>();
    _future = app.temperature.listLogs().then((data) {
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

  Future<DateTime?> _pickDateTime(DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: initial,
    );
    if (date == null) return null;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initial));
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _create() async {
    final app = context.read<AppState>();

    DateTime loggedAt = DateTime.now();
    final temperature = TextEditingController();

    Future<void> submit(BuildContext ctx) async {
      try {
        await app.temperature.createLog(loggedAt: loggedAt, temperature: temperature.text.trim());
        if (!ctx.mounted) return;
        Navigator.pop(ctx);
        _reload();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Temperature logged')));
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
                  const Text('Log Temperature', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await _pickDateTime(loggedAt);
                      if (picked == null) return;
                      setSheetState(() => loggedAt = picked);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text('Logged at: ${fmtDateTime(loggedAt)}'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: temperature,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Temperature', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () => submit(ctx), child: const Text('Save')),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    temperature.dispose();
  }

  Future<void> _edit(Map<String, dynamic> item) async {
    final app = context.read<AppState>();
    if (!app.isManagerOrAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Only manager/admin can edit logs')));
      return;
    }

    final id = (item['id'] as num).toInt();
    DateTime loggedAt = DateTime.tryParse((item['logged_at'] as String?) ?? '') ?? DateTime.now();
    final temperature = TextEditingController(text: (item['temperature'] ?? '').toString());

    Future<void> submit(BuildContext ctx) async {
      try {
        await app.temperature.updateLog(id: id, loggedAt: loggedAt, temperature: temperature.text.trim());
        if (!ctx.mounted) return;
        Navigator.pop(ctx);
        _reload();
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
                  const Text('Edit Temperature Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await _pickDateTime(loggedAt);
                      if (picked == null) return;
                      setSheetState(() => loggedAt = picked);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text('Logged at: ${fmtDateTime(loggedAt)}'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: temperature,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Temperature', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () => submit(ctx), child: const Text('Update')),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    temperature.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature')),
      floatingActionButton: FloatingActionButton(onPressed: _create, child: const Icon(Icons.add)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const AppLoadingView(label: 'Loading logs...');
          }
          if (snap.hasError) {
            return AppErrorView(message: snap.error.toString(), onRetry: _reload);
          }
          final items = snap.data ?? const <Map<String, dynamic>>[];
          if (items.isEmpty) return const Center(child: Text('No logs yet.'));

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final it = items[i];
                final loggedAt = DateTime.tryParse((it['logged_at'] as String?) ?? '');
                final temp = it['temperature'];
                return ListTile(
                  title: Text('Temp: $temp'),
                  subtitle: Text(loggedAt == null ? '' : fmtDateTime(loggedAt)),
                  onTap: () => _edit(it),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
