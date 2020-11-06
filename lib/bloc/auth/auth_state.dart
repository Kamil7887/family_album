part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthUserRegisteredState extends AuthState {
  final AppUser currentUser;
  AuthUserRegisteredState({this.currentUser});
}

class AuthUserNotRegisteredState extends AuthState {
  final bool isLoading;
  final bool isError;

  AuthUserNotRegisteredState(
      {@required this.isLoading, @required this.isError});
}
