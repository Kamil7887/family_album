import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

part 'internet_conection_event.dart';
part 'internet_conection_state.dart';

class InternetConectionBloc
    extends Bloc<InternetConectionEvent, InternetConectionState> {
  Connectivity connectivity;
  StreamSubscription subscription;
  InternetConectionState state;
  InternetConectionBloc({@required this.connectivity})
      : super(InternetConectionInitial());

  @override
  Stream<InternetConectionState> mapEventToState(
    InternetConectionEvent event,
  ) async* {
    switch (event.runtimeType) {
      case InternetConnectionSubscribedEvent:
        await Firebase.initializeApp();
        await subscription?.cancel();
        subscription = connectivity.onConnectivityChanged.listen((result) {
          add(InternetConnectionCheckedEvent());
        });
        yield InternetConnectionStatusState.initial();
        break;

      case InternetConnectionCheckedEvent:
        ConnectivityResult connectivityResult =
            await connectivity.checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          yield InternetConnectionStatusState(isInternetOn: false);
        else
          yield InternetConnectionStatusState(isInternetOn: true);
        break;
    }
  }

  @override
  void onTransition(
      Transition<InternetConectionEvent, InternetConectionState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
