import 'package:blq_chat/data/requests/chat/chat_form.dart';
import 'package:blq_chat/data/response/chat/chat_view_res.dart';
import 'package:blq_chat/data/response/user/user_res.dart';
import 'package:blq_chat/models/failure_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

abstract class UserRepoIntl {
  Future<Either<Failure, UserRes>> updateUser(Map<String, dynamic> userData);
  Future<Either<Failure, UserRes>> getUser(String userId);
}
