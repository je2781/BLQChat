import 'dart:convert';

import 'package:blq_chat/data/response/chat/user.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String? name;
  final User sender;
  final String type;
  final String? message;
  final DateTime? createdAt;
  final String? channelType;
  final Map<String, dynamic>? attachment;
  final int? id;
  final List<User>? mentionedUsers;
  final DateTime? updatedAt;

  const Chat(this.sender, this.type,
      {this.createdAt,
      this.message,
      this.name,
      this.channelType,
      this.mentionedUsers,
      this.attachment,
      this.id,
      this.updatedAt});

  static List<Chat> fromList(List<dynamic> data) => data
      .map((chatObj) => Chat(
            chatObj['user'],
            chatObj['type'],
            createdAt: DateTime.tryParse(
                chatObj['created_at'] ?? DateTime.now().toIso8601String()),
            message: chatObj['message'] ?? '',
            channelType: chatObj['channel_type'],
            updatedAt: DateTime.tryParse(
                chatObj['updated_at'] ?? DateTime.now().toIso8601String()),
            attachment: chatObj['file'] as Map<String, dynamic>?,
            id: chatObj['message_id'] ?? 0,
          ))
      .toList();

  Map<String, dynamic> toMap() => {
        'created_at': createdAt,
        'message': message,
        'name': name,
        'id': id,
        'attachment': attachment,
        'updated_at': updatedAt,
        'user': sender,
        'type': type
      };

  /// `dart:convert`
  ///
  /// Converts [Chat] to a JSON string.
  String toJson() => json.encode(toMap());

  Chat copyWith(
    String? name,
    User? sender,
    String? message,
    DateTime? createdAt,
    String? receiverType,
    DateTime? deletedAt,
    String? type,
    DateTime? updatedAt,
    List<dynamic>? attachment,
    int? id,
  ) {
    return Chat(
      sender ?? this.sender,
      type ?? this.type,
      name: name ?? this.name,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props {
    return [createdAt, sender, message, name, attachment, updatedAt, id, type];
  }
}
