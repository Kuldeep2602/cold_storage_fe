import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';

class ManagerRoomSettingsTab extends StatefulWidget {
  const ManagerRoomSettingsTab({super.key});

  @override
  State<ManagerRoomSettingsTab> createState() => _ManagerRoomSettingsTabState();
}

class _ManagerRoomSettingsTabState extends State<ManagerRoomSettingsTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() => _isLoading = true);
    try {
      final appState = context.read<AppState>();

      // First, get manager's assigned cold storages to filter rooms
      final dashboardData =
          await appState.client.getJson('/api/inventory/manager-dashboard/');
      final assignedStorages = (dashboardData['cold_storages'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          [];

      // Get the IDs of assigned storages
      final assignedStorageIds = assignedStorages
          .map((storage) => storage['id'] as int?)
          .where((id) => id != null)
          .toSet();

      // Load all rooms from API
      final data = await appState.client.getJson('/api/inventory/rooms/');

      List<Map<String, dynamic>> allRooms;
      if (data is Map && data.containsKey('results')) {
        allRooms = (data['results'] as List).cast<Map<String, dynamic>>();
      } else if (data is List) {
        allRooms = data.cast<Map<String, dynamic>>();
      } else {
        allRooms = [];
      }

      // Filter rooms to only show those belonging to assigned storages
      final filteredRooms = allRooms.where((room) {
        final storageId = room['cold_storage'] as int?;
        return storageId != null && assignedStorageIds.contains(storageId);
      }).toList();

      if (mounted) {
        setState(() {
          _rooms = filteredRooms;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint('Error loading rooms: $e');
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoadingAlerts(e.toString()))),
        );
      }
    }
  }

  Future<void> _showAddRoomDialog() async {
    final appState = context.read<AppState>();

    // Get manager's assigned cold storages
    final dashboardData =
        await appState.client.getJson('/api/inventory/manager-dashboard/');
    final coldStorages = (dashboardData['cold_storages'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    if (coldStorages.isEmpty) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noStoragesAssigned)),
        );
      }
      return;
    }

    final roomNameController = TextEditingController();
    final capacityController = TextEditingController(text: '100');
    final minTempController = TextEditingController(text: '-5');
    final maxTempController = TextEditingController(text: '0');
    int? selectedStorageId = coldStorages.first['id'] as int?;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(l10n.addNewRoom),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.coldStorageRequired,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedStorageId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    items: coldStorages.map((cs) {
                      return DropdownMenuItem<int>(
                        value: cs['id'] as int,
                        child: Text(cs['display_name'] ?? cs['name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() => selectedStorageId = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.roomNameRequired,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: roomNameController,
                    decoration: InputDecoration(
                      hintText: l10n.roomNameHint,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.capacityMT,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: capacityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: l10n.capacityPlaceholder,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.minTemperature,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: minTempController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    decoration: InputDecoration(
                      hintText: l10n.minTempPlaceholder,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.maxTemperature,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: maxTempController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    decoration: InputDecoration(
                      hintText: l10n.maxTempPlaceholder,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  final l10n = AppLocalizations.of(context)!;
                  if (roomNameController.text.trim().isEmpty ||
                      selectedStorageId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.roomNameStorageRequired)),
                    );
                    return;
                  }

                  try {
                    final body = {
                      'cold_storage': selectedStorageId,
                      'room_name': roomNameController.text.trim(),
                      'capacity':
                          double.tryParse(capacityController.text) ?? 100,
                      'min_temperature':
                          double.tryParse(minTempController.text) ?? -5,
                      'max_temperature':
                          double.tryParse(maxTempController.text) ?? 0,
                    };

                    debugPrint('Creating room with data: $body');
                    final response = await appState.client
                        .postJson('/api/inventory/rooms/', body);
                    debugPrint('Room created successfully: $response');

                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    debugPrint('Error creating room: $e');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(l10n.errorMessage(e.toString()))),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2)),
                child: Text(l10n.addRoom),
              ),
            ],
          ),
        );
      },
    );

    if (result == true && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.roomAddedSuccess)),
      );
      _loadRooms();
    }
  }

  Future<void> _editRoomTemperature(Map<String, dynamic> room) async {
    final minController = TextEditingController(
      text: (room['min_temperature'] ?? -5.0).toString(),
    );
    final maxController = TextEditingController(
      text: (room['max_temperature'] ?? 0.0).toString(),
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(l10n.setTemperatureRange),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room['room_name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  room['cold_storage_name'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.minimumTemperature,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: minController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.minTempExample,
                    suffixText: '°C',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.maximumTemperature,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: maxController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.maxTempExample,
                    suffixText: '°C',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.temperatureAlertInfo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final minTemp = double.parse(minController.text);
                  final maxTemp = double.parse(maxController.text);

                  if (minTemp >= maxTemp) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(l10n.minLessThanMax),
                      ),
                    );
                    return;
                  }

                  final appState = context.read<AppState>();
                  await appState.client.patchJson(
                    '/api/inventory/rooms/${room['id']}/',
                    {
                      'min_temperature': minTemp,
                      'max_temperature': maxTemp,
                    },
                  );

                  Navigator.pop(dialogContext, true);
                } catch (e) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(l10n.errorMessage(e.toString()))),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
              ),
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.temperatureRangeUpdated)),
      );
      _loadRooms();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
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
                    child: const Icon(Icons.settings,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.roomTemperatureSettings,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          l10n.roomsCount(_rooms.length),
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
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1976D2),
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
                  : _rooms.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.meeting_room_outlined,
                                  size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noRoomsFound,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadRooms,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _rooms.length,
                            itemBuilder: (context, index) {
                              final room = _rooms[index];
                              return _buildRoomCard(room);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddRoomDialog,
        backgroundColor: const Color(0xFF1976D2),
        icon: const Icon(Icons.add),
        label: Text(l10n.addRoom),
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    final l10n = AppLocalizations.of(context)!;
    final minTemp = room['min_temperature'] ?? -5.0;
    final maxTemp = room['max_temperature'] ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.meeting_room,
                      color: Color(0xFF1976D2), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room['room_name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        room['cold_storage_name'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$minTemp°C to $maxTemp°C',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.allowedRange,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _editRoomTemperature(room),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  l10n.editTemperatureRange,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
