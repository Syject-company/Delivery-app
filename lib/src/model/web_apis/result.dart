import 'package:dio/dio.dart';

class Result<T> {
  final T result;
  final ResultStatus resultStatus;

  Result(this.result, this.resultStatus);

  bool get isSuccessful => resultStatus.code == WebCode.ok;
}

class ResultStatus {
  int? rawCode;
  var message;
  String? method;
  String? request;

  ResultStatus(this.rawCode, {this.message, this.method, this.request});

  ResultStatus.response(Response response, {this.method}) {
    rawCode = response.statusCode;
    message = response.statusMessage;
  }

  ResultStatus.error(DioError error, {this.method}) {
    rawCode = error.response?.statusCode;
    message = error.response?.data ?? error.message;
  }

  ResultStatus.unknownError() {
    rawCode = 0;
    message = "Unknown error";
  }

  bool get isSuccessful => code == WebCode.ok;

  get code {
    for (var i = 0; i < ListCode.length; i++) {
      var element = ListCode.entries.elementAt(i);
      if (element.value.contains(rawCode)) {
        return element.key;
      }
    }
    return WebCode.unknown_error;
  }
}

enum WebCode {
  ok,
  not_found,
  conflict,
  server_error,
  unauthorized_error,
  bad_request_error,
  unknown_error,
  no_internet_connection,
  internet_connection_timeout
}

const Map<WebCode, List<int>> ListCode = {
  WebCode.ok: [200],
  WebCode.not_found: [404, 410],
  WebCode.conflict: [409],
  WebCode.server_error: [
    500,
    501,
    502,
    503,
    504,
    505,
    506,
    507,
    508,
    509,
    510,
    511,
    520,
    521,
    522,
    523,
    524,
    525,
    526
  ],
  WebCode.unauthorized_error: [401],
  WebCode.bad_request_error: [400],
  WebCode.unknown_error: [0],
  WebCode.no_internet_connection: [-1],
  WebCode.internet_connection_timeout: [-2]
};
