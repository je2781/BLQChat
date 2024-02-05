import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? profileUrl;
  final String? name;
  final bool? isActive;
  final String? role;
  final String? id;

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
          id: userObj['user_id'] ?? '',
          role: userObj['role'] ?? '',
          isActive: userObj['is_active'] ?? false,
          name: userObj['nickname']))
      .toList();

  static User fromMap(Map<String, dynamic> userObj) => User(
      profileUrl: userObj['profile_url'] ?? '',
      name: userObj['nickname'] ?? '',
      isActive: userObj['is_active'] ?? false,
      role: userObj['role'] ?? '',
      id: userObj['user_id'] ?? '');

  User copyWith(
    String? profileUrl,
    String? name,
    bool? isActive,
    String? role,
    String? id,
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
