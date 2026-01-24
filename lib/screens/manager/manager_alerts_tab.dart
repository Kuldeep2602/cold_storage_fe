import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';

class ManagerAlertsTab extends StatefulWidget {
  const ManagerAlertsTab({super.key});

  @override
  State<ManagerAlertsTab> createState() => _ManagerAlertsTabState();
}

class _ManagerAlertsTabState extends State<ManagerAlertsTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _activeAlerts = [];
  List<Map<String, dynamic>> _normalRooms = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);
    try {
      final appState = context.read<AppState>();

      // Load active alerts
      final alerts = await appState.client.getJson(
        '/api/temperature/alerts/',
        query: {'status': 'active'},
      );

      if (mounted) {
        // Handle both paginated and non-paginated responses
        List<Map<String, dynamic>> alertsList;
        if (alerts is Map && alerts.containsKey('results')) {
          alertsList =
              (alerts['results'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        } else if (alerts is List) {
          alertsList = alerts.cast<Map<String, dynamic>>();
        } else {
          alertsList = [];
        }

        setState(() {
          _activeAlerts = alertsList;
          _normalRooms = []; // We'll load this separately if needed
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _activeAlerts = [];
          _normalRooms = [];
          _isLoading = false;
        });
        debugPrint('Error loading alerts: $e');
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoadingAlerts(e.toString()))),
        );
      }
    }
  }

  Future<void> _takeAction(int alertId, String action) async {
    try {
      final appState = context.read<AppState>();
      await appState.client
          .postJson('/api/temperature/alerts/$alertId/take-action/', {
        'action': action,
      });
      _loadAlerts();
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.alertActionSuccess(action))),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorMessage(e.toString()))),
        );
      }
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
            // Red Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF44336),
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
                    child: const Icon(Icons.warning_amber,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.temperatureAlerts,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          l10n.activeAlertsCount(_activeAlerts.length),
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
                      foregroundColor: const Color(0xFFF44336),
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
                      onRefresh: _loadAlerts,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Active Alerts Section
                          if (_activeAlerts.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(Icons.warning,
                                    color: Color(0xFFF44336), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.activeAlerts,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF44336),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ..._activeAlerts
                                .map((alert) => _buildAlertCard(alert)),
                          ],

                          if (_activeAlerts.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: const Icon(
                                      Icons.check_circle,
                                      size: 40,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.allClear,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.noActiveAlerts,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Normal Status Section
                          if (_normalRooms.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Color(0xFF4CAF50), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.normalStatus,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ..._normalRooms
                                .map((room) => _buildNormalRoomCard(room)),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final l10n = AppLocalizations.of(context)!;
    final severity = alert['severity']?.toString().toLowerCase() ?? 'medium';
    final isHigh = severity == 'high' || severity == 'critical';

    final bgColor = isHigh ? const Color(0xFFFFEBEE) : const Color(0xFFFFF8E1);
    final borderColor =
        isHigh ? const Color(0xFFFFCDD2) : const Color(0xFFFFE082);
    final severityColor =
        isHigh ? const Color(0xFFF44336) : const Color(0xFFFF9800);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: severityColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: severityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(Icons.warning, color: severityColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert['room_name'] ?? l10n.unknownRoom,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                alert['time_ago'] ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: severityColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        severity.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Temperature Info
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.currentTemp,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.thermostat,
                                    color: severityColor, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '${alert['temperature']}°C',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: severityColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.allowedRange,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.tempRange(alert['room_min_temp'],
                                  alert['room_max_temp']),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Take Action Button
          InkWell(
            onTap: () => _showActionDialog(alert),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: severityColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  l10n.takeAction,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

  Widget _buildNormalRoomCard(Map<String, dynamic> room) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8F5E9)),
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
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.thermostat,
                color: Color(0xFF4CAF50), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room['name'] ?? l10n.unknownRoom,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${room['min_temperature']}°C to ${room['max_temperature']}°C',
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
                '${room['current_temperature'] ?? 0}°C',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              Text(
                l10n.withinRange,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showActionDialog(Map<String, dynamic> alert) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.actionTaken(alert['room_name'])),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility, color: Color(0xFF1976D2)),
              title: Text(l10n.acknowledge),
              subtitle: Text(l10n.markAsSeen),
              onTap: () {
                Navigator.pop(context);
                _takeAction(alert['id'] as int, 'acknowledge');
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
              title: Text(l10n.resolve),
              subtitle: Text(l10n.issueFixed),
              onTap: () {
                Navigator.pop(context);
                _takeAction(alert['id'] as int, 'resolve');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}
