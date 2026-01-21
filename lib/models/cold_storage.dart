class StorageRoom {
  const StorageRoom({
    required this.id,
    required this.roomName,
    this.capacity,
    this.description = '',
  });

  final int id;
  final String roomName;
  final double? capacity;
  final String description;

  factory StorageRoom.fromJson(Map<String, dynamic> json) {
    return StorageRoom(
      id: (json['id'] as num).toInt(),
      roomName: (json['room_name'] as String?) ?? '',
      capacity: json['capacity'] != null ? (json['capacity'] as num).toDouble() : null,
      description: (json['description'] as String?) ?? '',
    );
  }
}

class ColdStorageSummary {
  const ColdStorageSummary({
    required this.id,
    required this.name,
    required this.code,
    required this.displayName,
    required this.city,
    required this.rooms,
  });

  final int id;
  final String name;
  final String code;
  final String displayName;
  final String city;
  final List<StorageRoom> rooms;

  factory ColdStorageSummary.fromJson(Map<String, dynamic> json) {
    return ColdStorageSummary(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
      code: (json['code'] as String?) ?? '',
      displayName: (json['display_name'] as String?) ?? '',
      city: (json['city'] as String?) ?? '',
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((e) => StorageRoom.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
