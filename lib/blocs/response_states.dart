import 'package:equatable/equatable.dart';
<<<<<<< HEAD
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';
=======
import 'package:flutter_hazizz/communication/pojos/PojoError.dart';
>>>>>>> 697a6e3b071e12017449a7ca76eb8a9feb3f5ba0
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
