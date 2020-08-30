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
  final ModelPageMode mode;

  const VocabularyListEditPage({Key key, this.mode})
      : super(key: key);

  @override
  _VocabularyListEditPageState createState() => _VocabularyListEditPageState();
}

class _VocabularyListEditPageState extends State<VocabularyListEditPage> {
  //TODO: Force input so you can not create files with no name
  final TextEditingController nameController = TextEditingController();
  bool initedController = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.mode == ModelPageMode.EDIT ? 'Edit List' : 'Create List'),
        leading: BackButton(),
      ),
      body: StoreConnector<AppState, VocabularyListEditState>(
        converter: (store) => store.state.vocabularyList.currentEdit,
        distinct: true,
        builder: (context, listState) {
          if(!initedController){
            nameController.text = listState.name;
            initedController = true;
          }
          return Form(
            key: _formKey,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      icon: Icon(Icons.library_books),
                      border: OutlineInputBorder()),
                  onChanged: (text){
                    Redux.dispatch(VocabularyListEditSetName(text));
                  },
                  validator: (text){
                    if(text.isEmpty){
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
              ),
              RaisedButton(child: Text('Add Entry'),
              onPressed: (){
                Redux.dispatch(VocabularyListEditOpen(VerbInfoRange(""), null));
                FlutterUtils.pushPage(
                    context: context,
                    builder: (context) =>
                        VocabularyEntryPage(editMode: ModelPageMode.CREATE));
              },),
              VocabularyListEditView(entries: List.of(listState.infoEdits)),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          if(_formKey.currentState.validate()){
            Redux.dispatch(VocabularyListFinish());
            Navigator.maybePop(context);
          }
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
                              Redux.store.dispatch(
                                  VocabularyListEditOpen(info, index));
                              FlutterUtils.pushPage(
                                context: context,
                                builder: (context) => VocabularyEntryPage(
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
