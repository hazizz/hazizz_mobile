import 'dart:async';

import 'package:hazizz_mobile/blocs/request_event.dart';
import 'package:hazizz_mobile/blocs/response_states.dart';
import 'package:hazizz_mobile/managers/TokenManager.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';


//region Auth states
abstract class AuthenticationState extends HState {}

class AuthUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthAuthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationAuthenticated';
}

class AuthUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';
}
//endregion

//region Auth events
abstract class AuthenticationEvent extends HEvent {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
//  final String token;

  //LoggedIn({@required this.token}) : super([token]);
  LoggedIn();

  @override
  String toString() => 'LoggedIn';// { token: $token }';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}
//endregion

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
 // final UserRepository userRepository;
/*
  AuthBloc({@required this.userRepository})
      : assert(userRepository != null);
  */

  static final AuthBloc _singleton = new AuthBloc._internal();

  factory AuthBloc() {
    return _singleton;
  }

  AuthBloc._internal();


  @override
  AuthenticationState get initialState => AuthUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event,) async* {
    if (event is AppStarted) {
      final bool hasToken = await TokenManager.hasToken();

      if (hasToken) {
        yield AuthAuthenticated();
      } else {
        yield AuthUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthAuthenticated();
    }

    if (event is LoggedOut) {
   //   yield AuthLoading();
      TokenManager.invalidateTokens();
      yield AuthUnauthenticated();
    }
  }
}
