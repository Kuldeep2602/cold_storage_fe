class InwardEntry {
  const InwardEntry({
    required this.id,
    required this.personId,
    required this.cropName,
    required this.cropVariety,
    required this.sizeGrade,
    required this.quantity,
    required this.packagingType,
    required this.qualityRating,
    required this.image,
    required this.rackNumber,
    required this.createdAt,
    required this.remainingQuantity,
  });

  final int id;
  final int personId;
  final String cropName;
  final String cropVariety;
  final String sizeGrade;
  final String quantity;
  final String packagingType;
  final int qualityRating;
  final String? image;
  final String rackNumber;
  final DateTime createdAt;
  final String remainingQuantity;

  factory InwardEntry.fromJson(Map<String, dynamic> json) {
    return InwardEntry(
      id: (json['id'] as num).toInt(),
      personId: (json['person'] as num).toInt(),
      cropName: (json['crop_name'] as String?) ?? '',
      cropVariety: (json['crop_variety'] as String?) ?? '',
      sizeGrade: (json['size_grade'] as String?) ?? '',
      quantity: (json['quantity'] ?? '').toString(),
      packagingType: (json['packaging_type'] as String?) ?? '',
      qualityRating: (json['quality_rating'] as num?)?.toInt() ?? 0,
      image: (json['image'] as String?),
      rackNumber: (json['rack_number'] as String?) ?? '',
      createdAt: DateTime.tryParse((json['created_at'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      remainingQuantity: (json['remaining_quantity'] ?? '').toString(),
    );
  }
}
