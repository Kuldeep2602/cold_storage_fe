import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import 'owner_cold_storages_tab.dart';
import 'owner_staff_tab.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tabs = <Widget>[
      OwnerOverviewTab(key: const ValueKey('overview')),
      const OwnerColdStoragesTab(),
      const OwnerStaffTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index) => setState(() => _currentTabIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1976D2),
          unselectedItemColor: const Color(0xFF9E9E9E),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: l10n.overview,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.ac_unit_outlined),
              activeIcon: const Icon(Icons.ac_unit),
              label: l10n.storages,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              activeIcon: const Icon(Icons.people),
              label: l10n.staff,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to safely convert any value to double
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class OwnerOverviewTab extends StatefulWidget {
  const OwnerOverviewTab({super.key});

  @override
  State<OwnerOverviewTab> createState() => _OwnerOverviewTabState();
}

class _OwnerOverviewTabState extends State<OwnerOverviewTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _coldStorages = [];
  Map<String, dynamic>? _selectedColdStorage;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final appState = context.read<AppState>();
      final csId = _selectedColdStorage?['id']?.toString() ?? '';
      final query =
          csId.isNotEmpty ? {'cold_storage': csId} : <String, String>{};
      final data = await appState.client
          .getJson('/api/inventory/owner-dashboard/', query: query);

      if (mounted && data != null) {
        final response = data as Map<String, dynamic>;
        setState(() {
          _coldStorages = (response['cold_storages'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              [];
          _selectedColdStorage =
              response['selected_cold_storage'] as Map<String, dynamic>?;
          _stats = response['stats'] as Map<String, dynamic>?;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        debugPrint('Owner dashboard load error: $e');
        setState(() {
          _isLoading = false;
          // Demo data
          _coldStorages = [
            {
              'id': 1,
              'name': 'ColdOne',
              'code': 'COLD1',
              'display_name': 'ColdOne Nashik Main',
              'city': 'Nashik'
            },
            {
              'id': 2,
              'name': 'ColdTwo',
              'code': 'COLD2',
              'display_name': 'ColdTwo Pune',
              'city': 'Pune'
            },
          ];
          _selectedColdStorage =
              _coldStorages.isNotEmpty ? _coldStorages.first : null;
          _stats = {
            'storage': {
              'total_capacity': 500,
              'occupied': 350,
              'available': 150,
              'utilization_percent': 70
            },
            'this_month': {'inflow': 145, 'outflow': 95},
            'bookings': {'active': 12, 'confirmed': 8, 'pending': 4},
            'alerts': {
              'active': 2,
              'temperature_alerts': 2,
              'equipment_status': 'operational'
            },
            'financials': {
              'estimated_revenue': 4.2,
              'avg_storage_duration': 68
            },
          };
        });
      }
    }
  }

  void _onColdStorageChanged(int? id) {
    if (id != null) {
      final cs = _coldStorages.firstWhere((c) => c['id'] == id,
          orElse: () => _coldStorages.first);
      setState(() => _selectedColdStorage = cs);
      _loadData();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.analytics_outlined,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.ownerOverview,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              l10n.highLevelMetrics,
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
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Cold Storage Dropdown
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.ac_unit, color: Colors.blue[700], size: 18),
                        const SizedBox(width: 8),
                        Text(
                          l10n.storage,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _coldStorages.isEmpty
                              ? Text(
                                  l10n.noStorages,
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: _selectedColdStorage?['id'] as int?,
                                    isExpanded: true,
                                    icon: Icon(Icons.keyboard_arrow_down,
                                        color: Colors.blue[700]),
                                    dropdownColor: Colors.white,
                                    menuMaxHeight: 320,
                                    borderRadius: BorderRadius.circular(12),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D47A1),
                                    ),
                                    hint: Text(l10n.selectStorage,
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                    items: _coldStorages.map((cs) {
                                      return DropdownMenuItem<int>(
                                        value: cs['id'] as int?,
                                        child: Row(
                                          children: [
                                            const Icon(Icons.ac_unit,
                                                size: 18,
                                                color: Color(0xFF1976D2)),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cs['display_name']
                                                            ?.toString() ??
                                                        cs['name']
                                                            ?.toString() ??
                                                        '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  if ((cs['city'] ?? '')
                                                      .toString()
                                                      .isNotEmpty)
                                                    Text(
                                                      cs['city'].toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: _onColdStorageChanged,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Storage Utilization Card
                          _buildStorageUtilizationCard(),

                          const SizedBox(height: 16),

                          // This Month Card
                          _buildThisMonthCard(),

                          const SizedBox(height: 16),

                          // Active Bookings Card
                          _buildActiveBookingsCard(),

                          const SizedBox(height: 16),

                          // Alert Summary Card
                          _buildAlertSummaryCard(),

                          const SizedBox(height: 16),

                          // Revenue and Duration Row
                          _buildFinancialsRow(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageUtilizationCard() {
    final l10n = AppLocalizations.of(context)!;
    final storage = _stats?['storage'] as Map<String, dynamic>? ?? {};
    final utilization = _toDouble(storage['utilization_percent']);
    final occupied = _toDouble(storage['occupied']);
    final total = _toDouble(storage['total_capacity']);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.storageUtilization,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${utilization.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.ofCapacity,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.mtOccupied(occupied.toStringAsFixed(0)),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              Text(
                l10n.mtTotal(total.toStringAsFixed(0)),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThisMonthCard() {
    final l10n = AppLocalizations.of(context)!;
    final thisMonth = _stats?['this_month'] as Map<String, dynamic>? ?? {};
    final inflow = _toDouble(thisMonth['inflow']);
    final outflow = _toDouble(thisMonth['outflow']);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.thisMonth,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.inflow,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${inflow.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        l10n.mtReceived,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.outflow,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${outflow.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                      Text(
                        l10n.mtDispatched,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[600],
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
    );
  }

  Widget _buildActiveBookingsCard() {
    final l10n = AppLocalizations.of(context)!;
    final bookings = _stats?['bookings'] as Map<String, dynamic>? ?? {};
    final active = bookings['active'] ?? 0;
    final confirmed = bookings['confirmed'] ?? 0;
    final pending = bookings['pending'] ?? 0;

    return Container(
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.description,
                    color: Color(0xFF1976D2), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.activeBookings,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$active',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.confirmed,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Text(
                '$confirmed',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.pending,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Text(
                '$pending',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertSummaryCard() {
    final l10n = AppLocalizations.of(context)!;
    final alerts = _stats?['alerts'] as Map<String, dynamic>? ?? {};
    final activeAlerts = alerts['active'] ?? 0;
    final tempAlerts = alerts['temperature_alerts'] ?? 0;
    final equipmentStatus =
        alerts['equipment_status']?.toString() ?? 'operational';

    return Container(
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.warning_amber,
                    color: Color(0xFFF44336), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.alertSummary,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              if (activeAlerts > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF44336),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$activeAlerts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Temperature Alerts
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tempAlerts > 0
                  ? const Color(0xFFFFEBEE)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.temperatureAlerts,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: tempAlerts > 0
                              ? Colors.red[800]
                              : Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tempAlerts > 0
                            ? l10n.roomsOutOfRange(tempAlerts)
                            : l10n.allRoomsNormal,
                        style: TextStyle(
                          fontSize: 13,
                          color: tempAlerts > 0
                              ? Colors.red[600]
                              : Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  tempAlerts > 0 ? Icons.warning : Icons.check_circle,
                  color: tempAlerts > 0 ? Colors.red : Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Equipment Status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.equipmentStatus,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        equipmentStatus == 'operational'
                            ? l10n.allSystemsOperational
                            : equipmentStatus,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.settings_suggest, color: Colors.green[600]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialsRow() {
    final l10n = AppLocalizations.of(context)!;
    final financials = _stats?['financials'] as Map<String, dynamic>? ?? {};
    final revenue = _toDouble(financials['estimated_revenue']);
    final avgDuration = financials['avg_storage_duration'] ?? 0;

    return Row(
      children: [
        Expanded(
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.revenueEst,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${revenue.toStringAsFixed(1)}L',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.avgDuration,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$avgDuration',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.days,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
