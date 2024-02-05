import 'dart:convert';

import 'package:blq_chat/data/response/chat/chat.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

class ChatRes extends Equatable {
  final List<Chat>? chats;
  final String? message;
  final bool? error;
  final int? statusCode;

  const ChatRes({this.chats, this.message, this.error, this.statusCode});

  factory ChatRes.fromMap(Map<String, dynamic> data) => ChatRes(
        message: data['message'] ?? '',
        chats: Chat.fromList(data['messages']),
        error: data['error'] as bool?,
        statusCode: data['statusCode'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'chats': chats,
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
      {List<Chat>? chats,
      String? message,
      String? status,
      bool? error,
      int? statusCode}) {
    return ChatRes(
        message: message ?? this.message,
        chats: chats ?? this.chats,
        error: error ?? this.error,
        statusCode: statusCode ?? this.statusCode);
  }

  @override
  List<Object?> get props => [message, chats, error, statusCode];
}
