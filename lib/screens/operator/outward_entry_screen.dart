import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../services/receipt_service.dart';


class OutwardEntryScreen extends StatefulWidget {
  const OutwardEntryScreen({super.key});

  @override
  State<OutwardEntryScreen> createState() => _OutwardEntryScreenState();
}

class _OutwardEntryScreenState extends State<OutwardEntryScreen> {
  final _searchController = TextEditingController();
  final _quantityController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitting = false;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Load all inventory on start
    _loadAllInventory();
  }

  Future<void> _loadAllInventory() async {
    setState(() => _isLoading = true);

    try {
      final appState = context.read<AppState>();
      final data = await appState.inventory.fetchStock();
      
      if (mounted && data != null) {
        setState(() {
          _searchResults = (data as List).cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading inventory: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _searchInventory() async {
    final query = _searchController.text.trim();

    setState(() => _isLoading = true);

    try {
      final appState = context.read<AppState>();
      final data = await appState.inventory.fetchStock(
        search: query.isEmpty ? null : query,
      );
      
      if (mounted && data != null) {
        setState(() {
          _searchResults = (data as List).cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showOutwardDialog(Map<String, dynamic> item) async {
    _quantityController.clear();
    final remainingQty = double.tryParse(item['remaining_quantity']?.toString() ?? '0') ?? 0;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Outward: ${item['crop_name'] ?? 'Unknown'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Party: ${item['person_name'] ?? 'Unknown'}'),
            Text('Available: ${remainingQty.toStringAsFixed(2)} ${item['packaging_type'] ?? ''}'),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity to remove',
                border: OutlineInputBorder(),
                hintText: 'Enter quantity',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
            ),
            child: const Text('Confirm Outward'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _processOutward(item);
    }
  }

  Future<void> _processOutward(Map<String, dynamic> item) async {
    final quantity = double.tryParse(_quantityController.text.trim());
    final remainingQty = double.tryParse(item['remaining_quantity']?.toString() ?? '0') ?? 0;
    
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    if (quantity > remainingQty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quantity exceeds available stock ($remainingQty)')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final appState = context.read<AppState>();
      final result = await appState.inventory.createOutwardEntry(
        inwardEntryId: item['id'],
        quantity: quantity.toString(),
        packagingType: item['packaging_type'] ?? 'bori',
      );

      if (!mounted) return;

      if (!mounted) return;

      // Show success with receipt number
      final receiptNumber = result['receipt_number'] ?? 'N/A';
      
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.orange), // Orange for outward
              SizedBox(width: 10),
              Text('Outward Recorded'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text('Outward receipt #$receiptNumber generated.'),
               const SizedBox(height: 20),
               SizedBox(
                 width: double.infinity,
                 child: ElevatedButton.icon(
                   icon: const Icon(Icons.download),
                   label: const Text('Download Receipt'),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.orange,
                     foregroundColor: Colors.white,
                   ),
                   onPressed: () {
                      final user = context.read<AppState>().user;
                      
                      ReceiptService.generateOutwardReceipt(
                          entryData: {
                              'receipt_number': receiptNumber,
                              'party_name': item['person_name'],
                              'party_phone': '', // Might not be available in summary
                              'crop_name': item['crop_name'],
                              'quantity': quantity.toString(),
                              'unit': item['packaging_type'] == 'bori' ? 'Bags' : 'MT', // Infer or use packaging type
                              'room': item['storage_room'] ?? '',
                              'variety': item['crop_variety'],
                              'grade': item['quality_grade'],
                          },
                          storageName: item['cold_storage_name'] ?? 'Storage',
                          userName: user?.name ?? 'Operator',
                      );
                   },
                 ),
               )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, true); // Close screen / return true
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );

      // Refresh the list if we didn't close (though we usually close)
      // Actually pop(true) closes the dialog, but we want to close the screen?
      // No, in outward entry usually we stay on the list screen or go back?
      // The original code was: 
      // Navigator.pop(context, true); -> This pops the DIALOG (from showDialog?) 
      // Wait, _processOutward is called from _showOutwardDialog which is a dialog itself.
      // But _processOutward calls Navigator.pop(context, true) at the end.
      // If I show another dialog inside _processOutward, I need to handle the stack.
      
      // Original flow:
      // 1. _showOutwardDialog (Dialog 1) -> opens
      // 2. User clicks confirm -> calls _processOutward
      // 3. _processOutward does work -> Navigator.pop(context, true) (Closes Dialog 1 and returns true to caller?)
      // Actually _processOutward is async. 
      // The button "Confirm" in Dialog 1 callsNavigator.pop(context, true) IMMEDIATELY.
      // Then if result == true, it calls _processOutward.
      // So Dialog 1 is ALREADY closed when _processOutward runs.
      
      // So my new Dialog (Dialog 2) is fine.
      // When I click "Close" on Dialog 2, I should just pop it. 
      // And then refresh the list.
      
      await _searchInventory();

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Orange Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFF9800),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        /*const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),*/
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Outward Entry',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Stock unloading entry',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
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
                      foregroundColor: const Color(0xFFFF9800),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isSubmitting 
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Processing outward entry...'),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Section 1: Select Booking / Party
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '1. Select Booking / Party',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Search Stored Inventory',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search by party, phone, or crop',
                                hintStyle: const TextStyle(color: Color(0xFF999999)),
                                prefixIcon: const Icon(Icons.search, color: Color(0xFF999999)),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _loadAllInventory();
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFFF9800)),
                                ),
                              ),
                              onSubmitted: (_) => _searchInventory(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  _loadAllInventory();
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _searchInventory,
                                icon: const Icon(Icons.search),
                                label: const Text('Search'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF9800),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Search Results or Empty State
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_searchResults.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No inventory found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Available Inventory',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Text(
                                    '${_searchResults.length} items',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ..._searchResults.map((result) => _buildInventoryCard(result)).toList(),
                          ],
                        ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    final cropName = item['crop_name'] ?? 'Unknown';
    final personName = item['person_name'] ?? 'Unknown';
    final remainingQty = double.tryParse(item['remaining_quantity']?.toString() ?? '0') ?? 0;
    final storageRoom = item['storage_room'] ?? item['cold_storage_name'] ?? 'N/A';
    final packagingType = item['packaging_type'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showOutwardDialog(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory,
                  color: Color(0xFFFF9800),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    Text(
                      'Party: $personName',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Available: ${remainingQty.toStringAsFixed(2)} $packagingType',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF999999),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            storageRoom,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF999999),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
