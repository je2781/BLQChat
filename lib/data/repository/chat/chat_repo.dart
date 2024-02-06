import 'dart:developer';

import 'package:blq_chat/core/api/base_api.dart';
import 'package:blq_chat/data/repository/chat/chat_repo_interface.dart';
import 'package:blq_chat/data/requests/chat/chat_form.dart';
import 'package:blq_chat/data/response/base_response.dart';
import 'package:blq_chat/data/response/chat/chat_view_res.dart';
import 'package:blq_chat/data/response/user/user.dart';
import 'package:blq_chat/data/response/failure_response.dart';
import 'package:blq_chat/models/failure_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class ChatRepo implements ChatRepoIntl {
  late ApiService api;
  final String? token;
  static const String channelUrl = String.fromEnvironment('channel_url');

  ChatRepo(this.token) {
    api = ApiService(token: token);
  }

  @override
  Future<Either<Failure, ChatRes>> sendChat(
      Map<String, dynamic> messageData) async {
    try {
      ResponseModel response = await api.call(
        method: HttpMethod.post,
        endpoint: 'open_channels/$channelUrl/messages',
        reqBody: messageData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // log('Value Right: ${response.data}');
        return Right(ChatRes.fromMap(response.data));
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
  Future<Either<Failure, ChatRes>> sendFileChat(
      ChatFileModel chatFormModel) async {
    try {
      ResponseModel response = await api.call(
        method: HttpMethod.post,
        endpoint: 'open_channels/$channelUrl/messages',
        reqBody: chatFormModel.toMap(),
        useFormData: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // log('Value Right: ${response.data}');
        return Right(ChatRes.fromMap(response.data));
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
  Future<Either<Failure, ChatRes>> getChats({int? messageId}) async {
    try {
      ResponseModel response = await api.call(
        method: HttpMethod.get,
        endpoint: 'open_channels/$channelUrl/messages',
        queryParams: messageId == null
            ? {"message_ts": 1672531200}
            : {"message_id": messageId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // log('Value Right: ${response.data}');
        return Right(ChatRes.fromMap(response.data));
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
