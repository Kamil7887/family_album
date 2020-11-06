part of 'internet_conection_bloc.dart';

@immutable
abstract class InternetConectionState {}

class InternetConectionInitial extends InternetConectionState {}

class InternetConnectionStatusState extends InternetConectionState {
  final bool isInternetOn;

  InternetConnectionStatusState({@required this.isInternetOn});

  factory InternetConnectionStatusState.initial() =>
      InternetConnectionStatusState(isInternetOn: null);
}
