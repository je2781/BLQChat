import 'dart:convert';

import 'package:blq_chat/data/response/user/user.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final UserProfile sender;
  final String type;
  final String? message;
  final int? createdAt;
  final String? channelType;
  final Map<String, dynamic>? attachment;
  final dynamic id;
  final List<UserProfile>? mentionedUsers;
  final int? updatedAt;

  const Chat(this.sender, this.type,
      {this.createdAt,
      this.message,
      this.channelType,
      this.mentionedUsers,
      this.attachment,
      this.id,
      this.updatedAt});

  static List<Chat> fromList(List<dynamic> data) => data
      .map((chatObj) => Chat(
            UserProfile.fromMap(chatObj['user']),
            chatObj['type'],
            createdAt: chatObj['created_at'] ?? 0,
            message: chatObj['message'] ?? '',
            channelType: chatObj['channel_type'],
            updatedAt: chatObj['updated_at'] ?? 0,
            attachment: chatObj['file'] as Map<String, dynamic>?,
            id: chatObj['message_id'] ?? 0,
          ))
      .toList();

  static Chat fromMap(Map<String, dynamic> chatObj) =>
      Chat(UserProfile.fromMap(chatObj['user']), chatObj['type'],
          createdAt: chatObj['created_at'] ?? 0,
          message: chatObj['message'] ?? '',
          channelType: chatObj['channel_type'] ?? false,
          attachment: chatObj['file'] as Map<String, dynamic>?,
          id: chatObj['message_id'] ?? '');

  Map<String, dynamic> toMap() => {
        'created_at': createdAt,
        'message': message,
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
    UserProfile? sender,
    String? message,
    int? createdAt,
    String? receiverType,
    int? deletedAt,
    String? type,
    int? updatedAt,
    List<dynamic>? attachment,
    dynamic id,
  ) {
    return Chat(
      sender ?? this.sender,
      type ?? this.type,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props {
    return [createdAt, sender, message, attachment, updatedAt, id, type];
  }
}
