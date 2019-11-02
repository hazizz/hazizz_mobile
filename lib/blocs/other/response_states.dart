import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

import 'package:mobile/communication/hazizz_response.dart';

abstract class HState extends Equatable {
  static int id = 0;
  HState([List props = const []]); // [Id.get()]
}

class ResponseEmpty extends HState {
  @override
  String toString() => 'ResponseEmpty';
  @override
  List<Object> get props => null;
}

class ResponseDataLoaded extends HState {

  final dynamic data;
  ResponseDataLoaded({@required this.data})
      : assert(data != null);

  @override
  String toString() => 'ResponseDataLoaded';
  @override
  List<Object> get props => [data];
}

class ResponseDataLoadedFromCache extends HState {

  final dynamic data;
  ResponseDataLoadedFromCache({@required this.data})
      : assert(data != null);

  @override
  String toString() => 'ResponseDataLoadedFromCache';
  @override
  List<Object> get props => [data];
}

class ResponseError extends HState {
  final HazizzResponse errorResponse;
  ResponseError({this.errorResponse}) : assert(errorResponse != null);

  @override
  String toString() => 'ResponseError';
  @override
  List<Object> get props => [errorResponse];
}

class ResponseWaiting extends HState {
  @override
  String toString() => 'ResponseWaiting';
  @override
  List<Object> get props => null;
}
