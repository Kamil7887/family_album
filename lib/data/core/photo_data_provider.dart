import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_album/data/core/message_item.dart';

class PhotoItemApi {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<DocumentReference> getRandomRawPhotoData() async {
    DocumentSnapshot indexReference = await firestore
        .collection('functional_data')
        .doc('current_index')
        .get();
    int index = indexReference['index'];

    DocumentReference currentPhotoReference =
        firestore.collection('current_set').doc(index.toString());
    return currentPhotoReference;
  }

  Future<void> addNewMessageToFirebase(MessageItem messageItem) async {
    DocumentSnapshot indexReference = await firestore
        .collection('functional_data')
        .doc('current_index')
        .get();
    int index = indexReference['index'];

    DocumentReference docRef =
        firestore.collection('current_set').doc(index.toString());
    print('deleteMe');

    docRef.update({
      'messages': FieldValue.arrayUnion([messageItem.toFirebase()]),
    });
  }

  Future<QuerySnapshot> getHistoryPhotoData() async {
    QuerySnapshot querySnapshot =
        await firestore.collection('history_set').get();
    return querySnapshot;
  }
}
