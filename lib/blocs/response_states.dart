import 'package:equatable/equatable.dart';
import 'package:mobile/blocs/id.dart';
import 'package:mobile/communication/pojos/PojoError.dart';

import 'package:meta/meta.dart';

import '../hazizz_response.dart';

abstract class HState extends Equatable {
  static int id = 0;
  HState([List props = const []]) : super(props); // [Id.get()]
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
  String toString() => 'ResponseDataLoaded';
}

class ResponseDataLoadedFromCache extends HState {

  final dynamic data;
  ResponseDataLoadedFromCache({@required this.data})
      : assert(data != null);

  @override
  String toString() => 'ResponseDataLoadedFromCache';
}

class ResponseError extends HState {
  final HazizzResponse errorResponse;
  ResponseError({this.errorResponse}) : assert(errorResponse != null);

  @override
  String toString() => 'ResponseError';
}

class ResponseWaiting extends HState {
  @override
  String toString() => 'ResponseWaiting';
}
