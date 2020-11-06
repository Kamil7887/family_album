part of 'internet_conection_bloc.dart';

@immutable
abstract class InternetConectionEvent {}

class InternetConnectionCheckedEvent extends InternetConectionEvent {}

class InternetConnectionSubscribedEvent extends InternetConectionEvent {}
