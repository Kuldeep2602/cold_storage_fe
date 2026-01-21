import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

class OwnerStaffTab extends StatefulWidget {
  const OwnerStaffTab({super.key});

  @override
  State<OwnerStaffTab> createState() => _OwnerStaffTabState();
}

class _OwnerStaffTabState extends State<OwnerStaffTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _allStaff = [];

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
          _allStaff = (data as List).cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        debugPrint('Staff load error: $e');
        setState(() {
          _isLoading = false;
          _allStaff = []; // Empty list on error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading staff: $e')),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getStaffByRole(String role) {
    return _allStaff.where((s) => s['role'] == role).toList();
  }

  void _showAddStaffDialog() {
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    String selectedRole = 'manager';
    // Initialize selected ids - default to all for convenience? Or none?
    // Let's default to all
    final user = context.read<AppState>().user;
    final Set<int> _selectedStorageIds = {};
    if (user != null) {
        _selectedStorageIds.addAll(user.assignedStorages.map((e) => e.id));
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
                  'Name *',
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
                
                // Role selection as cards
                _buildRoleOption(
                  setDialogState: setDialogState,
                  currentRole: selectedRole,
                  role: 'manager',
                  title: 'Manager',
                  subtitle: 'Full access to manage storages, staff & inventory',
                  icon: Icons.admin_panel_settings,
                  color: const Color(0xFF1976D2),
                  onSelect: () => setDialogState(() => selectedRole = 'manager'),
                ),
                const SizedBox(height: 10),
                _buildRoleOption(
                  setDialogState: setDialogState,
                  currentRole: selectedRole,
                  role: 'operator',
                  title: 'Operator',
                  subtitle: 'Inward/Outward operations only',
                  icon: Icons.work,
                  color: const Color(0xFF4CAF50),
                  onSelect: () => setDialogState(() => selectedRole = 'operator'),
                ),
                const SizedBox(height: 10),
                _buildRoleOption(
                  setDialogState: setDialogState,
                  currentRole: selectedRole,
                  role: 'technician',
                  title: 'Technician',
                  subtitle: 'Temperature monitoring & alerts',
                  icon: Icons.thermostat,
                  color: const Color(0xFFFF9800),
                  onSelect: () => setDialogState(() => selectedRole = 'technician'),
                ),

                if (context.read<AppState>().user?.assignedStorages.isNotEmpty ?? false) ...[
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
                    child: StatefulBuilder(
                        builder: (context, setState) { // Local state for checkboxes
                          final storages = context.read<AppState>().user!.assignedStorages;
                          return Column(
                            children: storages.map((storage) {
                              return CheckboxListTile(
                                title: Text(storage.displayName),
                                subtitle: Text(storage.name),
                                value: _selectedStorageIds.contains(storage.id),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                        _selectedStorageIds.add(storage.id);
                                    } else {
                                        _selectedStorageIds.remove(storage.id);
                                    }
                                  });
                                  // Update the main dialog state if needed (though local list is enough)
                                },
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                              );
                            }).toList(),
                          );
                        }
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
                if (phoneController.text.isEmpty || nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Phone number and name are required')),
                  );
                  return;
                }
                
                try {
                  final appState = context.read<AppState>();
                  await appState.client.postJson('/api/staff/', {
                    'phone_number': phoneController.text,
                    'name': nameController.text,
                    'role': selectedRole,
                    'storage_ids': _selectedStorageIds.toList(),
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

  Widget _buildRoleOption({
    required void Function(void Function()) setDialogState,
    required String currentRole,
    required String role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onSelect,
  }) {
    final isSelected = currentRole == role;
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: isSelected ? color : Colors.grey[600], size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.grey[800],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color, size: 22),
          ],
        ),
      ),
    );
  }

  void _showEditStaffDialog(Map<String, dynamic> staff) {
    final nameController = TextEditingController(text: staff['name'] ?? '');
    String selectedRole = staff['role']?.toString() ?? 'operator';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Staff Member'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone: ${staff['phone_number'] ?? ''}',
                  style: TextStyle(
                    fontSize: 14, 
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
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
                  'Role',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                
                _buildRoleOption(
                  setDialogState: setDialogState,
                  currentRole: selectedRole,
                  role: 'manager',
                  title: 'Manager',
                  subtitle: 'Full access',
                  icon: Icons.admin_panel_settings,
                  color: const Color(0xFF1976D2),
                  onSelect: () => setDialogState(() => selectedRole = 'manager'),
                ),
                const SizedBox(height: 8),
                _buildRoleOption(
                  setDialogState: setDialogState,
                  currentRole: selectedRole,
                  role: 'operator',
                  title: 'Operator',
                  subtitle: 'Inward/Outward',
                  icon: Icons.work,
                  color: const Color(0xFF4CAF50),
                  onSelect: () => setDialogState(() => selectedRole = 'operator'),
                ),
                const SizedBox(height: 8),
                _buildRoleOption(
                  setDialogState: setDialogState,
                  currentRole: selectedRole,
                  role: 'technician',
                  title: 'Technician',
                  subtitle: 'Temperature',
                  icon: Icons.thermostat,
                  color: const Color(0xFFFF9800),
                  onSelect: () => setDialogState(() => selectedRole = 'technician'),
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
                  await appState.client.patchJson(
                    '/api/staff/${staff['id']}/',
                    {
                      'name': nameController.text,
                      'role': selectedRole
                    },
                  );
                  Navigator.pop(context);
                  _loadStaff();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Staff updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2)),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final managers = _getStaffByRole('manager');
    final operators = _getStaffByRole('operator');
    final technicians = _getStaffByRole('technician');

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
                          'Manage managers & staff',
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
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
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
                              label: const Text('Add New Staff Member'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Managers Section
                          _buildStaffSection(
                            title: 'Managers',
                            subtitle: 'Can manage storage operations',
                            icon: Icons.admin_panel_settings,
                            iconColor: const Color(0xFF1976D2),
                            staff: managers,
                          ),

                          const SizedBox(height: 20),

                          // Operators Section
                          _buildStaffSection(
                            title: 'Operators',
                            subtitle: 'Inward/Outward operations',
                            icon: Icons.work,
                            iconColor: const Color(0xFF4CAF50),
                            staff: operators,
                          ),

                          const SizedBox(height: 20),

                          // Technicians Section
                          _buildStaffSection(
                            title: 'Technicians',
                            subtitle: 'Temperature monitoring',
                            icon: Icons.thermostat,
                            iconColor: const Color(0xFFFF9800),
                            staff: technicians,
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

  Widget _buildStaffSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required List<Map<String, dynamic>> staff,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title (${staff.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (staff.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No ${title.toLowerCase()} added yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...staff.map((s) => _buildStaffCard(s, iconColor)),
      ],
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> staff, Color accentColor) {
    final isActive = staff['is_active'] == true;
    final name = staff['name']?.toString() ?? 'Unknown';
    final phone = staff['phone_number']?.toString() ?? '';
    
    // Safe first character - handle empty or null name
    String firstChar = 'U';
    if (name.isNotEmpty) {
      firstChar = name.substring(0, 1).toUpperCase();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                firstChar,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isActive ? const Color(0xFF333333) : Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFE8F5E9) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Disabled',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Action buttons
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey[600]),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
                value: 'toggle',
                child: Text(isActive ? 'Disable' : 'Enable'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (value) async {
              if (value == 'edit') {
                _showEditStaffDialog(staff);
              } else if (value == 'toggle') {
                try {
                  final appState = context.read<AppState>();
                  await appState.client.postJson(
                    '/api/staff/${staff['id']}/toggle-status/',
                    {},
                  );
                  _loadStaff();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              } else if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Staff?'),
                    content: Text(
                      'Are you sure you want to delete ${staff['name']}? This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    final appState = context.read<AppState>();
                    await appState.client.deleteJson('/api/staff/${staff['id']}/');
                    _loadStaff();
                     if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Staff member deleted successfully')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error deleting staff: $e')),
                      );
                    }
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
