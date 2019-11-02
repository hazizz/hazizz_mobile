import 'package:equatable/equatable.dart';

abstract class HEvent extends Equatable {
  HEvent([List props = const []]);
}

class FetchData extends HEvent {

  @override
  String toString() => 'FetchData';
  List<Object> get props => null;
}