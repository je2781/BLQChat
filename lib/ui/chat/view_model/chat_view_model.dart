import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:blq_chat/data/response/chat/chat.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';
import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/data/repository/chat/chat_repo.dart';
import 'package:blq_chat/data/requests/chat/chat_form.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool sentChat = false;
  bool sentFile = true;
  ChatRepo? chatRepo;

  //Document upload
  FilePickerResult? fileUploads;

  List<String> fileNames = [];
  List<String> filePaths = [];
  List<Map<String, dynamic>> multipartFiles = [];

  List<double> fileSizes = [];

  List<Chat> _savedChats = [];

  List<Chat> get chats => [..._savedChats];

  Future<void> pickFiles() async {
    fileUploads = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );
    if (fileUploads != null) {
      for (var i = 0; i < fileUploads!.files.length; i++) {
        fileNames.add(fileUploads!.files[i].name);
        fileSizes.add((fileUploads!.files[i].size / 1024) / 1024);

        if (fileSizes[i] > 5.0) {
          log('file(s) have exceeded file size limit');
          toastMessage("File(s) have exceeded 5MB", long: true);
          return;
        }

        filePaths.add(fileUploads!.paths[i]!);

        multipartFiles.add({fileNames[i]: filePaths[i]});
      }
    }
    notifyListeners();
  }

  Future<bool> sendChatRequest(
      Map<String, dynamic> chatFormData, BuildContext context) async {
    isLoading = true;

    log('This is the token gotten from env variables');
    const String apiToken = String.fromEnvironment('Api-token');

    chatRepo = ChatRepo(apiToken);

    try {
      if (filePaths.isNotEmpty) {
        final ChatFormModel chatFormModel = ChatFormModel('FILE',
            userId: chatFormData['user_id'],
            files: filePaths.length > 1
                ? Right(multipartFiles)
                : Left(String.fromCharCodes(
                    File(filePaths.first).readAsBytesSync())));

        // log('Attempting to send chat');
        final result = await chatRepo!.sendFileChat(chatFormModel);
        if (result.isLeft) {
          log('sending file failed: ${result.left.message!['message']}');
          sentFile = false;
          handleError('sending file failed!');
        }
      }

      final ChatFormModel chatFormModel = ChatFormModel('MESG',
          userId: chatFormData['user_id'], message: chatFormData['message']);

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

    return sentChat && sentFile;
  }

  Future<void> getChatsRequest() async {
    isLoading = true;

    log('This is the token gotten from env variables');
    const String apiToken = String.fromEnvironment('Api-token');

    try {
      final ChatRepo chatRepo = ChatRepo(apiToken);

      // log('Attempting to get chats');
      final conversations = await chatRepo.getChats();

      if (conversations.isLeft) {
        // log('getting chats failed: ${conversations.left.status}');
        handleError('chats failed to download');
      } else {
        // log('getting chats successful');
        // toastMessage('chats downloaded', long: false);

        _savedChats = conversations.right.chats!;
      }
    } catch (ex, trace) {
      log('Exception caught : $ex, with strace: $trace');
      toastMessage(ex.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
