import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

class ManagerStaffTab extends StatefulWidget {
  const ManagerStaffTab({super.key});

  @override
  State<ManagerStaffTab> createState() => _ManagerStaffTabState();
}

class _ManagerStaffTabState extends State<ManagerStaffTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _staffMembers = [];

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    setState(() => _isLoading = true);
    try {
      final appState = context.read<AppState>();
      final data = await appState.client.getJson('/api/staff/');
      
      if (mounted && data != null) {
        setState(() {
          _staffMembers = (data as List).cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Use demo data - REMOVED as per user request
        setState(() {
          _staffMembers = [];
        });
      }
    }
  }

  // ... (rest of methods)

  Future<void> _toggleStaffStatus(int id) async {
    try {
      final appState = context.read<AppState>();
      await appState.client.postJson('/api/staff/$id/toggle-status/', {});
      _loadStaff();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteStaff(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Staff Member'),
        content: const Text('Are you sure you want to delete this staff member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final appState = context.read<AppState>();
        await appState.client.deleteJson('/api/staff/$id/'); // Corrected to DELETE
        _loadStaff();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  void _showAddStaffDialog() {
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    String selectedRole = 'operator';
    
    // Check current user role to filter options
    final user = context.read<AppState>().user;
    final currentUserRole = user?.role;
    final isOwnerOrAdmin = currentUserRole == 'owner' || currentUserRole == 'admin';
    
    // Get storages to assign (managers seeing their assigned, owners seeing owned)
    final availableStorages = user?.assignedStorages ?? [];
    // If owner, we might need a different source or assume assignedStorages includes owned for the frontend model
    // For now, relying on assignedStorages being populated.
    
    // Default to selecting all storages
    final Map<int, bool> selectedStorages = {
      for (var storage in availableStorages) storage.id: true
    };

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
                child: const Icon(Icons.person_add, color: Color(0xFF1976D2), size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Add Staff Member'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Phone Number *',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '+91 98765 43210',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Role *',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'operator', child: Text('Inward/Outward Operator')),
                    const DropdownMenuItem(value: 'technician', child: Text('Technician (Temperature)')),
                    if (isOwnerOrAdmin)
                      const DropdownMenuItem(value: 'manager', child: Text('Manager')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedRole = value);
                    }
                  },
                ),
                if (availableStorages.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Assign Storages',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: availableStorages.map((storage) {
                          return CheckboxListTile(
                            title: Text(storage.displayName),
                            subtitle: Text(storage.name),
                            value: selectedStorages[storage.id] ?? false,
                            onChanged: (val) {
                              setDialogState(() {
                                selectedStorages[storage.id] = val ?? false;
                              });
                            },
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Phone number is required')),
                  );
                  return;
                }
                
                final selectedIds = selectedStorages.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList();
                
                try {
                  final appState = context.read<AppState>();
                  await appState.client.postJson('/api/staff/', {
                    'phone_number': phoneController.text,
                    'name': nameController.text,
                    'role': selectedRole,
                    'storage_ids': selectedIds,
                  });
                  Navigator.pop(context);
                  _loadStaff();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Staff member added successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
              ),
              child: const Text('Add Staff'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditStaffDialog(Map<String, dynamic> staff) {
    final phoneController = TextEditingController(text: staff['phone_number']);
    final nameController = TextEditingController(text: staff['name'] ?? '');
    String selectedRole = staff['role'] ?? 'operator';
    
    // Check current user role to filter options
    final currentUserRole = context.read<AppState>().user?.role;
    final isOwnerOrAdmin = currentUserRole == 'owner' || currentUserRole == 'admin';

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
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: Color(0xFF4CAF50), size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Edit Staff Member'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: false, // Phone number cannot be changed usually for ID reasons, or can be if backend supports
                  decoration: InputDecoration(
                    hintText: '+91 98765 43210',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Role *',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'operator', child: Text('Inward/Outward Operator')),
                    const DropdownMenuItem(value: 'technician', child: Text('Technician (Temperature)')),
                    if (isOwnerOrAdmin)
                      const DropdownMenuItem(value: 'manager', child: Text('Manager')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedRole = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final appState = context.read<AppState>();
                  await appState.client.patchJson('/api/staff/${staff['id']}/', {
                    'name': nameController.text,
                    'role': selectedRole,
                  });
                  Navigator.pop(context);
                  _loadStaff();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Staff member updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: const Icon(Icons.people, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Staff Management',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Add and manage storage staff',
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadStaff,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Add Staff Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _showAddStaffDialog,
                              icon: const Icon(Icons.person_add, size: 20),
                              label: const Text('Add Staff Member'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),



                          const SizedBox(height: 20),

                          // Staff Members Header
                          Text(
                            'Staff Members (${_staffMembers.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Staff Members List
                          ..._staffMembers.map((staff) => _buildStaffCard(staff)),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildStaffCard(Map<String, dynamic> staff) {
    final isActive = staff['is_active'] == true;
    final roleDisplay = staff['role_display'] ?? _getRoleDisplay(staff['role']);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Status Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            staff['name'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isActive ? const Color(0xFF333333) : Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFE8F5E9) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isActive ? 'Active' : 'Disabled',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          staff['phone_number'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              roleDisplay,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1976D2),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  _showEditStaffDialog(staff);
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4CAF50),
                  side: const BorderSide(color: Color(0xFF4CAF50)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _toggleStaffStatus(staff['id'] as int),
                icon: Icon(isActive ? Icons.visibility_off : Icons.visibility, size: 16),
                label: Text(isActive ? 'Disable' : 'Enable'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  side: BorderSide(color: Colors.grey[400]!),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _deleteStaff(staff['id'] as int),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRoleDisplay(String? role) {
    switch (role) {
      case 'operator':
        return 'Inward/Outward Operator';
      case 'technician':
        return 'Technician (Temperature)';
      case 'manager':
        return 'Manager';
      case 'admin':
        return 'Admin';
      case 'owner':
        return 'Owner';
      default:
        return role ?? 'No Role';
    }
  }
}
