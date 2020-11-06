import 'package:family_album/presentation/pages/history_page/history_page.dart';
import 'package:family_album/presentation/pages/todays_page.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  static final String TODAYS_FLAG = 'TODAYS_FLAG';
  static final String HISTORY_FLAG = 'HISTORY_FLAG';
  static final String ADD_PHOTO_FLAG = 'ADD_PHOTO_FLAG';

  final String disabledButton;
  AppDrawer({this.disabledButton});

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: disabledButton != TODAYS_FLAG
                ? () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => TodaysPage()));
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: disabledButton != HISTORY_FLAG
                ? () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HistoryPage()));
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.add_a_photo),
            //TODO: Доделать после реализации AddPhotoPage
            onPressed: disabledButton == ADD_PHOTO_FLAG ? () {} : null,
          ),
        ],
      ),
    );
  }
}
