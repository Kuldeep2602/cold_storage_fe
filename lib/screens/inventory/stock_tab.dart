import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/person.dart';
import '../../state/app_state.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_loading.dart';

class StockTab extends StatefulWidget {
  const StockTab({super.key});

  @override
  State<StockTab> createState() => _StockTabState();
}

class _StockTabState extends State<StockTab> {
  Future<List<dynamic>>? _future;
  List<Person> _persons = const [];

  int? _personId;
  final _crop = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _crop.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final app = context.read<AppState>();
    try {
      final personsJson = await app.inventory.listPersons();
      final list = (personsJson as List).cast<dynamic>();
      _persons = list.map((e) => Person.fromJson((e as Map).cast<String, dynamic>())).toList();
    } catch (_) {
      _persons = const [];
    }

    _reload();
  }

  void _reload() {
    final app = context.read<AppState>();
    _future = app.inventory.fetchStock(personId: _personId, cropName: _crop.text.trim()).then((data) {
      return (data as List).cast<dynamic>();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              DropdownButtonFormField<int?>(
                value: _personId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All persons')),
                  ..._persons.map(
                    (p) => DropdownMenuItem(value: p.id, child: Text('${p.name} (${p.mobileNumber})')),
                  ),
                ],
                onChanged: (v) => setState(() => _personId = v),
                decoration: const InputDecoration(labelText: 'Person', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _crop,
                      decoration: const InputDecoration(
                        labelText: 'Crop (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: _reload, child: const Text('Apply')),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const AppLoadingView(label: 'Loading stock...');
              }
              if (snap.hasError) {
                return AppErrorView(message: snap.error.toString(), onRetry: _reload);
              }
              final items = snap.data ?? const [];
              if (items.isEmpty) return const Center(child: Text('No remaining stock.'));

              return RefreshIndicator(
                onRefresh: () async => _reload(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final m = (items[i] as Map).cast<String, dynamic>();
                    final id = m['id'];
                    final crop = m['crop_name'];
                    final variety = (m['crop_variety'] ?? '').toString();
                    final pkg = m['packaging_type'];
                    final rem = m['remaining_quantity'];
                    final qty = m['quantity'];
                    return ListTile(
                      title: Text('$crop${variety.isEmpty ? '' : ' • $variety'}'),
                      subtitle: Text('Inward #$id • $pkg • remaining: $rem / $qty'),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
