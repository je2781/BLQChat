import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/data/repository/user/user_repo.dart';
import 'package:blq_chat/data/response/chat/chat.dart';
import 'package:blq_chat/data/response/user/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      //getting instance of local storage
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey('userData')) {
        handleError('You do not have a user profile');
        return false;
      }

      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

      if (filePaths.isNotEmpty) {
        final ChatFileModel chatFileModel = ChatFileModel('FILE',
            userId: extractedUserData['userId'] as String,
            files: filePaths.length > 1
                ? Right(multipartFiles)
                : Left(String.fromCharCodes(
                    File(filePaths.first).readAsBytesSync())));

        // log('Attempting to send chat');
        final result = await chatRepo!.sendFileChat(chatFileModel);
        if (result.isLeft) {
          log('sending file failed: ${result.left.message!['message']}');
          sentFile = false;
          handleError('sending file failed!');
        }
      }

      final result = await chatRepo!.sendChat({
        'message_type': 'MESG',
        'user_id': extractedUserData['userId'] as String,
        'message': chatFormData['message']
      });
      if (result.isLeft) {
        log('sending chat failed: ${result.left.message!['message']}');

        handleError('sending chat failed!');
      } else {
        // log('sending chat successful');

        _savedChats.add(Chat(
            User(
                name: result.right.chats!.left.sender.name,
                id: result.right.chats!.left.sender.id,
                isActive: result.right.chats!.left.sender.isActive,
                profileUrl: result.right.chats!.left.sender.profileUrl),
            filePaths.isNotEmpty ? 'FILE' : 'MESG',
            channelType: result.right.chats!.left.channelType,
            createdAt: result.right.chats!.left.createdAt));
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

        _savedChats = conversations.right.chats!.right;
      }
    } catch (ex, trace) {
      log('Exception caught : $ex, with strace: $trace');
      toastMessage(ex.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUserRequest(Map<String, dynamic> userData) async {
    log('This is the token gotten from env variables');
    const String apiToken = String.fromEnvironment('Api-token');

    try {
      final UserRepo userRepo = UserRepo(apiToken);

      // log('Attempting to create user');
      final user = await userRepo.createUser(userData);

      if (user.isLeft) {
        handleError('could not create your profile: ');
      } else {
        //storing userId in local storage to retrieve later for authentication
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'userId': user.right.user!.id,
            'name': user.right.user!.name,
            'url': user.right.user!.profileUrl
          },
        );
        prefs.setString('userData', userData);

        toastMessage('user profile created', long: false);
      }
    } catch (ex, trace) {
      log('Exception caught : $ex, with strace: $trace');
      toastMessage(ex.toString());
    }
  }

  Future<bool> getUserRequest() async {
    log('This is the token gotten from env variables');
    const String apiToken = String.fromEnvironment('Api-token');

    try {
      //getting instance of local storage
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey('userData')) {
        return false;
      }

      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

      final UserRepo userRepo = UserRepo(apiToken);

      final user =
          await userRepo.getUser(extractedUserData['userId'] as String);

      if (user.isLeft) {
        handleError('could not find user profile');
        return false;
      } else {
        //checking if user profile has been created
        if (user.right.user!.id == extractedUserData['userId']) {
          return true;
        } else {
          return false;
        }
      }
    } catch (ex, trace) {
      log('Exception caught : $ex, with strace: $trace');
      toastMessage(ex.toString());
      return false;
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
