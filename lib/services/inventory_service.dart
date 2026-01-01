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
    required int qualityRating,
    String rackNumber = '',
    File? imageFile,
  }) {
    final fields = <String, String>{
      'person': personId.toString(),
      'crop_name': cropName,
      'crop_variety': cropVariety,
      'size_grade': sizeGrade,
      'quantity': quantity,
      'packaging_type': packagingType,
      'quality_rating': qualityRating.toString(),
      'rack_number': rackNumber,
    };

    // Backend accepts JSON or multipart/form-data (for image).
    if (imageFile == null) {
      return _api.postJson('/api/inventory/inwards/', {
        'person': personId,
        'crop_name': cropName,
        'crop_variety': cropVariety,
        'size_grade': sizeGrade,
        'quantity': quantity,
        'packaging_type': packagingType,
        'quality_rating': qualityRating,
        'rack_number': rackNumber,
      });
    }

    return _api.postMultipart(
      '/api/inventory/inwards/',
      fields: fields,
      file: imageFile,
      fileField: 'image',
    );
  }

  Future<dynamic> listInwards() => _api.getJson('/api/inventory/inwards/');

  Future<dynamic> fetchStock({int? personId, String? cropName}) {
    final query = <String, String>{};
    if (personId != null) query['person'] = personId.toString();
    if (cropName != null && cropName.isNotEmpty) query['crop'] = cropName;
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
}
