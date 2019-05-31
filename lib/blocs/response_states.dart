import 'package:equatable/equatable.dart';
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
import 'package:meta/meta.dart';

abstract class ResponseState extends Equatable {}

class ResponseEmpty extends ResponseState {
  @override
  String toString() => 'RequestEmpty';
}

class ResponseDataLoaded extends ResponseState {
  final dynamic data;
  ResponseDataLoaded({@required this.data})
      : assert(data != null);

  @override
  String toString() => 'ResponseData';
}

class ResponseError extends ResponseState {
  final PojoError error;
  ResponseError({@required this.error})
      : assert(error != null);

  @override
  String toString() => 'ResponseError';
}

class ResponseWaiting extends ResponseState {
  @override
  String toString() => 'ResponseWaiting';
}
