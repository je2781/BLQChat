import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/data/repository/user/user_repo.dart';
import 'package:blq_chat/data/response/chat/chat.dart';
import 'package:blq_chat/data/response/chat/chat_view_res.dart';
import 'package:blq_chat/data/response/user/user.dart';
import 'package:blq_chat/models/failure_model.dart';
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
  Either<Failure, ChatRes>? conversations;

  //Document upload
  FilePickerResult? fileUpload;

  String? fileName;
  String? filePath;
  List<Map<String, dynamic>> multipartFiles = [];

  double? fileSize;

  List<Chat> _savedChats = [];

  List<Chat> get chats => [..._savedChats];

  Future<void> pickFiles() async {
    fileUpload = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );
    if (fileUpload != null) {
      fileName = fileUpload!.files[0].name;
      fileSize = ((fileUpload!.files[0].size / 1024) / 1024);

      if (fileSize! > 5.0) {
        log('file have exceeded file size limit');
        toastMessage("File have exceeded 5MB", long: true);
        return;
      }

      filePath = fileUpload!.paths[0];
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

      if (filePath != null) {
        final ChatFileModel chatFileModel = ChatFileModel('FILE',
            userId: extractedUserData['userId'] as String,
            file: String.fromCharCodes(File(filePath!).readAsBytesSync()));

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
        // storing sent message in global app storage

        _savedChats.add(Chat(
            User(
                name: result.right.chats!.left.sender.name,
                id: result.right.chats!.left.sender.id,
                isActive: result.right.chats!.left.sender.isActive,
                profileUrl: result.right.chats!.left.sender.profileUrl),
            filePath != null ? 'FILE' : 'MESG',
            id: result.right.chats!.left.id,
            message: result.right.chats!.left.message,
            channelType: result.right.chats!.left.channelType,
            createdAt: context.convertDateTimeToUnix(DateTime.now())));
        //confirming chat has been sent
        sentChat = true;
        //storing message id of sent message in local storage
        final messageData = json.encode(
          {
            'messageId': result.right.chats!.left.id,
            'sender': result.right.chats!.left.sender.name
          },
        );
        await prefs.setString('messageData', messageData);
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

      //getting instance of local storage
      final prefs = await SharedPreferences.getInstance();

      // checking if local storage any message id is stored
      if (!prefs.containsKey('messageData')) {
        conversations = await chatRepo.getChats();
      } else {
        final extractedMessageData = json
            .decode(prefs.getString('messageData')!) as Map<String, dynamic>;

        conversations = await chatRepo.getChats(
            messageId: extractedMessageData['messageId']);
      }

      if (conversations!.isLeft) {
        // log('getting chats failed: ${conversations.left.status}');
        handleError('chats failed to download');
      } else {
        _savedChats.addAll(conversations!.right.chats!.right);
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

      //checking for duplicate user profiles
      final extractedUser = await userRepo.getUser(userData['user_id']);
      if (extractedUser.isRight) {
        if (extractedUser.right.user!.id == userData['user_id']) {
          return handleError('user account already exists');
        }
      }
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
        await prefs.setString('userData', userData);

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
