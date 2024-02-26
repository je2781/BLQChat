import 'package:blq_chat/data/response/chat/chat.dart';
import 'package:blq_chat/data/response/user/user.dart';

abstract class CubitChatStates {}

class CubitIsLoading implements CubitChatStates {}

class CubitChatIsLoaded implements CubitChatStates {
  List<Chat> chats;
  CubitChatIsLoaded({required this.chats});
}

class CubitChatSent implements CubitChatStates {
  String? path;
  List<Chat>? chats;
  CubitChatSent({this.chats, this.path});
}
