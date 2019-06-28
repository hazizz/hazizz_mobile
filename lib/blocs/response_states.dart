import 'package:equatable/equatable.dart';
import 'package:hazizz_mobile/blocs/id.dart';
import 'package:hazizz_mobile/communication/pojos/PojoError.dart';

import 'package:meta/meta.dart';

abstract class HState extends Equatable {
  static int id = 0;

 // List<dynamic> props = [Id.get()];

 // HState({this.props}) : super(props = [""]);
//  static List<dynamic> _props = [Id.get()];
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
