import 'package:axolotl/adventure/actions.dart';
import 'package:axolotl/adventure/list/actions.dart';
import 'package:axolotl/adventure/list/states.dart';
import 'package:axolotl/adventure/pages.dart';
import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/common/loading_widget.dart';
import 'package:axolotl/utils/flutter_utils.dart';
import 'package:axolotl/vocabulary/list/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AdventureListPage extends StatefulWidget{
  final String title;

  const AdventureListPage({Key key, this.title = 'Adventure Lists'}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AdventureListPageState();

}

class AdventureListPageState extends State<AdventureListPage> {
  @override
  void initState() {
    if (Redux.store.state.adventureListState.loadingState == LoadingState.NONE) {
      fetchAdventureListsAction(true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StoreConnector<AppState, AdventureListState>(
        converter: (store) => store.state.adventureListState,
        distinct: true,
        builder: (context, listState) {
          if (listState.loadingState == LoadingState.LOADING) {
            return LoadingWidget();
          }
          return AdventureListView(lists: listState.adventures);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Redux.dispatch(AdventureOpen(Adventure.EMPTY, null, settings: AdventureSettings.EDIT));
          FlutterUtils.pushPage(
              context: context,
              builder: (context) => AdventurePage());
        },
      ),
    );
  }

}

class AdventureListView extends StatelessWidget {
  final List<Adventure> lists;

  const AdventureListView({Key key, this.lists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return SingleChildScrollView(
        child: ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.only(
                top: 64.0 - kMinInteractiveDimension,
                bottom: 48.0 - kMinInteractiveDimension),
            children: List.generate(lists.length, (index) {
              Adventure list = lists[index];
              return ExpansionPanelRadio(
                  value: list,
                  canTapOnHeader: true,
                  headerBuilder: (context, expanded) => ListTile(
                      isThreeLine: true,
                      title: Text(list.displayName),
                      subtitle: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*Text(
                                '${VocabularyStorage.defaultVocabularies.map((e) => e.capitalize()).join(', ')}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),*/
                            Text(
                                'Size: ${list.tasks.isEmpty ? 'Empty' : list.tasks.length}')
                          ])),
                  body: Container(
                      margin: EdgeInsets.only(bottom: 10, right: 100),
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        buttonMinWidth: 64.0 * 1.2,
                        children: [
                          RaisedButton(
                            child: Text("Open"),
                            onPressed: () {
                              Redux.dispatch(AdventureOpen(list, index));
                              Navigator.pop(context);
                              /*FlutterUtils.pushPage(
                                  context: context,
                                  builder: (context) => AdventurePage());*/
                            },
                          ),
                          RaisedButton(
                            child: Text("Edit"),
                            onPressed: () {
                              Redux.dispatch(AdventureOpen(list, index));
                              /*FlutterUtils.pushPage(
                                  context: context,
                                  builder: (context) => AdventurePage());*/
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            child: Text("Delete"),
                            onPressed: () {
                              Redux.dispatch(AdventureListRemove(index));
                            },
                          )
                        ],
                      )));
            }).toList()));
  }
}