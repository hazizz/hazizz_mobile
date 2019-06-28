import 'package:mobile/communication/pojos/PojoError.dart';

class ConverterNotImplementedException implements Exception {
  // can contain constructors, variables and methods
  String message() => "The response converter method '\convertData'\ is not implemented";
}

class HResponseError implements Exception {
  PojoError error;
  HResponseError(this.error);
  String message() => "The response is an error";
}

class UnexpectedResponse implements Exception {
  dynamic unexpectedResponse;
  UnexpectedResponse(this.unexpectedResponse);
  String message() => "Unexpected response error";
}