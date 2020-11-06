import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:family_album/data/auth/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  User _firebaseUser;

  AuthBloc() : super(AuthInitial()) {
    _firebaseUser = firebaseAuthInstance.currentUser;
  }
  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AuthUserChecked:
        _firebaseUser = firebaseAuthInstance.currentUser;
        if (_firebaseUser == null) {
          yield AuthUserNotRegisteredState(isError: false, isLoading: false);
        } else {
          AppUser appUser = AppUser(
            displayName: _firebaseUser.displayName,
          );
          yield AuthUserRegisteredState(currentUser: appUser);
        }
        break;
      case AuthUserCreated:
        yield AuthUserNotRegisteredState(isError: false, isLoading: true);
        try {
          AppUser user = await signInWithGoogle();
          yield AuthUserRegisteredState(currentUser: user);
        } catch (e) {
          print(e);
          yield AuthUserNotRegisteredState(
            isError: true,
            isLoading: false,
          );
        }
        break;
    }
  }

  Future<AppUser> signInWithGoogle() async {
    await Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await firebaseAuthInstance.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = firebaseAuthInstance.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return AppUser(displayName: user.displayName);
    }
    return null;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }
}
