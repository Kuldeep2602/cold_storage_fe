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
  Future<List<InwardEntry>>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final app = context.read<AppState>();
    _future = app.inventory.listInwards().then((data) {
      final list = (data as List).cast<dynamic>();
      return list
          .map((e) => InwardEntry.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    });
    setState(() {});
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
    int qualityRating = 3;
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
          qualityRating: qualityRating,
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
                  DropdownButtonFormField<int>(
                    value: qualityRating,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1')),
                      DropdownMenuItem(value: 2, child: Text('2')),
                      DropdownMenuItem(value: 3, child: Text('3')),
                      DropdownMenuItem(value: 4, child: Text('4')),
                      DropdownMenuItem(value: 5, child: Text('5')),
                    ],
                    onChanged: (v) => setSheetState(() => qualityRating = v ?? 3),
                    decoration: const InputDecoration(labelText: 'Quality rating (1-5)', border: OutlineInputBorder()),
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
      body: FutureBuilder<List<InwardEntry>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const AppLoadingView(label: 'Loading inwards...');
          }
          if (snap.hasError) {
            return AppErrorView(message: snap.error.toString(), onRetry: _reload);
          }
          final items = snap.data ?? const <InwardEntry>[];
          if (items.isEmpty) return const Center(child: Text('No inwards yet.'));

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final it = items[i];
                return ListTile(
                  title: Text('${it.cropName} • ${it.packagingType} • ${it.quantity}'),
                  subtitle: Text('Person #${it.personId} • remaining: ${it.remainingQuantity} • ${fmtDateTime(it.createdAt)}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
