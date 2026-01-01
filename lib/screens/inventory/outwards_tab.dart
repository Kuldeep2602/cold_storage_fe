import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/outward_entry.dart';
import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_loading.dart';

class OutwardsTab extends StatefulWidget {
  const OutwardsTab({super.key});

  @override
  State<OutwardsTab> createState() => _OutwardsTabState();
}

class _OutwardsTabState extends State<OutwardsTab> {
  Future<List<OutwardEntry>>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final app = context.read<AppState>();
    _future = app.inventory.listOutwards().then((data) {
      final list = (data as List).cast<dynamic>();
      return list
          .map((e) => OutwardEntry.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    });
    setState(() {});
  }

  Future<void> _create() async {
    final app = context.read<AppState>();

    List<Map<String, dynamic>> stock = const [];
    try {
      final stockJson = await app.inventory.fetchStock();
      stock = (stockJson as List).map((e) => (e as Map).cast<String, dynamic>()).toList();
    } catch (_) {}

    if (!mounted) return;
    if (stock.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No remaining stock. Add inwards first.')),
      );
      return;
    }

    int inwardEntryId = (stock.first['id'] as num).toInt();
    final qty = TextEditingController();
    String packagingType = (stock.first['packaging_type'] as String?) ?? 'bori';
    String paymentMethod = '';

    Future<void> submit(BuildContext ctx) async {
      try {
        final res = await app.inventory.createOutwardEntry(
          inwardEntryId: inwardEntryId,
          quantity: qty.text.trim(),
          packagingType: packagingType,
          paymentMethod: paymentMethod,
        );

        final outwardId = (res['id'] as num?)?.toInt();
        if (!ctx.mounted) return;
        Navigator.pop(ctx);
        _reload();

        if (outwardId != null) {
          await _showReceipt(outwardId);
        }
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
                  const Text('Create Outward', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: inwardEntryId,
                    items: stock
                        .map(
                          (s) => DropdownMenuItem<int>(
                            value: (s['id'] as num).toInt(),
                            child: Text(
                              'Inward #${s['id']} • ${s['crop_name']} • remaining ${s['remaining_quantity']}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      final selected = stock.firstWhere((e) => (e['id'] as num).toInt() == v);
                      setSheetState(() {
                        inwardEntryId = v;
                        packagingType = (selected['packaging_type'] as String?) ?? packagingType;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Inward entry', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: qty,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: packagingType,
                    items: const [
                      DropdownMenuItem(value: 'bori', child: Text('Bori')),
                      DropdownMenuItem(value: 'crate', child: Text('Crate')),
                      DropdownMenuItem(value: 'box', child: Text('Box')),
                    ],
                    onChanged: (v) => setSheetState(() => packagingType = v ?? packagingType),
                    decoration: const InputDecoration(labelText: 'Packaging type', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: paymentMethod.isEmpty ? null : paymentMethod,
                    items: const [
                      DropdownMenuItem(value: 'cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'upi', child: Text('UPI')),
                      DropdownMenuItem(value: 'bank_transfer', child: Text('Bank transfer')),
                      DropdownMenuItem(value: 'card', child: Text('Card')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (v) => setSheetState(() => paymentMethod = v ?? ''),
                    decoration: const InputDecoration(labelText: 'Payment method (optional)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () => submit(ctx), child: const Text('Create')),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    qty.dispose();
  }

  Future<void> _showReceipt(int outwardId) async {
    final app = context.read<AppState>();

    try {
      final receipt = await app.inventory.getReceipt(outwardId);
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Receipt'),
          content: Text(
            'Receipt: ${receipt['receipt_number']}\n'
            'Status: ${receipt['payment_status']}\n'
            'Method: ${receipt['payment_method'] ?? ''}\n'
            'Time: ${receipt['timestamp']}',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
            TextButton(
              onPressed: () async {
                try {
                  await app.inventory.triggerPayment(outwardId);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment triggered (mock)')),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Trigger payment'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: _create, child: const Icon(Icons.add)),
      body: FutureBuilder<List<OutwardEntry>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const AppLoadingView(label: 'Loading outwards...');
          }
          if (snap.hasError) {
            return AppErrorView(message: snap.error.toString(), onRetry: _reload);
          }
          final items = snap.data ?? const <OutwardEntry>[];
          if (items.isEmpty) return const Center(child: Text('No outwards yet.'));

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final it = items[i];
                return ListTile(
                  title: Text('${it.receiptNumber} • ${it.quantity} ${it.packagingType}'),
                  subtitle: Text('${it.paymentStatus} • ${it.paymentMethod} • ${fmtDateTime(it.createdAt)}'),
                  onTap: () => _showReceipt(it.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
