import 'dart:collection';

import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axolotl/utils/common_utils.dart';

enum OptionEntry { FILTER }

class DictionaryPage extends StatelessWidget {
  final String title;

  const DictionaryPage({Key key, this.title = 'Dictionary'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DictionarySearch());
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
          child: CustomScrollView(
        slivers: [
          /*SliverAppBar(
            title: Text("Test"),
            pinned: true,
          ),*/
          SliverPadding(
              padding: EdgeInsets.all(10.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    String text = VocabularyStorage.defaultVocabularies[index];
                    return FutureBuilder<Verb>(
                      future: Repositories.verbRepository.getVerb(VerbDefinition(text)),
                      builder: (context, data){
                        if(data.data != null){
                          Verb verb = data.data;
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: Divider.createBorderSide(context, width: 2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(verb.infinitive.capitalize()),
                                  DataTable(
                                    columns: [
                                      DataColumn(label: Text('Pronombre')),
                                      DataColumn(label: Text('Conjugation'))
                                    ],
                                    rows: [
                                      DataRow(cells: [
                                        DataCell(Text('Yo')),
                                        DataCell(Text(verb.forms[0]))
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Tú')),
                                        DataCell(Text(verb.forms[1]))
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('El / Ella / Usted')),
                                        DataCell(Text(verb.forms[2]))
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Nosotros / Nosotras')),
                                        DataCell(Text(verb.forms[3]))
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Vosotros / Vosotras')),
                                        DataCell(Text(verb.forms[4]))
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Ellos / Ellas/ Ustedes')),
                                        DataCell(Text(verb.forms[5]))
                                      ])
                                    ],
                                  ),
                              ],
                            ),
                          );
                        }
                        return ListTile(
                          title: Text("Waiting..."),
                        );
                      },
                    );
                  },
                  childCount: VocabularyStorage.defaultVocabularies.length,
                ),
              ))
        ],
      )),
    );
  }
}

class DictionarySearch extends SearchDelegate {
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
        future: Future.microtask(() => [...VocabularyStorage.defaultVocabularies,
          ...VocabularyStorage.defaultVocabularies,
          ...VocabularyStorage.defaultVocabularies].where((e) => e.contains(query)).toList()),
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
        future: Future.microtask(() => [...VocabularyStorage.defaultVocabularies,
        ...VocabularyStorage.defaultVocabularies,
        ...VocabularyStorage.defaultVocabularies].where((e) => e.contains(query)).toList()),
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
