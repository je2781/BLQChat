import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

class ChatFileModel extends Equatable {
  final String messageType;
  final String? userId;
  final Either<String, List<Map<String, dynamic>>>? files;

  const ChatFileModel(this.messageType, {this.files, this.userId});

  factory ChatFileModel.fromMap(Map<String, dynamic> data) {
    return ChatFileModel(data['message_type'],
        userId: data['user_id'] ?? 0, files: data['file'] ?? data['files']);
  }

  Map<String, dynamic> toMap() =>
      {'files': files, 'user_id': userId, 'message_type': messageType};

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

  ChatFileModel copyEducationWith(
      {String? userId, Either<String, List<Map<String, dynamic>>>? files}) {
    return ChatFileModel(messageType,
        userId: userId ?? this.userId, files: files ?? this.files);
  }

  @override
  List<Object?> get props {
    return [files, messageType, userId];
  }
}
