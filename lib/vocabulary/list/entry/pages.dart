import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/common/common_widgets.dart';
import 'package:axolotl/common/loading_widget.dart';
import 'package:axolotl/vocabulary/list/actions.dart';
import 'package:axolotl/vocabulary/list/edit/actions.dart';
import 'package:axolotl/vocabulary/list/edit/states.dart';
import 'package:axolotl/vocabulary/list/entry/actions.dart';
import 'package:axolotl/vocabulary/list/entry/states.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/utils/flutter_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class _CategoryCache {
  final CategoryCacheState state;
  final Iterable<DropdownMenuItem<String>> tenseItems;
  final Iterable<DropdownMenuItem<String>> moodItems;
  final AbstractInfo info;

  _CategoryCache(this.state, this.info)
      : this.tenseItems = state.tenses.map((tense) =>
            DropdownMenuItem<String>(value: tense, child: Text(tense))),
        this.moodItems = state.moods.map((tense) =>
            DropdownMenuItem<String>(value: tense, child: Text(tense)));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _CategoryCache &&
          runtimeType == other.runtimeType &&
          state == other.state &&
          info == other.info;

  @override
  int get hashCode => state.hashCode ^ info.hashCode;
}

class VocabularyEntryPage extends StatefulWidget {
  final ModelPageMode editMode;

  const VocabularyEntryPage(
      {Key key, this.editMode = ModelPageMode.CREATE})
      : super(key: key);

  @override
  _VocabularyEntryPageState createState() =>
      _VocabularyEntryPageState();
}

class _VocabularyEntryPageState extends State<VocabularyEntryPage> {

  @override
  void initState() {
    if (Redux.store.state.vocabularyList.currentEdit.categoryCache
            .loadingState ==
        LoadingState.NONE) {
      fetchCategoryDataAction();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InfoEntryState>(
        distinct: true,
        converter: (store) => store.state.vocabularyList.currentEdit.currentEdit,
        builder: (context, infoData) {
          AbstractInfoEntryState infoState = infoData as AbstractInfoEntryState;
          Widget typeEdit;
          InfoType selectedType = infoState.info.getType();
          switch (selectedType) {
            case InfoType.VERB_RANGE:
              typeEdit = StoreConnector<AppState, _CategoryCache>(
                distinct: true,
                converter: (store) => _CategoryCache(store.state.vocabularyList.currentEdit.categoryCache, infoState.info),
                builder: (context, data) {
                  if (data.state.loadingState == LoadingState.LOADING) {
                    return Text("");
                  }
                  return VerbRangeEdit(
                          categoryCache: data,
                          editMode: widget.editMode,
                          defaultState: data.info as VerbInfoRange);
                },
              );
              break;
            default:
              typeEdit = Text("Missing!");
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.editMode == ModelPageMode.CREATE
                  ? "Create Entry"
                  : "Edit Entry"),
            ),
            body: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<InfoType>(
                            items: [
                              DropdownMenuItem<InfoType>(
                                  value: InfoType.VERB_RANGE,
                                  child: Text("Verb Range")),
                              DropdownMenuItem<InfoType>(
                                  value: InfoType.VOCABULARY,
                                  child: Text("Vocabulary"))
                            ],
                            value: selectedType,
                            onChanged: (value) {
                              Redux.dispatch(VocabularyListEditChangeType(value));
                            },
                            elevation: 5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: typeEdit),
                          elevation: 5.0,
                        ),
                      )
                    ])),
            resizeToAvoidBottomInset: false,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                Redux.dispatch(VocabularyListEditFinish());
                Navigator.pop(context);
              },
            ),
          );
        });
  }
}

class VerbRangeEdit extends StatefulWidget {
  final _CategoryCache categoryCache;
  final ModelPageMode editMode;
  final VerbInfoRange defaultState;

  const VerbRangeEdit(
      {Key key, this.categoryCache, this.editMode, this.defaultState})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerbRangeEditState();
}

class _VerbRangeEditState extends State<VerbRangeEdit> {
  TextEditingController infinitiveController = TextEditingController();

  @override
  void initState() {
    if (widget.defaultState != null) {
      infinitiveController.text = widget.defaultState.infinitive;
    }
    super.initState();
  }

  @override
  void dispose() {
    infinitiveController.dispose();
    super.dispose();
  }

