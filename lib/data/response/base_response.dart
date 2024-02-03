import 'package:dio/dio.dart';

/// This class contains basic information about a Response object
/// It should not be modified destructively, only extended due to dependencies
class ResponseModel {
  Response response;

  ResponseModel(this.response);

  dynamic _data;
  int? _statusCode;

  dynamic get data {
    _data = response.data;
    return _data;
  }

  int? get statusCode {
    _statusCode = response.statusCode;
    return _statusCode;
  }
}
