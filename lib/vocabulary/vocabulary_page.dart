import 'dart:math';

import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/common/common_widgets.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

List<Alignment> cardsAlign = [
  Alignment(0.0, 1.0),
  Alignment(0.0, 0.8),
  Alignment(0.0, 0.0)
];
List<Size> cardsSize = List(3);

//Stores the currently selected vocabulary list
class VocabularyStorage {
  static const List<String> defaultVocabularies = [
    "comer",
    "abordar",
    "abortar",
    "acabar",
    "detenerse",
    "echarse",
    "enflaquecer",
    "esquiar"
  ];
  List<String> vocabularies = VocabularyStorage.defaultVocabularies;
}

class VocabularyPage extends StatefulWidget {
  final String title;

  static Provider createProvider() {
    return Provider<VocabularyStorage>(
      create: (context)=> VocabularyStorage(),
    );
  }

  const VocabularyPage({Key key, this.title = 'Vocabulary List'}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> right;
  int flag = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    right = new Tween<double>(begin: 0.0, end: 400.0).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  void open() {
    _controller.fling(velocity: 1.0);
  }

  void close() {
    _controller.fling(velocity: -1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _controller.forward();
    } on TickerCanceled {}
  }

  swipeRight() {
    if (flag == 0)
      setState(() {
        flag = 1;
      });
    _swipeAnimation();
  }

  swipeLeft() {
    if (flag == 1)
      setState(() {
        flag = 0;
      });
    _swipeAnimation();
  }

  void _handleDragDown(DragDownDetails details) {}

  void _handleDragCancel() {}

  void _move(DragUpdateDetails details) {}

  void _settle(DragEndDetails details) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                  onHorizontalDragDown: _handleDragDown,
                  onHorizontalDragUpdate: _move,
                  onHorizontalDragEnd: _settle,
                  onHorizontalDragCancel: _handleDragCancel,
                  child: LayoutBuilder(
                      builder: (context, constraints)=> Stack(
                    children: [
                      new Positioned(
                        height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          child: VocabularyCard(),
                      ),
                    ],
                  ))),
            ),
          ),
        ],
      ),
    );
  }
}

class VocabularyCard extends StatefulWidget {
  @override
  _VocabularyCardState createState() => _VocabularyCardState();

}

class _VocabularyCardState extends State<VocabularyCard> {
  static const List<String> fieldLabels = [
    "Yo",
    "Tú",
    "Èl / Ella / Usted",
    "Nosotros/as",
    "Vosotros/as",
    "Ellos / Ellas / Ustedes"
  ];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    controllers.add(TextEditingController());
    controllers.add(TextEditingController());
    controllers.add(TextEditingController());
    controllers.add(TextEditingController());
    controllers.add(TextEditingController());
    controllers.add(TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    controllers.forEach((element) => element.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:  Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comer',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                'Indicativo Presente',
                style: Theme.of(context).textTheme.subhead,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView(
                      children: [
                        ...List.generate(
                            6,
                                (i) => TextFormField(
                              decoration: InputDecoration(
                                  labelText: fieldLabels[i]),
                              controller: controllers[i],
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                return null;
                              },
                            ))
                      ]),
                ),
              )
            ],
          )),
    );
  }

}
