import '../app_utils/styles/strings.dart';

class Failure {
  int? code; //200 or 400
  Map? message; //error or success

  Failure(this.code, this.message);
}

class DefaultFailure extends Failure {
  DefaultFailure() : super(-1, {'message': PSStrings.psDefaultFailureString});
}
