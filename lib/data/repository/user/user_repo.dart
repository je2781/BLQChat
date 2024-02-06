import 'dart:developer';

import 'package:blq_chat/core/api/base_api.dart';
import 'package:blq_chat/data/repository/chat/chat_repo_interface.dart';
import 'package:blq_chat/data/repository/user/user_repo_interface.dart';
import 'package:blq_chat/data/requests/chat/chat_form.dart';
import 'package:blq_chat/data/response/base_response.dart';
import 'package:blq_chat/data/response/chat/chat_view_res.dart';
import 'package:blq_chat/data/response/user/user.dart';
import 'package:blq_chat/data/response/failure_response.dart';
import 'package:blq_chat/data/response/user/user_res.dart';
import 'package:blq_chat/models/failure_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserRepo implements UserRepoIntl {
  late ApiService api;
  final String? token;
  static String channelUrl = dotenv.get('CHANNEL_URL');

  UserRepo(this.token) {
    api = ApiService(token: token);
  }

  @override
  Future<Either<Failure, UserRes>> createUser(
      Map<String, dynamic> userData) async {
    try {
      ResponseModel response = await api.call(
        method: HttpMethod.post,
        endpoint: 'users',
        reqBody: userData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // log('Value Right: ${response.data}');
        return Right(UserRes.fromMap(response.data));
      } else {
        // log('Value left: ${response.data}');
        return Left(FailureResponse(response.response).toDomain());
      }
    } catch (ex, trace) {
      log('ERROR caught: $ex, with stackTrace: $trace');
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, UserRes>> getUser(String userId) async {
    try {
      ResponseModel response = await api.call(
        method: HttpMethod.get,
        endpoint: 'users/$userId',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // log('Value Right: ${response.data}');
        return Right(UserRes.fromMap(response.data));
      } else {
        // log('Value left: ${response.data}');
        return Left(FailureResponse(response.response).toDomain());
      }
    } catch (ex, trace) {
      log('ERROR caught: $ex, with stackTrace: $trace');
      return Left(DefaultFailure());
    }
  }
}
