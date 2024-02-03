import 'dart:developer';

import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/data/repository/chat/chat_repo.dart';
import 'package:blq_chat/data/requests/chat/chat_form.dart';
import 'package:flutter/material.dart';

class ChatViewModel with ChangeNotifier {
  bool isLoading = false;
  bool sentChat = false;
  ChatRepo? chatRepo;

  Future<bool> sendChatRequest(
      Map<String, dynamic> chatFormData, BuildContext context) async {
    isLoading = true;

    log('This is the token gotten from env variables');
    const String apiToken = String.fromEnvironment('Api-token');

    chatRepo = ChatRepo(apiToken);

    final ChatFormModel chatFormModel =
        ChatFormModel(message: chatFormData['message']);

    try {
      // log('Attempting to send chat');
      final result = await chatRepo!.sendChat(chatFormModel);
      if (result.isLeft) {
        log('sending chat failed: ${result.left.message!['message']}');

        handleError('sending chat failed!');
      } else {
        // log('sending chat successful');
        sentChat = true;
      }
    } catch (ex, trace) {
      log('Exception caught : $ex, with strace: $trace');
      toastMessage(ex.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return sentChat;
  }

  void handleError(dynamic data) {
    if (data is Map<String, dynamic>) {
      toastMessage(
        data['message'],
        long: true,
      );
    } else if (data is String) {
      toastMessage(
        data,
        long: true,
      );
    } else if (data is List) {
      for (var error in data) {
        toastMessage(
          error,
          long: true,
        );
      }
    } else {
      toastMessage(
        data.toString(),
        long: true,
      );
    }
  }
}
