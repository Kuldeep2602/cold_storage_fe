import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';

class TemperatureMonitoringScreen extends StatefulWidget {
  const TemperatureMonitoringScreen({super.key});

  @override
  State<TemperatureMonitoringScreen> createState() =>
      _TemperatureMonitoringScreenState();
}

class _TemperatureMonitoringScreenState
    extends State<TemperatureMonitoringScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _rooms = [];
  final _temperatureController = TextEditingController();
  int? _selectedRoomId;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() => _isLoading = true);
    try {
      final appState = context.read<AppState>();
      final user = appState.user;

      if (user != null && user.assignedStorages.isNotEmpty) {
        // Get rooms from assigned storages
        final rooms = <Map<String, dynamic>>[];
        for (final storage in user.assignedStorages) {
          for (final room in storage.rooms) {
            rooms.add({
              'id': room.id,
              'room_name': room.roomName,
              'cold_storage_name': storage.displayName,
              'min_temperature': -5.0, // Default, will be updated from API
              'max_temperature': 0.0,
              'current_temperature': null,
            });
          }
        }

        if (mounted) {
          setState(() {
            _rooms = rooms;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _rooms = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoadingRooms(e.toString()))),
        );
      }
    }
  }

  Future<void> _logTemperature() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedRoomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectRoom)),
      );
      return;
    }

    if (_temperatureController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterTemperature)),
      );
      return;
    }

    try {
      final temperature = double.parse(_temperatureController.text);
      final appState = context.read<AppState>();

      final response = await appState.client.postJson(
        '/api/temperature/logs/log-temperature/',
        {
          'room_id': _selectedRoomId,
          'temperature': temperature,
        },
      );

      if (mounted) {
        final status = response['status'] as String?;
        final alertCreated = response['alert_created'] as bool? ?? false;

        Color snackBarColor;
        String message;

        if (status == 'normal') {
          snackBarColor = const Color(0xFF4CAF50);
          message = l10n.tempLoggedSuccess;
        } else if (status == 'warning') {
          snackBarColor = const Color(0xFFFF9800);
          message = l10n.tempLoggedWarning;
        } else {
          snackBarColor = const Color(0xFFF44336);
          message = l10n.tempLoggedCritical;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: snackBarColor,
            duration: const Duration(seconds: 3),
          ),
        );

        // Clear form
        _temperatureController.clear();
        setState(() => _selectedRoomId = null);

        // Reload rooms to get updated temperatures
        _loadRooms();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoggingTemp(e.toString()))),
        );
      }
    }
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.temperatureMonitoring),
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () async {
                await context.read<AppState>().logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF00897B),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                l10n.logout,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store_mall_directory_outlined,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noStorageRoomsAssigned,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.contactManager,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadRooms,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF00897B)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: Color(0xFF00897B)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.selectRoomInstruction,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF00695C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Room Selection
                      Text(
                        l10n.selectStorageRoomRequired,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _selectedRoomId,
                        decoration: InputDecoration(
                          hintText: l10n.chooseRoom,
                          prefixIcon: const Icon(Icons.meeting_room),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _rooms.map((room) {
                          return DropdownMenuItem<int>(
                            value: room['id'] as int,
                            child: Text(
                              '${room['room_name']} - ${room['cold_storage_name']}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedRoomId = value);
                        },
                      ),

                      const SizedBox(height: 24),

                      // Temperature Input
                      Text(
                        l10n.temperatureCelsius,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _temperatureController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        decoration: InputDecoration(
                          hintText: l10n.enterTempHint,
                          prefixIcon: const Icon(Icons.thermostat),
                          suffixText: l10n.celsiusUnit,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _logTemperature,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.logTemperature,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Rooms List
                      Text(
                        l10n.assignedRooms,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._rooms.map((room) => _buildRoomCard(room)),
                    ],
                  ),
                ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.meeting_room,
                color: Color(0xFF00897B), size: 24),
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
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
