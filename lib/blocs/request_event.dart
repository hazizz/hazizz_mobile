import 'package:equatable/equatable.dart';

abstract class HEvent extends Equatable {
  HEvent([List props = const []]) : super(props);
}

class FetchData extends HEvent {
  @override
  String toString() => 'FetchData';
}