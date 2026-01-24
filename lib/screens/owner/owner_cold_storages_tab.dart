import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

/// Helper function to safely convert any value to double
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class OwnerColdStoragesTab extends StatefulWidget {
  const OwnerColdStoragesTab({super.key});

  @override
  State<OwnerColdStoragesTab> createState() => _OwnerColdStoragesTabState();
}

class _OwnerColdStoragesTabState extends State<OwnerColdStoragesTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _coldStorages = [];

  @override
  void initState() {
    super.initState();
    _loadColdStorages();
  }

  Future<void> _loadColdStorages() async {
    setState(() => _isLoading = true);
    try {
      final appState = context.read<AppState>();
      final data =
          await appState.client.getJson('/api/inventory/cold-storages/');

      if (mounted && data != null) {
        List<Map<String, dynamic>> storages = [];

        // Handle paginated response
        if (data is Map && data.containsKey('results')) {
          storages = (data['results'] as List).cast<Map<String, dynamic>>();
        } else if (data is List) {
          // Fallback for non-paginated response
          storages = data.cast<Map<String, dynamic>>();
        }

        setState(() {
          _coldStorages = storages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint('Cold storages load error: $e');
        setState(() {
          _coldStorages = []; // Empty list on error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading cold storages: $e')),
        );
      }
    }
  }

  void _showCreateDialog([Map<String, dynamic>? existingData]) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = existingData != null;
    final nameController = TextEditingController(text: existingData?['name']);
    final codeController = TextEditingController(text: existingData?['code']);
    final cityController = TextEditingController(text: existingData?['city']);
    final capacityController = TextEditingController(
        text:
            existingData != null ? '${existingData['total_capacity']}' : '500');
    final roomsController = TextEditingController(); // Only for create

    // Storage Types
    final storageTypes = [
      {'value': 'silo', 'label': l10n.silos},
      {'value': 'warehouse', 'label': l10n.warehouses},
      {'value': 'cold_storage', 'label': l10n.coldStorages},
      {'value': 'frozen_storage', 'label': l10n.frozenStorages},
      {'value': 'ripening_chamber', 'label': l10n.ripeningChambers},
      {'value': 'controlled_atmosphere', 'label': l10n.controlledAtmosphere},
    ];

    String selectedType = existingData?['storage_type'] ?? 'cold_storage';
    // Handle case where existingData['storage_type'] might be null or not in list
    if (!storageTypes.any((t) => t['value'] == selectedType)) {
      selectedType = 'cold_storage';
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_business,
                    color: Color(0xFF1976D2), size: 20),
              ),
              const SizedBox(width: 12),
              Text(isEdit ? l10n.editStorage : l10n.addStorage),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.storageType,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                  items: storageTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type['value'],
                      child: Text(type['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(l10n.nameRequired,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: l10n.storageNameHint,
                    prefixIcon: const Icon(Icons.business),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.codeRequired,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    hintText: l10n.codeHint,
                    prefixIcon: const Icon(Icons.tag),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.city,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: l10n.cityHint,
                    prefixIcon: const Icon(Icons.location_city),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.totalCapacityMT,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: capacityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '500',
                    prefixIcon: const Icon(Icons.storage),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                if (!isEdit) ...[
                  const SizedBox(height: 16),
                  Text(l10n.roomsRequired,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(
                    l10n.addAtLeastOneRoom,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: roomsController,
                    decoration: InputDecoration(
                      hintText: l10n.roomsHint,
                      prefixIcon: const Icon(Icons.meeting_room),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      helperText: l10n.separateWithCommas,
                      helperStyle:
                          TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),
          actions: isEdit
              ? [
                  TextButton(
                    onPressed: () async {
                      try {
                        final appState = context.read<AppState>();
                        await appState.client.deleteJson(
                            '/api/inventory/cold-storages/${existingData!['id']}/');
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        _loadColdStorages();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.storageDeleted)),
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${l10n.error}: $e')),
                          );
                        }
                      }
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: Text(l10n.delete),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          codeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.nameCodeRequired)),
                        );
                        return;
                      }

                      try {
                        final appState = context.read<AppState>();
                        final body = {
                          'name': nameController.text,
                          'code': codeController.text.toUpperCase(),
                          'city': cityController.text,
                          'total_capacity':
                              double.tryParse(capacityController.text) ?? 500,
                          'storage_type': selectedType,
                        };

                        await appState.client.patchJson(
                            '/api/inventory/cold-storages/${existingData!['id']}/',
                            body);

                        if (context.mounted) {
                          Navigator.pop(context);
                          _loadColdStorages();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.storageUpdatedSuccess)),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${l10n.error}: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2)),
                    child: Text(l10n.update),
                  ),
                ]
              : [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          codeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.nameCodeRequired)),
                        );
                        return;
                      }

                      // Validate rooms are provided
                      if (roomsController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.atLeastOneRoomRequired)),
                        );
                        return;
                      }

                      try {
                        final appState = context.read<AppState>();
                        final body = {
                          'name': nameController.text,
                          'code': codeController.text.toUpperCase(),
                          'city': cityController.text,
                          'total_capacity':
                              double.tryParse(capacityController.text) ?? 500,
                          'storage_type': selectedType,
                        };

                        // Always include rooms (now required)
                        body['initial_rooms'] = roomsController.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList();

                        await appState.client
                            .postJson('/api/inventory/cold-storages/', body);

                        if (context.mounted) {
                          Navigator.pop(context);
                          _loadColdStorages();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.storageCreatedSuccess)),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${l10n.error}: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2)),
                    child: Text(l10n.create),
                  ),
                ],
        ),
      ),
    );
  }

  void _showDetailsDialog(Map<String, dynamic> cs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cs['display_name'] ?? cs['name'] ?? 'Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Code', cs['code']),
            _detailRow('City', cs['city']),
            _detailRow('Capacity', '${cs['total_capacity']} MT'),
            _detailRow('Occupied', '${cs['occupied_capacity']} MT'),
            _detailRow('Manager', cs['manager_name'] ?? 'Not Assigned'),
            _detailRow(
                'Status', (cs['is_active'] ?? false) ? 'Active' : 'Inactive'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 80,
              child: Text('$label:',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13))),
          Expanded(
              child: Text(value ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  void _showAssignManagerDialog(Map<String, dynamic> coldStorage) async {
    final l10n = AppLocalizations.of(context)!;
    // Fetch available managers
    List<Map<String, dynamic>> managers = [];

    try {
      final appState = context.read<AppState>();
      final data = await appState.client.getJson('/api/staff/');

      // Handle paginated response
      List staffList;
      if (data is Map && data.containsKey('results')) {
        staffList = data['results'] as List;
      } else {
        staffList = data as List;
      }

      managers = staffList
          .cast<Map<String, dynamic>>()
          .where((m) => m['role'] == 'manager')
          .toList();
    } catch (e) {
      debugPrint('Error loading managers: $e');
    }

    if (!mounted) return;

    int? selectedManagerId = coldStorage['manager'] as int?;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.assignManager),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.coldStorageLabel(
                    coldStorage['display_name'] ?? coldStorage['name']),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(l10n.selectManager, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int?>(
                value: selectedManagerId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.noManager)),
                  ...managers.map((m) {
                    return DropdownMenuItem(
                      value: m['id'] as int,
                      child: Text('${m['name']} (${m['phone_number']})'),
                    );
                  }),
                ],
                onChanged: (value) {
                  setDialogState(() => selectedManagerId = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final appState = context.read<AppState>();
                  await appState.client.postJson(
                    '/api/inventory/cold-storages/${coldStorage['id']}/assign-manager/',
                    {'manager_id': selectedManagerId},
                  );
                  Navigator.pop(context);
                  _loadColdStorages();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text(l10n.managerAssignedSuccess)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${l10n.error}: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2)),
              child: Text(l10n.assign),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Blue Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.ac_unit,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.storages,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          l10n.manageYourFacilities,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<AppState>().logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(l10n.logout,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadColdStorages,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Add Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _showCreateDialog,
                              icon: const Icon(Icons.add_business, size: 20),
                              label: Text(l10n.addNewStorage),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Cold Storages List
                          Text(
                            l10n.yourStoragesCount(_coldStorages.length),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),

                          const SizedBox(height: 12),

                          if (_coldStorages.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.ac_unit,
                                      size: 48, color: Colors.grey[400]),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.noStoragesYet,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.addFirstStorage,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ..._coldStorages
                                .map((cs) => _buildColdStorageCard(cs)),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColdStorageCard(Map<String, dynamic> cs) {
    final l10n = AppLocalizations.of(context)!;
    final utilization = _toDouble(cs['utilization_percent']);
    final occupied = _toDouble(cs['occupied_capacity']);
    final total = _toDouble(cs['total_capacity']);
    final managerName = cs['manager_name']?.toString();
    final isActive = cs['is_active'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.ac_unit, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cs['display_name']?.toString() ??
                            cs['name']?.toString() ??
                            '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${cs['city'] ?? ''} • ${cs['code'] ?? ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        isActive ? const Color(0xFFE8F5E9) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? l10n.active : l10n.inactive,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Capacity Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.capacityUsage,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13)),
                        Text('${utilization.toStringAsFixed(0)}%',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: total > 0
                            ? (utilization / 100).clamp(0.0, 1.0)
                            : 0.0,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(
                          utilization > 80
                              ? Colors.red
                              : (utilization > 60
                                  ? Colors.orange
                                  : Colors.green),
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.mtUsed(occupied.toStringAsFixed(0)),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                        Text(l10n.mtTotal(total.toStringAsFixed(0)),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Manager Row
                Row(
                  children: [
                    Icon(Icons.person, size: 18, color: Colors.grey[500]),
                    const SizedBox(width: 8),
                    Text(
                      l10n.managerLabel,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Expanded(
                      child: Text(
                        managerName ?? l10n.notAssigned,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: managerName != null
                              ? const Color(0xFF333333)
                              : Colors.orange,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showAssignManagerDialog(cs),
                      child:
                          Text(managerName != null ? l10n.change : l10n.assign),
                    ),
                  ],
                ),

                const Divider(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDetailsDialog(cs),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: Text(l10n.view),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1976D2),
                          side: const BorderSide(color: Color(0xFF1976D2)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showCreateDialog(cs),
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text(l10n.edit),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4CAF50),
                          side: const BorderSide(color: Color(0xFF4CAF50)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
