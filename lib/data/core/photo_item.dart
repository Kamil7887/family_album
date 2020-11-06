import 'package:family_album/data/auth/app_user.dart';
import 'package:family_album/data/core/message_item.dart';
import 'package:flutter/cupertino.dart';

class PhotoItem {
  String id;
  AppUser user;
  String photoUrl;
  List<MessageItem> messages;

  PhotoItem({
    @required this.id,
    @required this.user,
    @required this.photoUrl,
    @required this.messages,
  });

  factory PhotoItem.preview({@required String id, @required String url}) =>
      PhotoItem(
        id: id,
        user: null,
        photoUrl: url,
        messages: null,
      );

  factory PhotoItem.empty() => PhotoItem(
        id: null,
        user: null,
        photoUrl: null,
        messages: null,
      );

  @override
  String toString() {
    return '$id  + $photoUrl ';
  }
}
