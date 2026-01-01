import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/person.dart';
import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_loading.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  DateTime? _from;
  DateTime? _to;
  int? _personId;
  final _crop = TextEditingController();

  List<Person> _persons = const [];
  Future<Map<String, dynamic>>? _future;

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
      _persons = (personsJson as List)
          .map((e) => Person.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } catch (_) {
      _persons = const [];
    }
    _reload();
  }

  void _reload() {
    final app = context.read<AppState>();
    _future = app.ledger.fetchLedger(
      dateFrom: _from,
      dateTo: _to,
      personId: _personId,
      crop: _crop.text.trim(),
    );
    setState(() {});
  }

  Future<void> _pickFrom() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: _from ?? DateTime.now(),
    );
    if (d == null) return;
    setState(() => _from = DateTime(d.year, d.month, d.day));
  }

  Future<void> _pickTo() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: _to ?? DateTime.now(),
    );
    if (d == null) return;
    setState(() => _to = DateTime(d.year, d.month, d.day, 23, 59, 59));
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ledger')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickFrom,
                        child: Text(_from == null ? 'From' : 'From: ${fmtDateTime(_from!)}'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickTo,
                        child: Text(_to == null ? 'To' : 'To: ${fmtDateTime(_to!)}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  value: _personId,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All persons')),
                    ..._persons.map((p) => DropdownMenuItem(value: p.id, child: Text('${p.name} (${p.mobileNumber})'))),
                  ],
                  onChanged: (v) => setState(() => _personId = v),
                  decoration: const InputDecoration(labelText: 'Person', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _crop,
                  decoration: const InputDecoration(labelText: 'Crop (optional)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: _reload, child: const Text('Fetch ledger')),
                ),
                if (!app.isManagerOrAdmin)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Ledger is manager/admin only.'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const AppLoadingView(label: 'Loading ledger...');
                }
                if (snap.hasError) {
                  return AppErrorView(message: snap.error.toString(), onRetry: _reload);
                }

                final data = snap.data ?? const <String, dynamic>{};
                final totals = (data['totals'] as Map?)?.cast<String, dynamic>() ?? const {};
                final entries = (data['entries'] as List?)?.cast<dynamic>() ?? const [];

                return RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        title: const Text('Totals'),
                        subtitle: Text(
                          'Inward: ${totals['inward_quantity_total'] ?? 0}\n'
                          'Outward: ${totals['outward_quantity_total'] ?? 0}\n'
                          'Net: ${totals['net_quantity'] ?? 0}',
                        ),
                      ),
                      const Divider(height: 1),
                      ...entries.map((e) {
                        final m = (e as Map).cast<String, dynamic>();
                        final type = (m['type'] as String?) ?? '';
                        final crop = (m['crop_name'] as String?) ?? '';
                        final qty = m['quantity'];
                        final person = (m['person'] as Map?)?.cast<String, dynamic>() ?? const {};
                        final name = (person['name'] as String?) ?? '';
                        final ts = DateTime.tryParse((m['timestamp'] as String?) ?? '');
                        final receipt = m['receipt_number'];
                        final payStatus = m['payment_status'];
                        return ListTile(
                          title: Text('${type.toUpperCase()} • $crop • $qty'),
                          subtitle: Text(
                            '$name'
                            '${receipt == null ? '' : '\nReceipt: $receipt'}'
                            '${payStatus == null ? '' : '\nPayment: $payStatus'}'
                            '${ts == null ? '' : '\n${fmtDateTime(ts)}'}',
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
