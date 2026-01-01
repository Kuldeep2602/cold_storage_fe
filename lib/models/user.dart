class User {
  const User({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.preferredLanguage,
    this.role,
    required this.isActive,
    required this.createdAt,
  });

  final int id;
  final String phoneNumber;
  final String name;
  final String preferredLanguage;
  final String? role;  // Nullable - null means no role assigned
  final bool isActive;
  final DateTime createdAt;

  /// Check if user has any role assigned
  bool get hasRole => role != null && role!.isNotEmpty;

  /// Check if user is owner
  bool get isOwner => role == 'owner';

  /// Check if user is admin (or superuser)
  bool get isAdmin => role == 'admin';

  /// Check if user is manager
  bool get isManager => role == 'manager';

  /// Check if user is operator
  bool get isOperator => role == 'operator';

  /// Check if user is technician
  bool get isTechnician => role == 'technician';

  /// Check if user has manager-level access (manager, admin, or owner)
  bool get isManagerOrHigher => role == 'manager' || role == 'admin' || role == 'owner';

  /// Check if user has operator-level access (any valid role)
  bool get isOperatorOrHigher => hasRole;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num).toInt(),
      phoneNumber: (json['phone_number'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      preferredLanguage: (json['preferred_language'] as String?) ?? 'en',
      role: json['role'] as String?,  // Keep as null if null
      isActive: (json['is_active'] as bool?) ?? true,
      createdAt: DateTime.tryParse((json['created_at'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone_number': phoneNumber,
        'name': name,
        'preferred_language': preferredLanguage,
        'role': role,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
      };
}