  Widget buildField(TextEditingController infinitiveController) {
    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration(
          controller: infinitiveController,
          onSubmitted: (infinitive){
            setInfinitive(infinitive);
          },
          decoration: InputDecoration(
            labelText: "Infinitive",
            icon: Icon(Icons.library_books),
          )),
      suggestionsCallback: (pattern) {
        return Stream.fromIterable(VocabularyStorage.defaultVocabularies)
            .map((e) => e.capitalize())
            .where((element) =>
            element.contains(RegExp(pattern, caseSensitive: false)))
            .toList();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Icon(Icons.apps),
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        setInfinitive(suggestion);
      },
    );
  }

  void setInfinitive(String infinitive) {
    infinitiveController.text = infinitive;
    Redux.dispatch(VerbSetInfinitive(infinitive));
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    var padding = data.padding;
    double height = data.size.height;
    double newHeight = height - padding.top - padding.bottom;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildField(infinitiveController),
        SizedBox(
          height: 18.0,
        ),
        Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(
                  vertical: Divider.createBorderSide(context, width: 2),
                )),
                height: newHeight - 420,
                child: StoreConnector<AppState, VerbEntryState>(
                  converter: (store) => store.state.vocabularyList.currentEdit.currentEdit as VerbEntryState,
                    builder: (context, data){
                      List<List<Widget>> categoryWidgets =
                      List.generate(data.categories.length, (index) {
                        return [
                          SizedBox(
                            height: 18.0,
                          ),
                          VerbCategoryEdit(categoryCache: widget.categoryCache, category: data.categories[index], index: index)
                        ];
                      });
                      List<Widget> widgetList = [];
                      if (categoryWidgets.isNotEmpty) {
                        widgetList.addAll(categoryWidgets.reduce((value, element) {
                          value.addAll(element);
                          return value;
                        }));
                      }
                    return SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...widgetList,
                  ],
                ));})),
            SizedBox(
              height: 6.0,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text("Add"),
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    onPressed: () {
                      Redux.dispatch(VerbAddCategory(VerbCategory(
                          tense: widget.categoryCache.state.tenses.first,
                          mood: widget.categoryCache.state.moods.first)));
                    },
                  )
                ])
          ],
        )
      ],
    );
  }
}

class VerbCategoryEdit extends StatelessWidget {
  final _CategoryCache categoryCache;
  final VerbCategory category;
  final int index;

  const VerbCategoryEdit(
      {Key key, this.categoryCache, this.category, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            border: Border(
              left: Divider.createBorderSide(context,
                  color: Theme.of(context).accentColor, width: 2),
            ),
          ),
          child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Tense"),
                                  SizedBox(width: 12),
                                  buildDropdown(categoryCache.tenseItems, true),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Mood"),
                                  SizedBox(width: 12),
                                  buildDropdown(categoryCache.moodItems, false)
                                ],
                              ),
                            ]),
                        IconButton(
                          icon: Icon(Icons.cancel, size: 22.0),
                          onPressed: () {
                            Redux.dispatch(VerbRemoveCategory(index));
                          },
                        ),
                      ]),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                      child: ExpansionTile(
                        title: Text("Persons", style: Theme.of(context).textTheme.bodyText1,),
                        children: [
                          /*Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [*/
                          ...List.generate(Person.values.length, (personIndex) =>
                              Row(
                                children: [
                                  Checkbox(
                                    value: category.personList.hasIndex(personIndex),
                                    onChanged: (value){
                                      Redux.dispatch(VerbUpdateCategory(category.copyWith(
                                        personList: category.personList.copyWith(
                                          index: personIndex,
                                          state:value
                                        )
                                      ), index));
                                      //Redux.dispatch(VerbUpdatePerson(value, index));
                                    },
                                  ),
                                  Text(Person.values[personIndex].toString().toLowerCase().replaceAll('_', ' ').replaceAll('person.', '').capitalize()),
                                ],
                              ))
                          /* ],
                         )*/
                        ],
                      ))
                ],
              ))),
    );
  }

  Container buildDropdown(
      Iterable<DropdownMenuItem<String>> items,
      bool tense) {
    VerbCategory newCategory;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(),
      ),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: items.toList(),
            value: tense ? category.tense : category.mood,
            onChanged: (value) {
              if (tense) {
                newCategory = category.copyWith(tense: value);
              } else {
                newCategory = category.copyWith(mood: value);
              }
              Redux.dispatch(VerbUpdateCategory(newCategory, index));
            },
            elevation: 5,
            dropdownColor: Colors.grey[200],
          )),
    );
  }

}
