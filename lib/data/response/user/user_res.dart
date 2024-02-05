import 'dart:convert';

import 'package:blq_chat/data/response/chat/chat.dart';
import 'package:blq_chat/data/response/user/user.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

class UserRes extends Equatable {
  final User? user;
  final String? message;
  final bool? error;
  final int? statusCode;

  const UserRes({this.message, this.error, this.statusCode, this.user});

  factory UserRes.fromMap(Map<String, dynamic> data) => UserRes(
        message: data['message'] ?? '',
        user: User.fromMap(data),
        error: data['error'] as bool?,
        statusCode: data['statusCode'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'error': error,
        'user': user,
        'status_code': statusCode,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserRes].
  factory UserRes.fromJson(String data) {
    return UserRes.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserRes] to a JSON string.
  String toJson() => json.encode(toMap());

  UserRes copyWith(
      {String? message,
      String? status,
      User? user,
      bool? error,
      int? statusCode}) {
    return UserRes(
        message: message ?? this.message,
        error: error ?? this.error,
        user: user ?? this.user,
        statusCode: statusCode ?? this.statusCode);
  }

  @override
  List<Object?> get props => [message, error, statusCode, user];
}
