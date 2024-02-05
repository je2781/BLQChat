import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

class ChatFormModel extends Equatable {
  final String? message;
  final String messageType;
  final int? userId;
  final Either<String, List<Map<String, dynamic>>>? files;

  const ChatFormModel(this.messageType,
      {this.message, this.files, this.userId});

  factory ChatFormModel.fromMap(Map<String, dynamic> data) {
    return ChatFormModel(data['message_type'],
        message: data['message'] as String?,
        userId: data['user_id'] ?? 0,
        files: data['file'] ?? data['files']);
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'files': files,
        'user_id': userId,
        'message_type': messageType
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChatFormModel].
  factory ChatFormModel.fromJson(String data) {
    return ChatFormModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChatFormModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ChatFormModel copyEducationWith(
      {String? message,
      int? userId,
      Either<String, List<Map<String, dynamic>>>? files}) {
    return ChatFormModel(messageType,
        message: message ?? this.message,
        userId: userId ?? this.userId,
        files: files ?? this.files);
  }

  @override
  List<Object?> get props {
    return [message, files, messageType, userId];
  }
}
