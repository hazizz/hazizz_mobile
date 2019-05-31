import 'package:equatable/equatable.dart';

abstract class RequestEvent extends Equatable {
  RequestEvent([List props = const []]) : super(props);
}

class FetchRequest extends RequestEvent {
  @override
  String toString() => 'FetchRequest';
}