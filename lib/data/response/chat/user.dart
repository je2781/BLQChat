import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? profileUrl;
  final String? name;
  final bool? isActive;
  final String? role;
  final int? id;

  const User({
    this.profileUrl,
    this.name,
    this.isActive,
    this.role,
    this.id,
  });

  static List<User> fromList(List<dynamic> data) => data
      .map((userObj) => User(
          profileUrl: userObj['profile_url'] ?? '',
          id: userObj['user_id'] ?? 0,
          role: userObj['role'] ?? '',
          isActive: userObj['is_active'] ?? false,
          name: userObj['nickname']))
      .toList();

  Map<String, dynamic> toMap() => {
        'profile_url': profileUrl,
        'name': name,
        'is_active': isActive,
        'role': role,
        'id': id,
      };

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  User copyWith(
    String? profileUrl,
    String? name,
    bool? isActive,
    String? role,
    int? id,
  ) {
    return User(
        profileUrl: profileUrl ?? this.profileUrl,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        id: id ?? this.id,
        role: role ?? this.role);
  }

  @override
  List<Object?> get props {
    return [profileUrl, name, id, isActive, role];
  }
}
