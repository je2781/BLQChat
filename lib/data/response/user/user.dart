import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String? profileUrl;
  final String? name;
  final bool? isActive;
  final String? role;
  final String? id;

  const UserProfile({
    this.profileUrl,
    this.name,
    this.isActive,
    this.role,
    this.id,
  });

  static List<UserProfile> fromList(List<dynamic> data) => data
      .map((userObj) => UserProfile(
          profileUrl: userObj['profile_url'] ?? '',
          id: userObj['user_id'] ?? '',
          role: userObj['role'] ?? '',
          isActive: userObj['is_active'] ?? false,
          name: userObj['nickname']))
      .toList();

  static UserProfile fromMap(Map<String, dynamic> userObj) => UserProfile(
      profileUrl: userObj['profile_url'] ?? '',
      name: userObj['nickname'] ?? '',
      isActive: userObj['is_active'] ?? false,
      role: userObj['role'] ?? '',
      id: userObj['user_id'] ?? '');

  Map<String, dynamic> toMap() => {
        'nickname': name,
        'user_id': id,
        'profile_url': profileUrl,
      };

  UserProfile copyWith(
    String? profileUrl,
    String? name,
    bool? isActive,
    String? role,
    String? id,
  ) {
    return UserProfile(
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
