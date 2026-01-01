class OutwardEntry {
  const OutwardEntry({
    required this.id,
    required this.inwardEntryId,
    required this.quantity,
    required this.packagingType,
    required this.receiptNumber,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.createdAt,
  });

  final int id;
  final int inwardEntryId;
  final String quantity;
  final String packagingType;
  final String receiptNumber;
  final String paymentStatus;
  final String paymentMethod;
  final DateTime createdAt;

  factory OutwardEntry.fromJson(Map<String, dynamic> json) {
    return OutwardEntry(
      id: (json['id'] as num).toInt(),
      inwardEntryId: (json['inward_entry'] as num).toInt(),
      quantity: (json['quantity'] ?? '').toString(),
      packagingType: (json['packaging_type'] as String?) ?? '',
      receiptNumber: (json['receipt_number'] as String?) ?? '',
      paymentStatus: (json['payment_status'] as String?) ?? '',
      paymentMethod: (json['payment_method'] as String?) ?? '',
      createdAt: DateTime.tryParse((json['created_at'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}
