part of 'todays_bloc.dart';

@immutable
abstract class TodaysState {}

class TodaysInitial extends TodaysState {}

class TodaysPhotoRecievedState extends TodaysState {
  final PhotoItem photoItem;
  final bool isLoading;
  final String currentUserName;
  TodaysPhotoRecievedState({
    this.photoItem,
    this.isLoading,
    this.currentUserName,
  });
}
// TodaysPhotoRecievedState copyWith({
//   PhotoItem photoItem,
//   bool isLoading,
//   String currentUserName,
// }) {
//   return TodaysPhotoRecievedState(
//     photoItem: photoItem ?? this.photoItem,
//     isLoading: isLoading ?? this.isLoading,
//      currentUserName: currentUserName ?? this.currentUserName,
//   );
// }

class TodaysPhotoItemFailedState extends TodaysState {
  @required
  final errorMessage;
  TodaysPhotoItemFailedState(this.errorMessage);
}
