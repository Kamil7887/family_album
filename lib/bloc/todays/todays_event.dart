part of 'todays_bloc.dart';

@immutable
abstract class TodaysEvent {}

class TodaysBlocInitialization extends TodaysEvent {}

class TodaysGetPhotoItem extends TodaysEvent {
  final DocumentSnapshot snapshot;

  TodaysGetPhotoItem({this.snapshot});
}

class TodaysSendMessage extends TodaysEvent {
  final String message;
  TodaysSendMessage(this.message);
}

class TodaysIndexUpdated extends TodaysEvent {}
