import 'dart:convert';

import 'package:equatable/equatable.dart';
import './chat.dart';

class Messages extends Equatable {
  final List<Chat>? chats;

  const Messages({this.chats});

  factory Messages.fromList(List<dynamic> data) => Messages(
        chats: Chat.fromList(data),
      );

  Map<String, dynamic> toMap() => {
        'chats': chats,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Messages].
  // factory Messages.fromJson(String data) {
  //   return Messages.fromMap(json.decode(data) as Map<String, dynamic>);
  // }

  /// `dart:convert`
  ///
  /// Converts [Messages] to a JSON string.
  String toJson() => json.encode(toMap());

  Messages copyWith({List<Chat>? chats}) {
    return Messages(chats: chats ?? this.chats);
  }

  @override
  List<Object?> get props {
    return [
      chats,
    ];
  }
}
