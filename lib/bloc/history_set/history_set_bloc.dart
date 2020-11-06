import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_album/data/auth/app_user.dart';
import 'package:family_album/data/core/message_item.dart';
import 'package:family_album/data/core/photo_item.dart';
import 'package:family_album/data/core/photo_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'history_set_event.dart';
part 'history_set_state.dart';

class HistorySetBloc extends Bloc<HistorySetEvent, HistorySetState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  StorageReference storage = FirebaseStorage.instance.ref();
  CollectionReference historySetRef;
  PhotoRepository repository = PhotoRepository();
  HistorySetBloc() : super(HistorySetInitial());

  @override
  Stream<HistorySetState> mapEventToState(
    HistorySetEvent event,
  ) async* {
    if (event is HistorySetInitializer) {
      historySetRef = firestore.collection('history_set');
      add(HistorySetGridShowed());
    } else if (event is HistorySetGridShowed) {
      try {
        yield HistorySetGridState(photoItemList: [], isLoading: true);
        List<PhotoItem> itemList = await repository.getHistoryPhotoSet();
        yield HistorySetGridState(photoItemList: itemList, isLoading: false);
      } catch (e) {
        yield HistorySetErrorState();
      }
    } else if (event is HistorySetItemSelected) {
      DocumentSnapshot docSnapshot = await firestore
          .collection('history_set')
          .doc(event.itemRefName)
          .get();
      String downloadUrl =
          await storage.child(docSnapshot.get('file_name')).getDownloadURL();
      List<MessageItem> messages = List<MessageItem>();
      List<dynamic> rawMessagesList = docSnapshot.get('messages');
      rawMessagesList.forEach((element) {
        Timestamp rawTimestamp = element['timestamp'];
        DateTime timestamp = rawTimestamp.toDate();
        MessageItem item = MessageItem(
          message: element['message_body'],
          user: AppUser(displayName: element['user_name']),
          timestamp: timestamp,
        );
        messages.add(item);
      });

      PhotoItem item = PhotoItem(
        id: docSnapshot.id,
        photoUrl: downloadUrl,
        messages: messages,
        user: AppUser(
          displayName: docSnapshot.get('user_id'),
        ),
      );

      yield HistorySetPhotoItemState(photoItem: item);
    }
  }

  @override
  void onTransition(Transition<HistorySetEvent, HistorySetState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
