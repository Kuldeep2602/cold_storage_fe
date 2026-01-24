import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';

class ManagerDashboardTab extends StatefulWidget {
  final void Function(int) onNavigateToTab;

  const ManagerDashboardTab({super.key, required this.onNavigateToTab});

  @override
  State<ManagerDashboardTab> createState() => _ManagerDashboardTabState();
}

class _ManagerDashboardTabState extends State<ManagerDashboardTab> {
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() => _isLoading = true);
    try {
      final appState = context.read<AppState>();
      // Use manager-specific dashboard endpoint
      final data =
          await appState.client.getJson('/api/inventory/manager-dashboard/');
      if (mounted) {
        setState(() {
          _dashboardData = data as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Show error and use empty data
        debugPrint('Manager dashboard load error: $e');
        setState(() {
          _dashboardData = {
            'cold_storages': [],
            'assigned_storages': [],
            'storage': {'available': 0, 'occupied': 0, 'total_capacity': 0},
            'pending_requests': 0,
            'active_alerts': 0,
            'staff_count': 0,
          };
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final userName = appState.user?.name ?? l10n.manager;

    // Extract stats from the new API response structure
    final stats = _dashboardData?['stats'] as Map<String, dynamic>?;
    final storage = stats?['storage'] as Map<String, dynamic>? ?? {};
    final available = (storage['available'] ?? 0).toDouble();
    final occupied = (storage['occupied'] ?? 0).toDouble();
    final totalCapacity = (storage['total_capacity'] ?? 0).toDouble();
    final activeBookings = stats?['active_bookings'] ?? 0;

    // Get assigned storages list
    final coldStorages = (_dashboardData?['cold_storages'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final storageNames = coldStorages
        .map((cs) => cs['display_name'] ?? cs['name'] ?? '')
        .join(', ');

    // These metrics are not provided by manager-dashboard endpoint yet
    final pendingRequests = 0; // TODO: Add to backend API
    final activeAlerts = 0; // TODO: Add to backend API
    final staffCount = 0; // TODO: Add to backend API

    // Check if storage is assigned
    final hasStorage = coldStorages.isNotEmpty;

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
                    child: const Icon(Icons.dashboard,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.managerDashboard,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          l10n.welcome(userName),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        if (storageNames.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              l10n.storageLabel(storageNames),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadDashboard,
                      child: !hasStorage
                          ? ListView(
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.2),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.store_mall_directory_outlined,
                                          size: 80, color: Colors.grey[400]),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.noStorageAssignedTitle,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.contactOwnerMessage,
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                // Storage Stats Row - Real-time from inventory
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        icon: Icons.check_circle_outline,
                                        iconColor: const Color(0xFF4CAF50),
                                        title: l10n.available,
                                        value:
                                            '${available.toStringAsFixed(0)}',
                                        unit: l10n.mt,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        icon: Icons.trending_up,
                                        iconColor: const Color(0xFFFF9800),
                                        title: l10n.occupied,
                                        value: '${occupied.toStringAsFixed(0)}',
                                        unit: l10n.mt,
                                        valueColor: const Color(0xFFFF9800),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Active Bookings Card
                                _buildPendingCard(activeBookings),

                                const SizedBox(height: 16),

                                // Quick Action Cards - Clickable with navigation
                                _buildActionCard(
                                  icon: Icons.description,
                                  iconBgColor: const Color(0xFFFFF3E0),
                                  iconColor: const Color(0xFFFF9800),
                                  title: l10n.activeBookings,
                                  subtitle: l10n.activeEntriesCount(
                                      activeBookings as int),
                                  badge: activeBookings as int,
                                  badgeColor: const Color(0xFFFF9800),
                                  onTap: () {
                                    // Navigate to Requests tab (index 1)
                                    widget.onNavigateToTab(1);
                                  },
                                ),

                                const SizedBox(height: 12),

                                _buildActionCard(
                                  icon: Icons.inventory_2,
                                  iconBgColor: const Color(0xFFE3F2FD),
                                  iconColor: const Color(0xFF1976D2),
                                  title: l10n.inventorySummary,
                                  subtitle: l10n.viewStoredCrops,
                                  onTap: () {
                                    // Navigate to Inventory tab (index 2)
                                    widget.onNavigateToTab(2);
                                  },
                                ),

                                const SizedBox(height: 12),

                                _buildActionCard(
                                  icon: Icons.warning_amber,
                                  iconBgColor: const Color(0xFFFFEBEE),
                                  iconColor: const Color(0xFFF44336),
                                  title: l10n.temperatureAlerts,
                                  subtitle: l10n
                                      .alertsActiveCount(activeAlerts as int),
                                  badge: activeAlerts as int,
                                  badgeColor: const Color(0xFFF44336),
                                  onTap: () {
                                    // Navigate to Alerts tab (index 4)
                                    widget.onNavigateToTab(4);
                                  },
                                ),

                                const SizedBox(height: 12),

                                _buildActionCard(
                                  icon: Icons.people,
                                  iconBgColor: const Color(0xFFE8F5E9),
                                  iconColor: const Color(0xFF4CAF50),
                                  title: l10n.staffManagement,
                                  subtitle:
                                      l10n.teamMembersCount(staffCount as int),
                                  onTap: () {
                                    // Navigate to Staff tab (index 3)
                                    widget.onNavigateToTab(3);
                                  },
                                ),
                              ],
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
    Color? valueColor,
  }) {
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
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF4CAF50),
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(int activeBookings) {
    final l10n = AppLocalizations.of(context)!;
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
              Icon(Icons.access_time, color: Colors.grey[500], size: 18),
              const SizedBox(width: 6),
              Text(
                l10n.pendingRequests,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$activeBookings',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF9800),
            ),
          ),
          Text(
            l10n.awaitingApproval,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    int? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null && badge > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}
