import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/cubits/cubit_chat_states.dart';
import 'package:blq_chat/data/repository/chat/chat_repo.dart';
import 'package:blq_chat/data/repository/user/user_repo.dart';
import 'package:blq_chat/data/requests/chat/chat_form.dart';
import 'package:blq_chat/data/response/chat/chat.dart';
import 'package:blq_chat/data/response/user/user.dart';
import 'package:blq_chat/service/sendbird_channel_handler.dart';
import 'package:blq_chat/ui/chat/widgets/profile.dart';
import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/response/chat/chat_view_res.dart';
import '../models/failure_model.dart';

class ChatCubit extends Cubit<CubitChatStates> {
  final String apiToken = dotenv.get('API_TOKEN');
  final String appId = dotenv.get('APPLICATION_ID');
  final String channelUrl = dotenv.get('CHANNEL_URL');

  ChatCubit(BuildContext context) : super(CubitIsLoading()) {
    SendbirdChat.init(appId: appId);

    getUserRequest().then((result) async {
      if (!result) {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          enableDrag: false,
          builder: (_) {
            return MyProfile();
          },
        );
      }
    });
    getChatsRequest();
  }

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
  String get filePath => _filePath!;

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
      emit(CubitChatSent(chats: chats));
    }
  }

  void saveChannel(OpenChannel channel) {
    _channel = channel;
  }

  Future<void> pickFiles() async {
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

      _filePath = _fileUpload!.paths[0];
      emit(CubitChatSent(path: filePath));
    }
  }

  Future<bool> sendChatRequest(Map<String, dynamic> chatFormData,
      BuildContext context, String? path) async {
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

      if (path != null) {
        final ChatFileModel chatFileModel = ChatFileModel('FILE',
            userId: extractedUserData['userId'] as String,
            file: String.fromCharCodes(File(path!).readAsBytesSync()));

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
      emit(CubitChatSent(chats: chats));
    }

    return sentChat && sentFile;
  }

  Future<void> getChatsRequest() async {
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
      emit(CubitChatIsLoaded(chats: chats));
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
