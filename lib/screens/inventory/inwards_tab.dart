import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inward_entry.dart';
import '../../models/person.dart';
import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_loading.dart';

class InwardsTab extends StatefulWidget {
  const InwardsTab({super.key});

  @override
  State<InwardsTab> createState() => _InwardsTabState();
}

class _InwardsTabState extends State<InwardsTab> {
  List<InwardEntry> _items = [];
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
      final data = await app.inventory.listInwards(page: _currentPage);

      List<InwardEntry> newItems = [];
      if (data is Map && data.containsKey('results')) {
        // Paginated response
        newItems = (data['results'] as List)
            .map((e) => InwardEntry.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
        _hasMore = data['next'] != null;
      } else if (data is List) {
        // Non-paginated response (fallback)
        newItems = data
            .map((e) => InwardEntry.fromJson((e as Map).cast<String, dynamic>()))
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
      final data = await app.inventory.listInwards(page: _currentPage);

      List<InwardEntry> newItems = [];
      if (data is Map && data.containsKey('results')) {
        newItems = (data['results'] as List)
            .map((e) => InwardEntry.fromJson((e as Map).cast<String, dynamic>()))
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
          _currentPage--; // Revert page increment on error
        });
      }
    }
  }

  void _reload() {
    _loadData(refresh: true);
  }

  Future<void> _create() async {
    final app = context.read<AppState>();

    List<Person> persons = const [];
    try {
      final personsJson = await app.inventory.listPersons();
      persons = (personsJson as List)
          .map((e) => Person.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } catch (_) {}

    int? personId = persons.isNotEmpty ? persons.first.id : null;
    final cropName = TextEditingController();
    final cropVariety = TextEditingController();
    final sizeGrade = TextEditingController();
    final quantity = TextEditingController();
    String packagingType = 'bori';
    String qualityGrade = 'A';
    final rackNumber = TextEditingController();

    File? image;

    Future<void> submit(BuildContext ctx) async {
      if (personId == null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Create/select a person first.')),
        );
        return;
      }

      try {
        await app.inventory.createInwardEntry(
          personId: personId!,
          cropName: cropName.text.trim(),
          cropVariety: cropVariety.text.trim(),
          sizeGrade: sizeGrade.text.trim(),
          quantity: quantity.text.trim(),
          packagingType: packagingType,
          qualityGrade: qualityGrade,
          rackNumber: rackNumber.text.trim(),
          imageFile: image,
        );
        if (!ctx.mounted) return;
        Navigator.pop(ctx);
        _reload();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inward created')));
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
            Future<void> pick() async {
              final res = await FilePicker.platform.pickFiles(type: FileType.image);
              final path = res?.files.single.path;
              if (path == null) return;
              image = File(path);
              setSheetState(() {});
            }

            return Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomInset + 16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text('Create Inward', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    value: personId,
                    items: persons
                        .map((p) => DropdownMenuItem(value: p.id, child: Text('${p.name} (${p.mobileNumber})')))
                        .toList(),
                    onChanged: (v) => setSheetState(() => personId = v),
                    decoration: const InputDecoration(labelText: 'Person', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: cropName, decoration: const InputDecoration(labelText: 'Crop name')),
                  TextField(controller: cropVariety, decoration: const InputDecoration(labelText: 'Crop variety (optional)')),
                  TextField(controller: sizeGrade, decoration: const InputDecoration(labelText: 'Size grade (optional)')),
                  TextField(
                    controller: quantity,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: packagingType,
                    items: const [
                      DropdownMenuItem(value: 'bori', child: Text('Bori')),
                      DropdownMenuItem(value: 'crate', child: Text('Crate')),
                      DropdownMenuItem(value: 'box', child: Text('Box')),
                    ],
                    onChanged: (v) => setSheetState(() => packagingType = v ?? 'bori'),
                    decoration: const InputDecoration(labelText: 'Packaging type', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: qualityGrade,
                    items: const [
                      DropdownMenuItem(value: 'A', child: Text('Grade A')),
                      DropdownMenuItem(value: 'B', child: Text('Grade B')),
                      DropdownMenuItem(value: 'C', child: Text('Grade C')),
                    ],
                    onChanged: (v) => setSheetState(() => qualityGrade = v ?? 'A'),
                    decoration: const InputDecoration(labelText: 'Quality Grade', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: rackNumber, decoration: const InputDecoration(labelText: 'Rack number (optional)')),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: pick,
                    icon: const Icon(Icons.image),
                    label: Text(image == null ? 'Attach image (optional)' : 'Image selected'),
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

    cropName.dispose();
    cropVariety.dispose();
    sizeGrade.dispose();
    quantity.dispose();
    rackNumber.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: _create, child: const Icon(Icons.add)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Show loading on first load
    if (_isLoading && _items.isEmpty) {
      return const AppLoadingView(label: 'Loading inwards...');
    }

    // Show error on first load
    if (_error != null && _items.isEmpty) {
      return AppErrorView(message: _error!, onRetry: _reload);
    }

    // Show empty state
    if (_items.isEmpty) {
      return const Center(child: Text('No inwards yet.'));
    }

    // Show list with pagination
    return RefreshIndicator(
      onRefresh: () => _loadData(refresh: true),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _items.length + (_hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          // Show loading indicator at the bottom
          if (i >= _items.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final it = _items[i];
          return ListTile(
            key: ValueKey(it.id),
            title: Text('${it.cropName} • ${it.packagingType} • ${it.quantity}'),
            subtitle: Text('Person #${it.personId} • remaining: ${it.remainingQuantity} • ${fmtDateTime(it.createdAt)}'),
          );
        },
      ),
    );
  }
}
