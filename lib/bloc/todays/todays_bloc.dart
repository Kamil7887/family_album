import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_album/data/auth/app_user.dart';
import 'package:family_album/data/core/message_item.dart';
import 'package:family_album/data/core/photo_repository.dart';
import 'package:family_album/data/core/photo_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'todays_event.dart';
part 'todays_state.dart';

class TodaysBloc extends Bloc<TodaysEvent, TodaysState> {
  FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  StorageReference storageReference = FirebaseStorage.instance.ref();
  PhotoRepository photoRepository = PhotoRepository();
  StorageReference photoReference;
  int index;
  StreamSubscription docSubscription;
  StreamSubscription indexSubscription;

  TodaysBloc() : super(TodaysInitial());

  @override
  Stream<TodaysState> mapEventToState(
    TodaysEvent event,
  ) async* {
    // Инициализация index и docSubscription
    if (event is TodaysBlocInitialization) {
      print('Index Subscribing....');
      indexSubscription = firestore
          .collection('functional_data')
          .doc('current_index')
          .snapshots()
          .listen((snapshot) async {
        print('listen starts');
        if (index == null) {
          index = await getCurrentIndex();
          print('Doc Subscribing....');
          docSubscription = firestore
              .collection('current_set')
              .doc(index.toString())
              .snapshots()
              .listen((snapshot) {
            add(TodaysGetPhotoItem(snapshot: snapshot));
          });
          print('Subscribed');
        } else {
          index = await getCurrentIndex();
          add(TodaysIndexUpdated());
        }
      });
      print('Subscribed');
    }
    //
    else if (event is TodaysGetPhotoItem) {
      print('getPhotoItem');
      try {
        yield TodaysPhotoRecievedState(
          photoItem: PhotoItem.empty(),
          isLoading: true,
        );
        String docId = event.snapshot.id;
        String filename = event.snapshot.get('file_name');
        String photoUrl =
            await storageReference.child('/' + filename).getDownloadURL();
        List<MessageItem> messages = List<MessageItem>();
        List<dynamic> messagesMapList = event.snapshot.get('messages');

        messagesMapList.forEach((element) {
          Timestamp rawTimestamp = element['timestamp'];
          DateTime timestamp = rawTimestamp.toDate();
          messages.add(MessageItem(
            message: element['message_body'],
            user: AppUser(displayName: element['user_name']),
            timestamp: timestamp,
          ));
        });
        String userId = event.snapshot.get('user_id');
        PhotoItem photoItem = PhotoItem(
          id: docId,
          messages: messages,
          photoUrl: photoUrl,
          user: AppUser(displayName: userId),
        );
        yield TodaysPhotoRecievedState(
            photoItem: photoItem,
            isLoading: false,
            currentUserName: firebaseAuthInstance.currentUser.displayName);
      } catch (e) {
        yield TodaysPhotoItemFailedState(e.toString());
      }
    } else if (event is TodaysSendMessage) {
      if (event.message != '' && event.message != null) {
        photoRepository.sendNewMessage(event.message);
      }
    } else if (event is TodaysIndexUpdated) {
      docSubscription = firestore
          .collection('current_set')
          .doc(index.toString())
          .snapshots()
          .listen((snapshot) {
        add(TodaysGetPhotoItem(snapshot: snapshot));
      });
    }
  }

  Future<int> getCurrentIndex() async {
    int index;
    var docRef = await firestore
        .collection('functional_data')
        .doc('current_index')
        .get();
    index = docRef.get('index');
    return index;
  }

  @override
  Future<void> close() {
    docSubscription.cancel();
    indexSubscription.cancel();
    return super.close();
  }

  @override
  void onTransition(Transition<TodaysEvent, TodaysState> transition) {
    print(transition.toString());
    super.onTransition(transition);
  }
}
