import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/common/common_widgets.dart';
import 'package:axolotl/common/loading_widget.dart';
import 'package:axolotl/vocabulary/list/actions.dart';
import 'package:axolotl/vocabulary/list/edit/actions.dart';
import 'package:axolotl/vocabulary/list/edit/states.dart';
import 'package:axolotl/vocabulary/list/entry/pages.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/utils/flutter_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class VocabularyListEditPage extends StatefulWidget {
  final VocabularyList list;
  final ModelPageMode mode;

  const VocabularyListEditPage({Key key, @required this.list, this.mode})
      : super(key: key);

  @override
  _VocabularyListEditPageState createState() => _VocabularyListEditPageState();
}

class _VocabularyListEditPageState extends State<VocabularyListEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.displayName),
        leading: BackButton(onPressed: (){
          Redux.dispatch(VocabularyListFinish());
          Navigator.maybePop(context);
        }),
      ),
      body: StoreConnector<AppState, VocabularyListEditState>(
        converter: (store) => store.state.vocabularyList.currentEdit,
        distinct: true,
        builder: (context, listState) {
          return VocabularyListEditView(entries: List.of(listState.infoEdits));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FlutterUtils.pushPage(
              context: context,
              builder: (context) => VocabularyEntryPage(
                    editMode: ModelPageMode.CREATE,
                    info: VerbInfoRange(""),
                  ));
        },
      ),
    );
  }
}

class VocabularyListEditView extends StatelessWidget {
  final List<AbstractInfo> entries;

  const VocabularyListEditView({Key key, this.entries}) : super(key: key);

  Widget _buildEntry(AbstractInfo info) {
    switch (info.getType()) {
      /*case InfoType.VERB:
        VerbInfo info = pair.provider as VerbInfo;
        return ListTile(
            title: Text(info.infinitive.capitalize()),
            subtitle: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Mood: ${info.mood}'),
                      SizedBox(width: 15,),
                      Text('Tense: ${info.tense}')
                    ],
                  )
                ]));*/
      case InfoType.VERB_RANGE:
        VerbInfoRange rangeInfo = info as VerbInfoRange;
        return ListTile(
            title: Text(rangeInfo.infinitive.capitalize()),
            subtitle: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rangeInfo.categories
                      .map((e) => '${e.mood} ${e.tense}')
                      .join(', '))
                ]));
      case InfoType.VOCABULARY:
      case InfoType.NONE:
      default:
        return LoadingWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return SingleChildScrollView(
        child: ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.only(
                top: 64.0 - kMinInteractiveDimension,
                bottom: 48.0 - kMinInteractiveDimension),
            children: List.generate(entries.length, (index) {
              AbstractInfo info = entries[index];
              return ExpansionPanelRadio(
                  value: info,
                  canTapOnHeader: true,
                  headerBuilder: (context, expanded) => _buildEntry(info),
                  body: Container(
                      margin: EdgeInsets.only(bottom: 10, right: 100),
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        buttonMinWidth: 64.0 * 1.5,
                        children: [
                          RaisedButton(
                            child: Text("Edit"),
                            onPressed: () {
                              Redux.store.dispatch(VocabularyListEditOpen(
                                  info, index));
                              FlutterUtils.pushPage(
                                context: context,
                                builder: (context) => VocabularyEntryPage(
                                  info: info,
                                  editMode: ModelPageMode.EDIT,
                                ),
                              );
                            },
                          ),
                          RaisedButton(
                            child: Text("Delete"),
                            onPressed: () {
                              Redux.dispatch(
                                  VocabularyListEditRemoveInfo(index));
                            },
                          )
                        ],
                      )));
            }).toList()));
  }
}
