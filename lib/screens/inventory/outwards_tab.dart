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
  List<OutwardEntry> _items = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _items = [];
        _error = null;
      });
    }

    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final app = context.read<AppState>();
      final data = await app.inventory.listOutwards(page: _currentPage);

      List<OutwardEntry> newItems = [];
      if (data is Map && data.containsKey('results')) {
        newItems = (data['results'] as List)
            .map((e) => OutwardEntry.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
        _hasMore = data['next'] != null;
      } else if (data is List) {
        newItems = data
            .map((e) => OutwardEntry.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
        _hasMore = false;
      }

      if (mounted) {
        setState(() {
          if (refresh) {
            _items = newItems;
          } else {
            _items.addAll(newItems);
          }
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    setState(() => _isLoadingMore = true);

    try {
      _currentPage++;
      final app = context.read<AppState>();
      final data = await app.inventory.listOutwards(page: _currentPage);

      List<OutwardEntry> newItems = [];
      if (data is Map && data.containsKey('results')) {
        newItems = (data['results'] as List)
            .map((e) => OutwardEntry.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
        _hasMore = data['next'] != null;
      }

      if (mounted) {
        setState(() {
          _items.addAll(newItems);
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _currentPage--;
        });
      }
    }
  }

  void _reload() {
    _loadData(refresh: true);
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _items.isEmpty) {
      return const AppLoadingView(label: 'Loading outwards...');
    }

    if (_error != null && _items.isEmpty) {
      return AppErrorView(message: _error!, onRetry: _reload);
    }

    if (_items.isEmpty) {
      return const Center(child: Text('No outwards yet.'));
    }

    return RefreshIndicator(
      onRefresh: () => _loadData(refresh: true),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _items.length + (_hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          if (i >= _items.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final it = _items[i];
          return ListTile(
            key: ValueKey(it.id),
            title: Text('${it.receiptNumber} • ${it.quantity} ${it.packagingType}'),
            subtitle: Text('${it.paymentStatus} • ${it.paymentMethod} • ${fmtDateTime(it.createdAt)}'),
            onTap: () => _showReceipt(it.id),
          );
        },
      ),
    );
  }
}
