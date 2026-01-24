import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/person.dart';
import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../widgets/app_error.dart';
import '../../widgets/app_loading.dart';

class PersonsTab extends StatefulWidget {
  const PersonsTab({super.key});

  @override
  State<PersonsTab> createState() => _PersonsTabState();
}

class _PersonsTabState extends State<PersonsTab> {
  List<Person> _items = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  final ScrollController _scrollController = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _search.dispose();
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
      final data = await app.inventory.listPersons(page: _currentPage);

      List<Person> newItems = [];
      if (data is Map && data.containsKey('results')) {
        newItems = (data['results'] as List)
            .map((e) => Person.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
        _hasMore = data['next'] != null;
      } else if (data is List) {
        newItems = data
            .map((e) => Person.fromJson((e as Map).cast<String, dynamic>()))
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
      final data = await app.inventory.listPersons(page: _currentPage);

      List<Person> newItems = [];
      if (data is Map && data.containsKey('results')) {
        newItems = (data['results'] as List)
            .map((e) => Person.fromJson((e as Map).cast<String, dynamic>()))
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

  Future<void> _findByMobile() async {
    final mobile = _search.text.trim();
    if (mobile.isEmpty) return;

    try {
      final app = context.read<AppState>();
      final data = await app.inventory.findPersonByMobile(mobile);
      final person = Person.fromJson((data as Map).cast<String, dynamic>());
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Person'),
          content: Text('${person.name}\n${person.mobileNumber}\n${person.personType}'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    } on ApiException catch (e) {
      _snack(e.toString());
    } catch (e) {
      _snack(e.toString());
    }
  }

  Future<void> _createPerson() async {
    final type = ValueNotifier<String>('farmer');
    final name = TextEditingController();
    final mobile = TextEditingController();
    final address = TextEditingController();

    Future<void> submit() async {
      try {
        final app = context.read<AppState>();
        await app.inventory.createPerson(
          personType: type.value,
          name: name.text.trim(),
          mobileNumber: mobile.text.trim(),
          address: address.text.trim(),
        );
        if (!context.mounted) return;
        Navigator.pop(context);
        _reload();
        _snack('Person created');
      } on ApiException catch (e) {
        _snack(e.toString());
      } catch (e) {
        _snack(e.toString());
      }
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomInset + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Create Person', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              ValueListenableBuilder<String>(
                valueListenable: type,
                builder: (_, v, __) => DropdownButtonFormField<String>(
                  value: v,
                  items: const [
                    DropdownMenuItem(value: 'farmer', child: Text('Farmer')),
                    DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
                  ],
                  onChanged: (x) => type.value = x ?? 'farmer',
                  decoration: const InputDecoration(labelText: 'Person type'),
                ),
              ),
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                controller: mobile,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Mobile number'),
              ),
              TextField(controller: address, decoration: const InputDecoration(labelText: 'Address')),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: submit, child: const Text('Create')),
              ),
            ],
          ),
        );
      },
    );

    name.dispose();
    mobile.dispose();
    address.dispose();
    type.dispose();
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _createPerson,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _search,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Find by mobile',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _findByMobile, child: const Text('Find')),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _items.isEmpty) {
      return const AppLoadingView(label: 'Loading persons...');
    }

    if (_error != null && _items.isEmpty) {
      return AppErrorView(message: _error!, onRetry: _reload);
    }

    if (_items.isEmpty) {
      return const Center(child: Text('No persons yet.'));
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

          final p = _items[i];
          return ListTile(
            key: ValueKey(p.id),
            title: Text(p.name),
            subtitle: Text('${p.mobileNumber} • ${p.personType}'),
          );
        },
      ),
    );
  }
}
