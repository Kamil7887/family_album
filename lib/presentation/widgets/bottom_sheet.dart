import 'package:family_album/bloc/todays/todays_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBottomSheet extends StatefulWidget {
  @override
  _AppBottomSheetState createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet> {
  String textFieldValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            color: Colors.deepPurpleAccent,
            width: 3,
          )),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                textFieldValue = value;
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.forward,
              size: 30,
              color: Colors.deepPurpleAccent,
            ),
            onPressed: () {
              print(textFieldValue);

              BlocProvider.of<TodaysBloc>(context)
                  .add(TodaysSendMessage(textFieldValue));
            },
          ),
        ],
      ),
    );
  }
}
