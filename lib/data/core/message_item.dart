import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_album/data/auth/app_user.dart';
import 'package:flutter/cupertino.dart';

class MessageItem {
  final AppUser user;
  final String message;
  DateTime timestamp;
  MessageItem({
    @required this.user,
    @required this.message,
    timestamp,
  }) : this.timestamp = timestamp ?? defaultDateTime();
  static DateTime defaultDateTime() => DateTime.now();

  Map<String, dynamic> toFirebase() => {
        'user_name': user.displayName,
        'message_body': message,
        'timestamp': timestamp
      };

  MessageItem fromFirebase(QueryDocumentSnapshot snapshot) {
    Timestamp rawTimestamp = snapshot.get('timestamp');
    print(rawTimestamp.runtimeType.toString() + ':' + rawTimestamp.toString());
    DateTime timestamp = rawTimestamp.toDate();
    return MessageItem(
      user: snapshot.get('user_name'),
      message: snapshot.get('message_body'),
      timestamp: timestamp,
    );
  }

  get gUser => user;
  get gMessage => message;
  get gTimestamp => timestamp;
}
