import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../operator/inward_entry_screen.dart';
import '../operator/outward_entry_screen.dart';

class ManagerInventoryTab extends StatefulWidget {
  const ManagerInventoryTab({super.key});

  @override
  State<ManagerInventoryTab> createState() => _ManagerInventoryTabState();
}

class _ManagerInventoryTabState extends State<ManagerInventoryTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _inventoryItems = [];
  double _totalStock = 0;
  int _cropCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    setState(() => _isLoading = true);
    try {
      final appState = context.read<AppState>();
      final data = await appState.inventory.fetchStock();

      if (mounted && data != null) {
        final items = (data as List).cast<Map<String, dynamic>>();
        double total = 0;
        for (var item in items) {
          total +=
              double.tryParse(item['remaining_quantity']?.toString() ?? '0') ??
                  0;
        }

        setState(() {
          _inventoryItems = items;
          _totalStock = total;
          _cropCount = items.map((e) => e['crop_name']).toSet().length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Use demo data
        setState(() {
          _inventoryItems = [
            {
              'crop_name': 'Potato',
              'remaining_quantity': '120',
              'entry_date': '2024-10-15',
              'expected_out': '2025-01-15',
            },
            {
              'crop_name': 'Onion',
              'remaining_quantity': '85',
              'entry_date': '2024-11-01',
              'expected_out': '2025-02-01',
            },
            {
              'crop_name': 'Tomato',
              'remaining_quantity': '45',
              'entry_date': '2024-11-20',
              'expected_out': '2025-01-20',
            },
            {
              'crop_name': 'Cauliflower',
              'remaining_quantity': '60',
              'entry_date': '2024-10-25',
              'expected_out': '2025-01-25',
            },
          ];
          _totalStock = 310;
          _cropCount = 4;
        });
      }
    }
  }

  void _navigateToInwardEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InwardEntryScreen(),
      ),
    );
    // Refresh inventory if entry was added
    if (result == true) {
      _loadInventory();
    }
  }

  void _navigateToOutwardEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OutwardEntryScreen(),
      ),
    );
    // Refresh inventory if outward was recorded
    if (result == true) {
      _loadInventory();
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
                    child: const Icon(Icons.inventory_2,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.inventorySummary,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          l10n.viewStoredCrops,
                          style: TextStyle(
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
                      onRefresh: _loadInventory,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Total Stock Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF1976D2).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.totalStock,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_totalStock.toStringAsFixed(0)} ${l10n.mt}',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.acrossCropTypes(_cropCount),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _navigateToInwardEntry,
                                  icon: const Icon(Icons.add_circle_outline,
                                      size: 20),
                                  label: Text(l10n.addInward),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _navigateToOutwardEntry,
                                  icon: const Icon(Icons.remove_circle_outline,
                                      size: 20),
                                  label: Text(l10n.markOutward),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF9800),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Inventory Items
                          ..._inventoryItems
                              .map((item) => _buildInventoryItem(item)),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem(Map<String, dynamic> item) {
    final l10n = AppLocalizations.of(context)!;
    final cropName = item['crop_name'] ?? l10n.unknown;
    final quantity =
        double.tryParse(item['remaining_quantity']?.toString() ?? '0') ?? 0;
    final entryDate = item['entry_date'] ?? '';
    final expectedOut = item['expected_out'] ??
        item['expected_storage_duration_days']?.toString() ??
        '';

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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2,
                    color: Color(0xFF4CAF50), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cropName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.inStorage,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${quantity.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                  Text(
                    l10n.mt,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDateInfo(
                    Icons.login, l10n.inwardDate, _formatDate(entryDate)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateInfo(
                    Icons.logout, l10n.expectedOut, _formatDate(expectedOut)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '--';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
