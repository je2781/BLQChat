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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';
import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/data/repository/chat/chat_repo.dart';
import 'package:blq_chat/data/requests/chat/chat_form.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class ChatViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool sentChat = false;
  bool sentFile = true;
  ChatRepo? chatRepo;
  Either<Failure, ChatRes>? conversations;

  //sendbird open channel
  OpenChannel? _channel;

  //Document upload
  FilePickerResult? _fileUpload;

  String? _fileName;
  String? _filePath;
  List<Map<String, dynamic>> multipartFiles = [];

  double? _fileSize;

  List<Chat> _savedChats = [];

  List<Chat> get chats => [..._savedChats];

  final String apiToken = dotenv.get('API_TOKEN');
  final String appId = dotenv.get('APPLICATION_ID');
  final String channelUrl = dotenv.get('CHANNEL_URL');

  void init() {
    SendbirdChat.init(appId: appId);
  }

  void saveNewMessage(int id) async {
    try {
      chatRepo = ChatRepo(apiToken);

      final conversation = await chatRepo!.getChat(id);

      if (conversation.isLeft) {
        log('sending chat failed: ${conversation.left.message!['message']}');

        handleError('sending chat failed!');
      } else {
        // storing sent message in global app storage

        _savedChats.add(Chat(
            UserProfile(
                name: conversation.right.chats!.left.sender.name,
                id: conversation.right.chats!.left.sender.id,
                isActive: conversation.right.chats!.left.sender.isActive,
                profileUrl: conversation.right.chats!.left.sender.profileUrl),
            'MESG',
            id: conversation.right.chats!.left.id,
            message: conversation.right.chats!.left.message,
            channelType: conversation.right.chats!.left.channelType,
            createdAt: conversation.right.chats!.left.createdAt!
                .convertDateTimeToUnix(DateTime.now())));
      }
    } catch (ex, trace) {
      log('Exception caught : $ex, with strace: $trace');
      toastMessage(ex.toString());
    } finally {
      notifyListeners();
    }
  }

  void saveChannel(OpenChannel channel) {
    _channel = channel;
    notifyListeners();
  }

  Future<void> sendFile() async {
    try {
      _fileUpload = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
      );
      if (_fileUpload != null) {
        _fileName = _fileUpload!.files[0].name;
        _fileSize = ((_fileUpload!.files[0].size / 1024) / 1024);

        if (_fileSize! > 5.0) {
          log('file have exceeded file size limit');
          toastMessage("File have exceeded 5MB", long: true);
          return;
        }
        // log('Attempting to send file')

        final message = _channel!.sendFileMessage(
            FileMessageCreateParams.withFile(File(_fileUpload!.paths[0]!),
                fileName: _fileName));

        if (message.errorCode == 400201) {
          sentFile = false;
          handleError('sending file failed!');
        }
      }
    } catch (ex, trace) {
      log('Exception caught : $ex, with strace: $trace');
      toastMessage(ex.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<bool> sendChatRequest(
      Map<String, dynamic> chatFormData, BuildContext context) async {
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
            UserProfile(
                name: result.right.chats!.left.sender.name,
                id: result.right.chats!.left.sender.id,
                isActive: result.right.chats!.left.sender.isActive,
                profileUrl: result.right.chats!.left.sender.profileUrl),
            'MESG',
            id: result.right.chats!.left.id,
            message: result.right.chats!.left.message,
            channelType: result.right.chats!.left.channelType,
            createdAt: result.right.chats!.left.createdAt!
                .convertDateTimeToUnix(DateTime.now())));
        //confirming chat has been sent
        sentChat = true;
        //storing message id of sent message in local storage
        final messageData = json.encode(
          {
            'messageId': result.right.chats!.left.id,
            'user': result.right.chats!.left.sender.name
          },
        );
        await prefs.setString('messageData', messageData);
      }
    } catch (ex, trace) {
      log('Exception caught : $ex, with strace: $trace');
      toastMessage(ex.toString());
    } finally {
      notifyListeners();
    }

    return sentChat && sentFile;
  }

  Future<void> getChatsRequest() async {
    isLoading = true;

    try {
      //getting instance of chat repo
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

  Future<void> updateUserRequest(Map<String, dynamic> userData) async {
    try {
      final UserRepo userRepo = UserRepo(apiToken);

      // log('Attempting to update user');
      final user = await userRepo.updateUser(userData);

      if (user.isLeft) {
        handleError('user profile operation failed');
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
      }
    } catch (ex, trace) {
      log('Exception caught : $ex, with strace: $trace');
      toastMessage(ex.toString());
    }
  }

  Future<bool> getUserRequest() async {
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
