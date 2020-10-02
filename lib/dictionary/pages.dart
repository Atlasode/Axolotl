import 'dart:collection';
import 'dart:math';

import 'package:axolotl/common/loading_widget.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axolotl/utils/common_utils.dart';

enum OptionEntry { FILTER }

class DictionaryOptionButton {
  static List<DictionaryOptionButton> buttons = [
    DictionaryOptionButton('Search', Icons.search, (context, state) async {
      String infinitive = await showSearch(context: context, delegate: DictionarySearch());
      state.setInfinitive(infinitive);
    }),
    DictionaryOptionButton('Add', Icons.add, (context, state) {

    }),
    DictionaryOptionButton('Edit', Icons.create, (context, state) {

    }),
    DictionaryOptionButton('Settings', Icons.settings, (context, state) {

    })
  ];

  final String title;
  final IconData icon;
  final void Function(BuildContext context, _DictionaryPageState state) onPressed;

  DictionaryOptionButton(this.title, this.icon, this.onPressed);
}

class _DictionaryPageState extends State<DictionaryPage> {
  Map<String, GlobalKey> keys = {};
  String infinitive;

  @override
  void initState() {
    super.initState();
  }

  void setInfinitive(String infinitive){
    setState(() {
      this.infinitive = infinitive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: infinitive != null
            ? AppBar(
                title: Text(infinitive.capitalize()),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setInfinitive(null);
                  },
                ),
              )
            : null,
        actions: [
          ...DictionaryOptionButton.buttons.map((button) => IconButton(
            icon: Icon(button.icon),
            onPressed: ()=>button.onPressed(context, this),
          ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    trailing: Icon(
                      Icons.library_books,
                      size: 40,
                    ),
                    title: Text('Drawer Header'),
                    subtitle: infinitive != null ? Text(infinitive.capitalize(), style: Theme.of(context).textTheme.subtitle2,) : null,
                    contentPadding: EdgeInsets.zero,
                  )
                ],
              ),
            ),
            ...VerbCategory.categoriesByMood.entries
                .map((entry) => ExpansionTile(
                      title: Text(entry.key.capitalize()),
                      children: [
                        ...entry.value.map((category) => ListTile(
                              title: Text(category.tense),
                              dense: true,
                              onTap: () {
                                Scrollable.ensureVisible(
                                    keys[category.mood + "_" + category.tense]
                                        .currentContext);
                              },
                            ))
                      ],
                    ))
          ],
        ),
      ),
      body: Container(child: Builder(builder: (context) {
        if (infinitive == null) {
          return new Center(
              child: new Container(
                  height: 440,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(50),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: [
                      ...DictionaryOptionButton.buttons.map((button) => Column(
                            children: [
                              IconButton(
                                  icon: Icon(button.icon),
                                  iconSize: 100,
                                  onPressed: ()=>button.onPressed(context, this)),
                              Text(button.title)
                            ],
                          )),
                    ],
                  )));
        }
        return FutureBuilder<Iterable<Verb>>(
            future: Future.wait(VerbCategory.validCategories.map((category) =>
                Repositories.verbs
                    .getVerb(VerbDefinition(infinitive, category)))),
            builder: (context, data) {
              Iterable<Verb> verbs = data.data;
              if (verbs == null) {
                return const LoadingWidget();
              }
              return SingleChildScrollView(
                  child: Column(
                    children: [
                      ...verbs.map((verb){
                VerbCategory category = verb.category;
                return ExpansionTile(
                  title: Text('${category.mood} ${category.tense}'),
                  subtitle: Text(verb.verbEnglish),
                  key: keys.putIfAbsent(
                      category.mood + "_" + category.tense,
                          () => GlobalKey(
                          debugLabel:
                          category.mood + "_" + category.tense)),
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: VerbTable(verb))
                  ],);
              }
                      )],
                  )/*ExpansionPanelList.radio(
                      expandedHeaderPadding: EdgeInsets.only(
                          top: 64.0 - kMinInteractiveDimension,
                          bottom: 48.0 - kMinInteractiveDimension),
                      children: verbs.map((verb) {
                        VerbCategory category = verb.category;
                        return ExpansionPanelRadio(
                          value: verb,
                          canTapOnHeader: true,
                          headerBuilder: (context, expanded) => ListTile(
                            title: Text('${category.mood} ${category.tense}'),
                            subtitle: Text(verb.verbEnglish),
                            key: keys.putIfAbsent(
                                category.mood + "_" + category.tense,
                                () => GlobalKey(
                                    debugLabel:
                                        category.mood + "_" + category.tense)),
                          ),
                          body: SizedBox(
                              width: double.infinity,
                              child: VerbTable(verb)),
                        );
                      }).toList())*/);
            });
      })),
    );
  }
}

class VerbTable extends StatelessWidget {
  final Verb verb;

  VerbTable(this.verb);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Pronombre')),
        DataColumn(label: Text('Conjugation')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('Yo')),
          DataCell(Text(verb.forms[0]))
        ]),
        DataRow(cells: [
          const DataCell(Text('Tú')),
          DataCell(Text(verb.forms[1]))
        ]),
        DataRow(cells: [
          const DataCell(Text('El / Ella / Usted')),
          DataCell(Text(verb.forms[2]))
        ]),
        DataRow(cells: [
          const DataCell(Text('Nosotros / Nosotras')),
          DataCell(Text(verb.forms[3]))
        ]),
        DataRow(cells: [
          const DataCell(Text('Vosotros / Vosotras')),
          DataCell(Text(verb.forms[4]))
        ]),
        DataRow(cells: [
          const DataCell(Text('Ellos / Ellas/ Ustedes')),
          DataCell(Text(verb.forms[5]))
        ])
      ],
    );
  }
}

class DictionaryPage extends StatefulWidget {
  final String title;

  const DictionaryPage({Key key, this.title = 'Dictionary'}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DictionaryPageState();
}

class DictionaryVerb {}

class DictionarySearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<String>>(
        initialData: [],
        future: Repositories.verbs.getVerbsQuery(query),
        builder: (context, data) {
          return Container(
              child: CustomScrollView(
            slivers: [
              SliverPadding(
                  padding: EdgeInsets.all(10.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        String text = data.data[index];
                        return ListTile(
                          title: Text(text.capitalize()),
                          onTap: () {
                            close(context, text);
                          },
                        );
                      },
                      childCount: data.data.length,
                    ),
                  ))
            ],
          ));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
        initialData: [],
        future: Repositories.verbs.getVerbsQuery(query),
        builder: (context, data) {
          return Container(
              child: CustomScrollView(
            slivers: [
              SliverPadding(
                  padding: EdgeInsets.all(10.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        String text = data.data[index];
                        return ListTile(
                          title: Text(text.capitalize()),
                          onTap: () {
                            query = text;
                            showResults(context);
                          },
                        );
                      },
                      childCount: data.data.length,
                    ),
                  ))
            ],
          ));
        });
  }
}
