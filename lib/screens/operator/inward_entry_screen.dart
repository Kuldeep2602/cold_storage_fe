import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:typed_data';

import '../../services/person_service.dart';
import '../../state/app_state.dart';
import '../../models/user.dart'; // Add this
import '../../widgets/register_party_dialog.dart';
import '../../services/receipt_service.dart';


class InwardEntryScreen extends StatefulWidget {
  const InwardEntryScreen({super.key});

  @override
  State<InwardEntryScreen> createState() => _InwardEntryScreenState();
}

class _InwardEntryScreenState extends State<InwardEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  TextEditingController? _autocompleteController;
  final _cropNameController = TextEditingController();
  final _cropVarietyController = TextEditingController();
  final _sizeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _durationController = TextEditingController(text: '365'); // Default 365 days
  
  Map<String, dynamic>? _selectedParty;
  String? get _selectedPersonId => _selectedParty?['id']?.toString();
  String _selectedQualityGrade = 'A';
  String _selectedUnit = 'MT';
  String? _selectedStorageRoom;
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  Uint8List? _webImageBytes;
  bool _isLoading = false;

  final List<String> _qualityGrades = ['A', 'B', 'C'];
  final List<String> _units = ['MT', 'Bags', 'Crates'];
  
  List<String> _storageRooms = [];
  int? _assignedColdStorageId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssignedStorage();
    });
  }

  void _loadAssignedStorage() {
    final appState = context.read<AppState>();
    final user = appState.user;
    
    if (user != null && user.assignedStorages.isNotEmpty) {
      if (mounted) {
        setState(() {
            // Default to first storage
            final storage = user.assignedStorages.first;
            _assignedColdStorageId = storage.id;
            _storageRooms = storage.rooms.map((r) => r.roomName).toList();
            _selectedStorageRoom = null; // Reset room selection
        });
      }
    } else {
        if (mounted) {
            setState(() {
                _storageRooms = []; 
                _assignedColdStorageId = null;
            });
        }
    }
  }

  void _onStorageChanged(int? storageId) {
      if (storageId == null) return;
      final appState = context.read<AppState>();
      final user = appState.user;
      
      final storage = user?.assignedStorages.firstWhere((s) => s.id == storageId);
      if (storage != null) {
          setState(() {
              _assignedColdStorageId = storageId;
              _storageRooms = storage.rooms.map((r) => r.roomName).toList();
              _selectedStorageRoom = null;
          });
      }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = File(pickedFile.path);
          _webImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
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

    // Check if cold storage is assigned
    if (_assignedColdStorageId == null) {
        // Try to reload or warn
        // If the user has assignedStorages but state lost?
        final appState = context.read<AppState>();
        if (appState.user?.assignedStorages.isNotEmpty == true) {
             _assignedColdStorageId = appState.user!.assignedStorages.first.id;
        } else {
             ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: No Storage assigned to this operator.')),
             );
             return;
        }
    }

    setState(() => _isLoading = true);

    try {
      final appState = context.read<AppState>();
      
      // Map unit to packaging type
      String packagingType = 'bori';
      if (_selectedUnit == 'Crates') {
        packagingType = 'crate';
      } else if (_selectedUnit == 'Bags') {
        packagingType = 'bori';
      } else {
        packagingType = 'box'; // MT treated as box for now
      }

      // Parse duration
      int? durationDays;
      if (_durationController.text.isNotEmpty) {
        durationDays = int.tryParse(_durationController.text);
      }

      final response = await appState.inventory.createInwardEntry(
        personId: int.parse(_selectedPersonId!),
        cropName: _cropNameController.text.trim(),
        cropVariety: _cropVarietyController.text.trim(),
        sizeGrade: _sizeController.text.trim(),
        quantity: _quantityController.text.trim(),
        packagingType: packagingType,
        qualityGrade: _selectedQualityGrade,
        storageRoom: _selectedStorageRoom!,
        expectedStorageDurationDays: durationDays,
        coldStorageId: _assignedColdStorageId,
        imageFile: _selectedImage,
      );
      
      if (!mounted) return;
      
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Entry Saved'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               const Text('Inward entry has been successfully recorded.'),
               const SizedBox(height: 20),
               SizedBox(
                 width: double.infinity,
                 child: ElevatedButton.icon(
                   icon: const Icon(Icons.download),
                   label: const Text('Download Receipt'),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.blue,
                     foregroundColor: Colors.white,
                   ),
                   onPressed: () {
                      final user = context.read<AppState>().user;
                      final storage = user?.assignedStorages.firstWhere(
                          (s) => s.id == _assignedColdStorageId, 
                          orElse: () => user.assignedStorages.first
                      );

                      ReceiptService.generateInwardReceipt(
                          entryData: {
                              'receipt_number': response['receipt_number'] ?? response['id']?.toString(),
                              'party_name': _selectedParty?['name'],
                              'party_phone': _selectedParty?['mobile_number'],
                              'crop_name': _cropNameController.text,
                              'quantity': _quantityController.text,
                              'unit': _selectedUnit,
                              'room': _selectedStorageRoom,
                              'variety': _cropVarietyController.text,
                              'grade': _selectedQualityGrade,
                          },
                          storageName: storage?.displayName ?? 'Storage',
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
                  Navigator.pop(context, true); // Close screen
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
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
                      children: [
                        const Text(
                          'Inward Entry',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                         // Display assigned storage name check
                        if (_assignedColdStorageId != null)
                             // We don't have name handy easily unless we store the object.
                             // But it's fine.
                             const SizedBox.shrink(),
                        const Text(
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
                          Row(
                            children: [
                              Expanded(
                                child: Autocomplete<Map<String, dynamic>>(
                                  optionsBuilder: (TextEditingValue textEditingValue) async {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<Map<String, dynamic>>.empty();
                                    }
                                    try {
                                      return await context.read<AppState>().persons.searchPersons(textEditingValue.text);
                                    } catch (e) {
                                      debugPrint('Search error: $e');
                                      return const Iterable<Map<String, dynamic>>.empty();
                                    }
                                  },
                                  displayStringForOption: (option) => option['name'] ?? '',
                                  onSelected: (Map<String, dynamic> selection) {
                                    setState(() {
                                      _selectedParty = selection;
                                      _searchController.text = selection['name'];
                                    });
                                  },
                                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                    _autocompleteController = controller;
                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      onEditingComplete: onEditingComplete,
                                      decoration: InputDecoration(
                                        hintText: 'Search by name or phone',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    );
                                  },
                                  optionsViewBuilder: (context, onSelected, options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(maxHeight: 200, maxWidth: MediaQuery.of(context).size.width - 72),
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              final option = options.elementAt(index);
                                              return ListTile(
                                                title: Text(option['name'] ?? 'Unknown'),
                                                subtitle: Text(option['mobile_number'] ?? 'No phone'),
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Dropdown button to show all parties
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_drop_down, size: 28),
                                  tooltip: 'View all parties',
                                  onPressed: () async {
                                    try {
                                      final appState = context.read<AppState>();
                                      final allParties = await appState.persons.searchPersons('');
                                      
                                      if (!mounted) return;
                                      
                                      if (allParties.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No parties found')),
                                        );
                                        return;
                                      }
                                      
                                      final selected = await showDialog<Map<String, dynamic>>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Select Party'),
                                          content: SizedBox(
                                            width: double.maxFinite,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: allParties.length,
                                              itemBuilder: (context, index) {
                                                final party = allParties.elementAt(index);
                                                return ListTile(
                                                  leading: CircleAvatar(
                                                    child: Text(
                                                      (party['name'] ?? 'U').substring(0, 1).toUpperCase(),
                                                    ),
                                                  ),
                                                  title: Text(party['name'] ?? 'Unknown'),
                                                  subtitle: Text(party['mobile_number'] ?? 'No phone'),
                                                  onTap: () => Navigator.pop(context, party),
                                                );
                                              },
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        ),
                                      );
                                      
                                      if (selected != null) {
                                        setState(() {
                                          _selectedParty = selected;
                                          _autocompleteController?.text = selected['name'];
                                        });
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error loading parties: $e')),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
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
                                  _selectedParty = result;
                                  _autocompleteController?.text = result['name'];
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
                          const SizedBox(height: 12),
                          const Text(
                            'Size (Optional)',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _sizeController,
                            decoration: InputDecoration(
                              hintText: 'e.g. Small, Medium, Large, 45mm',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
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
                                    child: _webImageBytes != null
                                        ? Image.memory(
                                            _webImageBytes!,
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            height: 200,
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.image, size: 50, color: Colors.grey),
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
                          if ((context.watch<AppState>().user?.assignedStorages.length ?? 0) > 1) ...[
                              const Text(
                                'Storage Facility *',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                value: _assignedColdStorageId,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                                items: context.read<AppState>().user!.assignedStorages.map((s) {
                                    return DropdownMenuItem(
                                        value: s.id,
                                        child: Text(s.displayName),
                                    );
                                }).toList(),
                                onChanged: _onStorageChanged,
                              ),
                              const SizedBox(height: 12),
                          ],

                          const Text(
                            'Storage Room *',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          if (_storageRooms.isEmpty)
                             const Text(
                               'No storage rooms available for your assigned facility. Please contact manager.',
                               style: TextStyle(color: Colors.red),
                             )
                          else
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
                            'Storage Duration',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                children: [
                                  ChoiceChip(
                                    label: const Text('60 Days'),
                                    selected: _durationController.text == '60',
                                    onSelected: (selected) {
                                      if (selected) setState(() => _durationController.text = '60');
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('90 Days'),
                                    selected: _durationController.text == '90',
                                    onSelected: (selected) {
                                      if (selected) setState(() => _durationController.text = '90');
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('1 Year'),
                                    selected: _durationController.text == '365',
                                    onSelected: (selected) {
                                      if (selected) setState(() => _durationController.text = '365');
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _durationController,
                                      enabled: true, // Allow manual input
                                      decoration: InputDecoration(
                                        hintText: 'Enter days',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => setState(() {}), // rebuild to update chips
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('Days'),
                                ],
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
