part of 'history_set_bloc.dart';

@immutable
abstract class HistorySetState {}

class HistorySetInitial extends HistorySetState {}

class HistorySetGridState extends HistorySetState {
  final List<PhotoItem> photoItemList;
  final bool isLoading;
  HistorySetGridState({
    @required this.photoItemList,
    @required this.isLoading,
  });
}

class HistorySetPhotoItemState extends HistorySetState {
  final PhotoItem photoItem;
  HistorySetPhotoItemState({@required this.photoItem});
}

class HistorySetErrorState extends HistorySetState {}
