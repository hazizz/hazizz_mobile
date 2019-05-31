class ConverterNotImplementedException implements Exception {
  // can contain constructors, variables and methods
  String message() => "The response converter method '\convertData'\ is not implemented";
}