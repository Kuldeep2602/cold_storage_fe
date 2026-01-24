import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class RegisterPartyDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const RegisterPartyDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<RegisterPartyDialog> createState() => _RegisterPartyDialogState();
}

class _RegisterPartyDialogState extends State<RegisterPartyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _gstController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPartyType = 'farmer';
  bool _isLoading = false;
  Timer? _debounce;

  // Cold storage selection
  List<Map<String, dynamic>> _availableStorages = [];
  int? _selectedColdStorageId;

  @override
  void initState() {
    super.initState();
    _loadAvailableStorages();
  }

  Future<void> _loadAvailableStorages() async {
    try {
      final appState = context.read<AppState>();
      final user = appState.user;

      if (user != null && user.assignedStorages.isNotEmpty) {
        setState(() {
          _availableStorages = user.assignedStorages.map((cs) => {
            'id': cs.id,
            'name': cs.displayName,
          }).toList();

          // Auto-select first storage
          if (_availableStorages.isNotEmpty) {
            _selectedColdStorageId = _availableStorages.first['id'] as int;
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading storages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 720),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E88E5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_add, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n?.registerNewParty ?? 'Register New Party',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: Color(0xFF1E88E5), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n?.quickRegistration ?? 'Quick registration - takes less than 30 seconds',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Name
                    Text(
                      '${l10n?.name ?? "Name"} *',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: l10n?.enterFullName ?? 'Enter full name',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? (l10n?.required ?? 'Required') : null,
                    ),

                    const SizedBox(height: 16),

                    // Phone Number
                    Text(
                      '${l10n?.phoneNumber ?? "Phone Number"} *',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '+91 XXXXX XXXXX',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? (l10n?.required ?? 'Required') : null,
                    ),

                    const SizedBox(height: 16),

                    // Party Type
                    Text(
                      '${l10n?.partyType ?? "Party Type"} *',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildPartyTypeButton(l10n?.farmer ?? 'Farmer', 'farmer', Icons.agriculture),
                        const SizedBox(width: 8),
                        _buildPartyTypeButton(l10n?.traderCompany ?? 'Trader / Co.', 'trader', Icons.store),
                        const SizedBox(width: 8),
                        _buildPartyTypeButton(l10n?.transporter ?? 'Transporter', 'transporter', Icons.local_shipping),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Cold Storage Selection (if multiple available)
                    if (_availableStorages.length > 1) ...[
                      Text(
                        '${l10n?.coldStorage ?? "Cold Storage"} *',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _selectedColdStorageId,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.store_mall_directory),
                        ),
                        items: _availableStorages.map((storage) {
                          return DropdownMenuItem<int>(
                            value: storage['id'] as int,
                            child: Text(storage['name'] as String),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedColdStorageId = value;
                          });
                        },
                        validator: (v) => v == null ? (l10n?.pleaseSelectColdStorage ?? 'Please select a cold storage') : null,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Show selected storage name if only one available
                    if (_availableStorages.length == 1) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF4CAF50)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.store_mall_directory, color: Color(0xFF4CAF50), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${l10n?.storage ?? "Storage"}: ${_availableStorages.first['name']}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Village/City
                    Text(
                      '${l10n?.villageCity ?? "Village / City"} *',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();

                        if (textEditingValue.text.length < 3) {
                          return const Iterable<String>.empty();
                        }

                        final completer = Completer<Iterable<String>>();

                        _debounce = Timer(const Duration(milliseconds: 500), () async {
                          try {
                            final response = await http.get(
                              Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=${textEditingValue.text}&countrycodes=in&limit=5'),
                              headers: {'User-Agent': 'ColdStorageErp/1.0'},
                            );

                            if (response.statusCode == 200) {
                              final List data = json.decode(response.body);
                              if (!completer.isCompleted) {
                                completer.complete(data.map((item) => item['display_name'] as String).toList());
                              }
                            } else {
                              if (!completer.isCompleted) completer.complete([]);
                            }
                          } catch (e) {
                            debugPrint('Error fetching location: $e');
                            if (!completer.isCompleted) completer.complete([]);
                          }
                        });

                        return completer.future;
                      },
                      onSelected: (String selection) {
                        _villageController.text = selection;
                      },
                      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                        // Sync with main controller
                        controller.addListener(() {
                          if (_villageController.text != controller.text) {
                            _villageController.text = controller.text;
                          }
                        });

                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          decoration: InputDecoration(
                            hintText: l10n?.enterVillageOrCity ?? 'Enter village or city name',
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(Icons.location_on, color: Colors.grey),
                          ),
                          validator: (v) => v?.isEmpty ?? true ? (l10n?.required ?? 'Required') : null,
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // GST Number (Optional)
                    Text(
                      l10n?.gstNumberOptional ?? 'GST Number (Optional)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _gstController,
                      decoration: InputDecoration(
                        hintText: '22AAAAA0000A1Z5',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Notes (Optional)
                    Text(
                      l10n?.notesOptional ?? 'Notes (Optional)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: l10n?.addNotes ?? 'Add any additional notes...',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(l10n?.cancel ?? 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveParty,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              l10n?.saveParty ?? 'Save Party',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyTypeButton(String label, String value, IconData icon) {
    final isSelected = _selectedPartyType == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPartyType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE3F2FD) : const Color(0xFFF5F5F5),
            border: Border.all(
              color: isSelected ? const Color(0xFF1E88E5) : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF1E88E5) : Colors.grey,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? const Color(0xFF1E88E5) : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveParty() {
    if (!_formKey.currentState!.validate()) return;

    // Map frontend types to backend types (farmer/vendor)
    String backendType = _selectedPartyType;
    String typeNote = '';

    if (_selectedPartyType == 'trader') {
      backendType = 'vendor';
      typeNote = '\nType: Trader/Company';
    } else if (_selectedPartyType == 'transporter') {
      backendType = 'vendor';
      typeNote = '\nType: Transporter';
    }

    final partyData = {
      'name': _nameController.text.trim(),
      'mobile_number': _phoneController.text.trim(),
      'person_type': backendType,
      'address': '${_villageController.text.trim()}${_gstController.text.isNotEmpty ? '\nGST: ${_gstController.text.trim()}' : ''}${typeNote}${_notesController.text.isNotEmpty ? '\n${_notesController.text.trim()}' : ''}',
      if (_selectedColdStorageId != null) 'cold_storage': _selectedColdStorageId,
    };

    widget.onSave(partyData);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    _gstController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
