import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/common/loading_widget.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/vocabulary/list/edit/pages.dart';
import 'package:axolotl/vocabulary/list/actions.dart';
import 'package:axolotl/vocabulary/list/states.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/utils/flutter_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class VocabularyListPage extends StatefulWidget {
  final String title;

  const VocabularyListPage({Key key, this.title = 'Vocabulary Lists'})
      : super(key: key);

  @override
  _VocabularyListPageState createState() => _VocabularyListPageState();
}

class _VocabularyListPageState extends State<VocabularyListPage> {
  @override
  void initState() {
    if (Redux.store.state.vocabularyList.loadingState == LoadingState.NONE) {
      fetchListsAction(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StoreConnector<AppState, VocabularyListState>(
        converter: (store) => store.state.vocabularyList,
        distinct: true,
        builder: (context, listState) {
          if (listState.loadingState == LoadingState.LOADING) {
            return LoadingWidget();
          }
          return VocabularyListView(lists: listState.lists);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {

          Redux.dispatch(VocabularyListOpen(VocabularyList.EMPTY, null));
          FlutterUtils.pushPage(
              context: context,
              builder: (context) => VocabularyListEditPage());
        },
      ),
    );
  }
}

class VocabularyListView extends StatelessWidget {
  final List<VocabularyList> lists;

  const VocabularyListView({Key key, this.lists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return SingleChildScrollView(
        child: ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.only(
                top: 64.0 - kMinInteractiveDimension,
                bottom: 48.0 - kMinInteractiveDimension),
            children: List.generate(lists.length, (index) {
              VocabularyList list = lists[index];
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
                            Text(
                                '${VocabularyStorage.defaultVocabularies.map((e) => e.capitalize()).join(', ')}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(
                                'Size: ${list.entries.isEmpty ? 'Empty' : list.entries.length}')
                          ])),
                  body: Container(
                      margin: EdgeInsets.only(bottom: 10, right: 100),
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        buttonMinWidth: 64.0 * 1.2,
                        children: [
                          RaisedButton(
                            child: Text("Select"),
                            onPressed: () {},
                          ),
                          RaisedButton(
                            child: Text("Edit"),
                            onPressed: () {
                              Redux.dispatch(VocabularyListOpen(list, index));
                              FlutterUtils.pushPage(
                                  context: context,
                                  builder: (context) => VocabularyListEditPage());
                            },
                          ),
                          RaisedButton(
                            child: Text("Delete"),
                            onPressed: () {
                              Redux.dispatch(VocabularyListRemove(index));
                            },
                          )
                        ],
                      )));
            }).toList()));
  }
}
