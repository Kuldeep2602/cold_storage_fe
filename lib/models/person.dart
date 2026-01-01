class Person {
  const Person({
    required this.id,
    required this.personType,
    required this.name,
    required this.mobileNumber,
    required this.address,
    required this.createdAt,
  });

  final int id;
  final String personType;
  final String name;
  final String mobileNumber;
  final String address;
  final DateTime createdAt;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: (json['id'] as num).toInt(),
      personType: (json['person_type'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      mobileNumber: (json['mobile_number'] as String?) ?? '',
      address: (json['address'] as String?) ?? '',
      createdAt: DateTime.tryParse((json['created_at'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}
