import 'dart:io';

import 'package:axolotl/adventure/list/pages.dart';
import 'package:axolotl/adventure/pages.dart';
import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/dictionary/pages.dart';
import 'package:axolotl/vocabulary/list/pages.dart';
import 'package:axolotl/vocabulary/list/states.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';
import 'package:redux/redux.dart';

void main() async {
  await Redux.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Repositories.verbRepository.hashCode;
    return StoreProvider<AppState>(
        store: Redux.store,
        child: MaterialApp(
      title: 'Axolotl',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    ));
  }
}

class PageTab {
  final WidgetBuilder bottomBar;
  final BottomNavigationBarItem item;
  final Widget page;

  const PageTab({this.bottomBar, this.item, this.page});
}

class HomePage extends StatefulWidget {
  final List<PageTab> tabs;

  const HomePage(
      {Key key,
      this.tabs = const [
        PageTab(
            item: BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            page: VocabularyPage()),
        PageTab(
            item: BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('All Lists'),
            ),
            page: VocabularyListPage()),
        PageTab(
            bottomBar: AdventurePage.createBottomView,
            item: BottomNavigationBarItem(
              icon: Icon(Icons.view_module),
              title: Text('Adventure'),
            ),
            page: AdventurePage()),
        PageTab(
          item: BottomNavigationBarItem(
            title: Text('Dictionary'),
            icon: Icon(Icons.apps)
          ),
          page: DictionaryPage()
        )
      ]})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  static void onTab(BuildContext context, int index) {
    context.findAncestorStateOfType<_HomePageState>().onTabTapped(index);
  }

  void onTabTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [VocabularyPage.createProvider()],
        child: Scaffold(
          body: widget.tabs[_index].page,
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(widget.tabs[_index].bottomBar != null)
                widget.tabs[_index].bottomBar(context),
              BottomNavigationBar(
                currentIndex: _index,
                onTap: onTabTapped,
                type: BottomNavigationBarType.fixed,
                items: [...widget.tabs.map((tab) => tab.item)],
              ),
            ],
          ),
        ));
  }
}
