part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthUserChecked extends AuthEvent {}

class AuthUserCreated extends AuthEvent {}
