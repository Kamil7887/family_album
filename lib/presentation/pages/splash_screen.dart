import 'package:family_album/presentation/pages/auth_page.dart';
import 'package:family_album/bloc/internet_connection/bloc/internet_conection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<InternetConectionBloc, InternetConectionState>(
        // ignore: missing_return
        builder: (context, state) {
          if (state is InternetConectionInitial)
            return Container();
          else if (state is InternetConnectionStatusState)
            return Center(child: buildSplashScreen());
          else
            return Container();
        },

        listener: (context, state) {
          if (state is InternetConnectionStatusState) {
            if (state.isInternetOn == false)
              showDialog(
                context: context,
                builder: (context) => buildInternetAlertDialog(),
              );
            else if (state.isInternetOn)
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AuthPage(),
                ),
              );
          }
        },
      ),
    );
  }
}

Widget buildSplashScreen() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.face,
        size: 128,
      ),
      Text(
        'Photo Album',
        style: TextStyle(
          fontSize: 48,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget buildInternetAlertDialog() {
  return AlertDialog(
    title: Text('Нет подключения к интернету!'),
    content: Text(
        'Пожалуйста включите мобильную передачу данных или подключитесь к сети Wifi'),
  );
}
