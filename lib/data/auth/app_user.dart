import 'package:google_sign_in/google_sign_in.dart';

class AppUser {
  final String displayName;

  AppUser({
    this.displayName,
  });

  factory AppUser.fromDisplayName(String displayName) =>
      AppUser(displayName: displayName);

  factory AppUser.fromId(String id) {
    GoogleSignIn gsi = GoogleSignIn(clientId: id);
    String displayName = gsi.currentUser.displayName;
    return AppUser(displayName: displayName);
  }
}
