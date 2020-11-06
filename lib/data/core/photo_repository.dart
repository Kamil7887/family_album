import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_album/data/auth/app_user.dart';
import 'package:family_album/data/core/message_item.dart';
import 'package:family_album/data/core/photo_data_provider.dart';
import 'package:family_album/data/core/photo_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PhotoRepository {
  final PhotoItemApi photoItemApi = PhotoItemApi();
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  final GoogleSignIn gsi = GoogleSignIn();
  final User user = FirebaseAuth.instance.currentUser;

  Future<PhotoItem> getRandomPhotoItem() async {
    DocumentReference itemReference =
        await photoItemApi.getRandomRawPhotoData();
    DocumentSnapshot photoItemSnapshot = await itemReference.get();
    String itemId = itemReference.id;

    AppUser user;
    String userId = photoItemSnapshot['user_id'];
    if (userId.contains(RegExp(r'[0-9]'))) {
      user = AppUser.fromId(userId);
    } else {
      user = AppUser.fromDisplayName(userId);
    }

    String photoUrl =
        await storageRef.child(photoItemSnapshot['file_name']).getDownloadURL();

    List<MessageItem> messages = photoItemSnapshot['messages'];

    PhotoItem photoItem = PhotoItem(
      id: itemId,
      user: user,
      photoUrl: photoUrl,
      messages: messages,
    );

    return photoItem;
  }

  Future<void> sendNewMessage(String message) async {
    MessageItem messageItem = MessageItem(
      message: message,
      user: AppUser(displayName: user.displayName),
    );
    photoItemApi.addNewMessageToFirebase(messageItem);
  }

  Future<List<PhotoItem>> getHistoryPhotoSet() async {
    QuerySnapshot documents = await photoItemApi.getHistoryPhotoData();
    List<PhotoItem> historyPhotoSet = List<PhotoItem>();
    for (var document in documents.docs) {
      String downloadUrl =
          await storageRef.child(document.get('file_name')).getDownloadURL();
      historyPhotoSet.add(PhotoItem.preview(
        id: document.id,
        url: downloadUrl,
      ));
      return historyPhotoSet;
    }
  }
}
