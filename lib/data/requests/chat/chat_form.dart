import 'dart:convert';
import 'package:equatable/equatable.dart';

class ChatFormModel extends Equatable {
  final String? message;

  const ChatFormModel({
    this.message,
  });

  factory ChatFormModel.fromMap(Map<String, dynamic> data) {
    return ChatFormModel(
      message: data['message'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
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

  ChatFormModel copyEducationWith({
    String? message,
  }) {
    return ChatFormModel(
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props {
    return [
      message,
    ];
  }
}
