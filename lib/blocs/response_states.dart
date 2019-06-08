import 'package:equatable/equatable.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
import 'package:meta/meta.dart';

abstract class HState extends Equatable {
  HState([List props = const []]) : super(props);
}

class ResponseEmpty extends HState {
  @override
  String toString() => 'RequestEmpty';
}

class ResponseDataLoaded extends HState {
  

  final dynamic data;
  ResponseDataLoaded({@required this.data})
      : assert(data != null);

  @override
  String toString() => 'ResponseData';
}

class ResponseError extends HState {
  final PojoError error;
  ResponseError({@required this.error})
      : assert(error != null);

  @override
  String toString() => 'ResponseError';
}

class ResponseWaiting extends HState {
  @override
  String toString() => 'ResponseWaiting';
}
