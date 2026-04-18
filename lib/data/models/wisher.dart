/// Represents a wisher - someone special in a user's life.
///
/// Wishers are associated with a specific user and contain basic
/// profile information like name and optional profile picture.
class Wisher {
  Wisher({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.updatedAt,
    this.profilePicture,
  }) : assert(
         firstName.trim().isNotEmpty || lastName.trim().isNotEmpty,
         'At least one of firstName or lastName must be non-empty.',
       );

  /// Creates a Wisher from a JSON map (from Supabase)
  factory Wisher.fromJson(Map<String, dynamic> json) => Wisher(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    profilePicture: json['profile_picture'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  /// Unique identifier for the wisher
  final String id;

  /// ID of the user who owns this wisher
  final String userId;

  /// Wisher's first name
  final String firstName;

  /// Wisher's last name
  final String lastName;

  /// Optional URL to the wisher's profile picture
  final String? profilePicture;

  /// When this wisher was created
  final DateTime createdAt;

  /// When this wisher was last updated
  final DateTime updatedAt;

  /// Convenience getter for a display-safe full name.
  String get name => [
    firstName,
    lastName,
  ].map((part) => part.trim()).where((part) => part.isNotEmpty).join(' ');

  /// Convenience getter for display initial.
  String get initial {
    final firstAvailableNamePart = [firstName, lastName]
        .map((part) => part.trim())
        .firstWhere((part) => part.isNotEmpty, orElse: () => '');

    return firstAvailableNamePart.isEmpty
        ? ''
        : firstAvailableNamePart[0].toUpperCase();
  }

  /// Converts Wisher to a JSON map (for Supabase)
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'first_name': firstName,
    'last_name': lastName,
    'profile_picture': profilePicture,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Creates a copy with updated fields
  Wisher copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Wisher(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profilePicture: profilePicture ?? this.profilePicture,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Wisher && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Wisher(id: $id, name: $name)';
}
