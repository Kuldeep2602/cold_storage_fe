import 'dart:io';

import 'api_client.dart';

class InventoryService {
  InventoryService(this._api);

  final ApiClient _api;

  Future<dynamic> listPersons() => _api.getJson('/api/inventory/persons/');

  Future<Map<String, dynamic>> createPerson({
    required String personType, // farmer|vendor
    required String name,
    required String mobileNumber,
    String address = '',
  }) {
    return _api.postJson('/api/inventory/persons/', {
      'person_type': personType,
      'name': name,
      'mobile_number': mobileNumber,
      'address': address,
    });
  }

  Future<dynamic> findPersonByMobile(String mobileNumber) {
    return _api.getJson('/api/inventory/persons/by-mobile/', query: {
      'mobile_number': mobileNumber,
    });
  }

  Future<Map<String, dynamic>> createInwardEntry({
    required int personId,
    required String cropName,
    String cropVariety = '',
    String sizeGrade = '',
    required String quantity,
    required String packagingType, // bori|crate|box
    String qualityGrade = 'A',
    String rackNumber = '',
    String storageRoom = '',
    int? expectedStorageDurationDays,
    int? coldStorageId,
    File? imageFile,
  }) {
    final body = <String, dynamic>{
      'person': personId,
      'crop_name': cropName,
      'crop_variety': cropVariety,
      'size_grade': sizeGrade,
      'quantity': quantity,
      'packaging_type': packagingType,
      'quality_grade': qualityGrade,
      'rack_number': rackNumber,
      'storage_room': storageRoom,
    };
    
    if (expectedStorageDurationDays != null) {
      body['expected_storage_duration_days'] = expectedStorageDurationDays;
    }
    if (coldStorageId != null) {
      body['cold_storage'] = coldStorageId;
    }

    // Backend accepts JSON or multipart/form-data (for image).
    if (imageFile == null) {
      return _api.postJson('/api/inventory/inwards/', body);
    }

    final fields = body.map((k, v) => MapEntry(k, v.toString()));
    return _api.postMultipart(
      '/api/inventory/inwards/',
      fields: fields,
      file: imageFile,
      fileField: 'image',
    );
  }

  Future<dynamic> listInwards() => _api.getJson('/api/inventory/inwards/');

  Future<dynamic> fetchStock({
    int? personId, 
    String? cropName, 
    int? coldStorageId,
    String? search,
  }) {
    final query = <String, String>{};
    if (personId != null) query['person'] = personId.toString();
    if (cropName != null && cropName.isNotEmpty) query['crop'] = cropName;
    if (coldStorageId != null) query['cold_storage'] = coldStorageId.toString();
    if (search != null && search.isNotEmpty) query['search'] = search;
    return _api.getJson('/api/inventory/inwards/stock/', query: query);
  }

  Future<Map<String, dynamic>> createOutwardEntry({
    required int inwardEntryId,
    required String quantity,
    required String packagingType,
    String paymentMethod = '',
  }) {
    return _api.postJson('/api/inventory/outwards/', {
      'inward_entry': inwardEntryId,
      'quantity': quantity,
      'packaging_type': packagingType,
      'payment_method': paymentMethod,
    });
  }

  Future<dynamic> listOutwards() => _api.getJson('/api/inventory/outwards/');

  Future<dynamic> getReceipt(int outwardId) {
    return _api.getJson('/api/inventory/outwards/$outwardId/receipt/');
  }

  Future<Map<String, dynamic>> triggerPayment(int outwardId, {String method = ''}) {
    return _api.postJson('/api/inventory/outwards/$outwardId/trigger-payment/', {
      'payment_method': method,
    });
  }

  /// Get manager dashboard data including assigned cold storage
  Future<Map<String, dynamic>> getManagerDashboard({int? coldStorageId}) async {
    final query = <String, String>{};
    if (coldStorageId != null) query['cold_storage'] = coldStorageId.toString();
    final result = await _api.getJson('/api/inventory/manager-dashboard/', query: query);
    return (result as Map).cast<String, dynamic>();
  }
}

