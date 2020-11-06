import 'package:family_album/bloc/history_set/history_set_bloc.dart';
import 'package:family_album/presentation/pages/history_page/history_page_detailed.dart';
import 'package:family_album/presentation/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HistorySetBloc()..add(HistorySetInitializer()),
        child: Scaffold(
            appBar: AppBar(
              title: Text('Архив'),
            ),
            drawer: AppDrawer(
              disabledButton: AppDrawer.HISTORY_FLAG,
            ),
            body: BlocConsumer<HistorySetBloc, HistorySetState>(
              listener: (context, state) {
                if (state is HistorySetItemSelected)
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HistoryPageDetailed(),
                  ));
              },
              // ignore: missing_return
              builder: (context, state) {
                if (state is HistorySetInitializer)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else if (state is HistorySetGridState)
                  return state.isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () =>
                                  BlocProvider.of<HistorySetBloc>(context).add(
                                      HistorySetItemSelected(
                                          itemRefName:
                                              state.photoItemList[index].id)),
                              child: Image.network(
                                state.photoItemList[index].photoUrl,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          itemCount: 1,
                        );
                else
                  return Container();
              },
            )));
  }
}
