part of 'history_set_bloc.dart';

@immutable
abstract class HistorySetEvent {}

class HistorySetInitializer extends HistorySetEvent {}

class HistorySetGridShowed extends HistorySetEvent {}

class HistorySetItemSelected extends HistorySetEvent {
  final String itemRefName;
  HistorySetItemSelected({@required this.itemRefName});
}
