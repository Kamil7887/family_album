import 'package:family_album/bloc/auth/auth_bloc.dart';
import 'package:family_album/presentation/pages/todays_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(AuthUserChecked()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Аутентификация'),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUserNotRegisteredState) {
              if (state.isLoading)
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: LinearProgressIndicator(),
                  ),
                );
              if (state.isError)
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error'),
                  ),
                );
            } else if (state is AuthUserRegisteredState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TodaysPage(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthUserNotRegisteredState) {
              return Center(
                child: buildSignInPage(context),
              );
            } else if (state is AuthUserRegisteredState)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return Container();
          },
        ),
      ),
    );
  }

  Widget buildSignInPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.face,
          size: 128,
        ),
        Text(
          'Family Album',
          style: TextStyle(fontSize: 32),
        ),
        SizedBox(
          height: 16,
        ),
        RaisedButton(
          onPressed: () => context.bloc<AuthBloc>().add(AuthUserCreated()),
          color: Colors.blueAccent,
          elevation: 8,
          child: Text(
            'Войти с Google',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ],
    );
  }
}
