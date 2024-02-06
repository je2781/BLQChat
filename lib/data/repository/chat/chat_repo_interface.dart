import 'package:blq_chat/data/requests/chat/chat_form.dart';
import 'package:blq_chat/data/response/chat/chat_view_res.dart';
import 'package:blq_chat/models/failure_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

abstract class ChatRepoIntl {
  Future<Either<Failure, ChatRes>> getChats(dynamic messageId);
  Future<Either<Failure, ChatRes>> sendChat(Map<String, dynamic> messageData);
  Future<Either<Failure, ChatRes>> sendFileChat(ChatFileModel chatFormModel);
}
