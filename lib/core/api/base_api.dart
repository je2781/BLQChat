import 'dart:developer';

import 'package:blq_chat/core/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../data/response/base_response.dart';

enum HttpMethod { get, post, patch, put, delete }

class ApiService {
  static final Map<String, String> _requestHeaders = {
    'Accept': '*/*',
    "Connection": 'keep-alive',
    "Content-Type": "application/json"
  };

  final String? token;

  ApiService({this.token});

  final BaseOptions _options = BaseOptions(
    headers: _requestHeaders,
    connectTimeout: 50000,
    receiveTimeout: 50000,
  );

  Dio _dio() {
    Dio dio;
    _options.baseUrl = AppConstants.baseUrl;

    if (kReleaseMode) {
      dio = Dio(_options);
    } else {
      dio = Dio(_options)
        ..interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ));
    }
    return dio;
  }

  Future<ResponseModel> call({
    required HttpMethod method,
    required String endpoint,
    Map<String, dynamic>? reqBody,
    Map<String, dynamic>? queryParams,
    bool useFormData = false,
    FormData? formData,
    bool protected = true,
  }) async {
    try {
      switch (method) {
        case HttpMethod.post:
          Response response = await _dio().post(
            endpoint,
            data: reqBody,
            options: Options(
              headers: {
                "Api-token": "$token",
                "content-type":
                    useFormData ? "multipart/form-data" : "application/json",
                "boundary": "XXX"
              },
            ),
          );
          return ResponseModel(response);

        case HttpMethod.get:
          Response response = await _dio().get(
            endpoint,
            queryParameters: queryParams,
            options: Options(headers: {"Api-token": "$token"}),
          );
          return ResponseModel(response);
        case HttpMethod.patch:
          Response response = await _dio().patch(
            endpoint,
            data: reqBody,
            options: Options(headers: {"Api-token": "$token"}),
          );
          return ResponseModel(response);
        case HttpMethod.put:
          Response response = await _dio().put(
            endpoint,
            data: reqBody,
            options: Options(headers: {"Api-token": "$token"}),
          );
          return ResponseModel(response);
        case HttpMethod.delete:
          Response response = await _dio().delete(
            endpoint,
            data: reqBody,
            options: Options(headers: {"Api-token": "$token"}),
          );
          return ResponseModel(response);
      }
    } on DioError catch (e, stackTrace) {
      debugPrint(e.message);
      debugPrint(stackTrace.toString());
      debugPrint(e.response.toString());
      if (e.type == DioErrorType.connectTimeout) {
        return ResponseModel(
          Response(
              statusCode: 504,
              data: "Request timeout",
              requestOptions: RequestOptions(path: '')),
        );
      } else if (e.type == DioErrorType.other) {
        return ResponseModel(
          Response(
              statusCode: 101,
              data: "Network is unreachable",
              requestOptions: RequestOptions(path: '')),
        );
      }
      return ResponseModel(e.response!);
    }
  }
}
