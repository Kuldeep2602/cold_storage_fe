import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../services/person_service.dart';
import '../../state/app_state.dart';
import '../../widgets/register_party_dialog.dart';

class InwardEntryScreen extends StatefulWidget {
  const InwardEntryScreen({super.key});

  @override
  State<InwardEntryScreen> createState() => _InwardEntryScreenState();
}

class _InwardEntryScreenState extends State<InwardEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _cropNameController = TextEditingController();
  final _cropVarietyController = TextEditingController();
  final _quantityController = TextEditingController();
  final _durationController = TextEditingController();
  
  String? _selectedPersonId;
  String _selectedQualityGrade = 'A';
  String _selectedUnit = 'MT';
  String? _selectedStorageRoom;
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  bool _isLoading = false;

  final List<String> _qualityGrades = ['A', 'B', 'C'];
  final List<String> _units = ['MT', 'Bags', 'Crates'];
  final List<String> _storageRooms = [
    'Room 1',
    'Room 2',
    'Room 3',
    'Room 4',
    'Cold Storage A',
    'Cold Storage B',
  ];

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _saveInwardEntry() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedPersonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a party/farmer')),
      );
      return;
    }
    
    if (_selectedStorageRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a storage room')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appState = context.read<AppState>();
      
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inward entry saved successfully!')),
      );
      
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Green Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Inward Entry',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Stock loading entry',
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
                      foregroundColor: const Color(0xFF4CAF50),
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

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildSection(
                      title: '1. Party / Farmer Selection',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Search Party',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search by name or phone',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () async {
                              // Import at top of file if needed
                              final result = await showDialog<Map<String, dynamic>>(
                                context: context,
                                builder: (context) => RegisterPartyDialog(
                                  onSave: (partyData) async {
                                    try {
                                      final appState = context.read<AppState>();
                                      final personService = PersonService(appState.client);
                                      
                                      final createdPerson = await personService.createPerson(partyData);
                                      
                                      Navigator.pop(context, createdPerson);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  },
                                ),
                              );
                              
                              if (result != null) {
                                setState(() {
                                  _selectedPersonId = result['id'].toString();
                                  _searchController.text = result['name'];
                                });
                                
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Party "${result['name']}" registered successfully!')),
                                );
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Register New Party'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 44),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildSection(
                      title: '2. Crop Details',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Crop Type *',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _cropNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter crop name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Quality Grade (Optional)',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: _qualityGrades.map((grade) {
                              final isSelected = _selectedQualityGrade == grade;
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ChoiceChip(
                                  label: Text('Grade $grade'),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => _selectedQualityGrade = grade);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildSection(
                      title: '3. Quantity Details',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Unit *',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: _units.map((unit) {
                              final isSelected = _selectedUnit == unit;
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ChoiceChip(
                                  label: Text(unit),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => _selectedUnit = unit);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Quantity *',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _quantityController,
                            decoration: InputDecoration(
                              hintText: 'Enter quantity in $_selectedUnit',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildSection(
                      title: '4. Visual Record',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upload Image of Goods',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          if (_selectedImage != null)
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImage!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white),
                                    onPressed: () => setState(() => _selectedImage = null),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SafeArea(
                                    child: Wrap(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Take Photo'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickImage(ImageSource.camera);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo_library),
                                          title: const Text('Choose from Gallery'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickImage(ImageSource.gallery);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE0E0E0), width: 2, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.camera_alt, size: 40, color: Color(0xFF999999)),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tap to capture or upload',
                                      style: TextStyle(color: Color(0xFF666666)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildSection(
                      title: '5. Storage Details',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Storage Room *',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedStorageRoom,
                            decoration: InputDecoration(
                              hintText: 'Select storage room',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: _storageRooms.map((room) {
                              return DropdownMenuItem(
                                value: room,
                                child: Text(room),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedStorageRoom = value),
                            validator: (v) => v == null ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Expected Storage Duration',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _durationController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter duration',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Days'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Entry Date',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _selectDate,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveInwardEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Save Inward Entry',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E88E5),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cropNameController.dispose();
    _cropVarietyController.dispose();
    _quantityController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
