import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import './message.dart';

class ChatRes extends Equatable {
  final Messages? messages;
  final String? message;
  final bool? error;
  final int? statusCode;

  const ChatRes({this.messages, this.message, this.error, this.statusCode});

  factory ChatRes.fromMap(Map<String, dynamic> data) => ChatRes(
        message: data['message'] ?? '',
        messages: data['messages'] as Messages?,
        error: data['error'] as bool?,
        statusCode: data['statusCode'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'messages': messages,
        'error': error,
        'status_code': statusCode,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChatRes].
  factory ChatRes.fromJson(String data) {
    return ChatRes.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChatRes] to a JSON string.
  String toJson() => json.encode(toMap());

  ChatRes copyWith(
      {Messages? messages,
      String? message,
      String? status,
      bool? error,
      int? statusCode}) {
    return ChatRes(
        message: message ?? this.message,
        messages: messages ?? this.messages,
        error: error ?? this.error,
        statusCode: statusCode ?? this.statusCode);
  }

  @override
  List<Object?> get props => [message, messages, error, statusCode];
}
