import 'package:family_album/bloc/todays/todays_bloc.dart';
import 'package:family_album/data/core/photo_item.dart';
import 'package:family_album/presentation/widgets/bottom_sheet.dart';
import 'package:family_album/presentation/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodaysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodaysBloc()..add(TodaysBlocInitialization()),
      child: Scaffold(
        appBar: AppBar(),
        drawer: AppDrawer(
          disabledButton: AppDrawer.TODAYS_FLAG,
        ),
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<TodaysBloc, TodaysState>(
          listener: (context, state) {},
          // ignore: missing_return
          builder: (context, state) {
            if (state is TodaysPhotoRecievedState) {
              return buildTodaysPage(state.photoItem, state.currentUserName);
            } else if (state is TodaysPhotoItemFailedState) {
              return Center(child: buildTodaysErrorPage(state.errorMessage));
            } else if (state is TodaysInitial)
              return Center(child: CircularProgressIndicator());
          },
        ),
        bottomSheet: AppBottomSheet(),
      ),
    );
  }

  SafeArea buildTodaysPage(PhotoItem item, String displayName) {
    return SafeArea(
      child: item.photoUrl == null
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 10,
            ))
          : ListView(
              children: [
                Image.network(
                  item.photoUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 300,
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: item.messages.length,
                    itemBuilder: (listContext, index) {
                      return item.messages[index].gUser.displayName ==
                              displayName
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(item.messages[index].gMessage +
                                    ':' +
                                    item.messages[index].gTimestamp.toString()),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(item.messages[index].gMessage +
                                    ':' +
                                    item.messages[index].gTimestamp.toString()),
                              ],
                            );
                    })
              ],
            ),
    );
  }

  Column buildTodaysErrorPage(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.error, size: 128),
        SizedBox(
          height: 16,
        ),
        Text(
          'Не удалось загрузить данные. Попробуйте позже.',
          style: TextStyle(fontSize: 32),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          message,
          style: TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
