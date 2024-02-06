import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

class ChatFileModel extends Equatable {
  final String messageType;
  final String? userId;
  final String? file;

  const ChatFileModel(this.messageType, {this.file, this.userId});

  factory ChatFileModel.fromMap(Map<String, dynamic> data) {
    return ChatFileModel(data['message_type'],
        userId: data['user_id'] ?? 0, file: data['file']);
  }

  Map<String, dynamic> toMap() =>
      {'file': file, 'user_id': userId, 'message_type': messageType};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChatFileModel].
  factory ChatFileModel.fromJson(String data) {
    return ChatFileModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChatFileModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ChatFileModel copyEducationWith({String? userId, String? file}) {
    return ChatFileModel(messageType,
        userId: userId ?? this.userId, file: file ?? this.file);
  }

  @override
  List<Object?> get props {
    return [file, messageType, userId];
  }
}
