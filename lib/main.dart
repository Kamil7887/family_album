import 'package:connectivity/connectivity.dart';
import 'package:family_album/bloc/internet_connection/bloc/internet_conection_bloc.dart';
import 'package:family_album/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
//test
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          InternetConectionBloc(connectivity: Connectivity())
            ..add(InternetConnectionSubscribedEvent()),
      child: MaterialApp(
        title: 'FamilyAlbum',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
