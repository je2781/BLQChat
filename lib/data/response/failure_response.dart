import 'package:blq_chat/models/failure_model.dart';

import '../../app_utils/styles/strings.dart';

import 'base_response.dart';

class FailureResponse extends ResponseModel {
  FailureResponse(super.response);
}

extension ToDomain on FailureResponse {
  Failure toDomain() {
    return Failure(
      response.statusCode ?? -1,
      response.data ?? [BLQStrings.blqDefaultFailureString],
    );
  }
}
