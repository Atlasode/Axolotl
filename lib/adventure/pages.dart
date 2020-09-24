import 'dart:math';

import 'package:axolotl/adventure/actions.dart';
import 'package:axolotl/adventure/list/pages.dart';
import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/adventure/tasks/verbs/blank_sentence/pages.dart';
import 'package:axolotl/adventure/tasks/verbs/blank_sentence/states.dart';
import 'package:axolotl/adventure/tasks/verbs/collection/pages.dart';
import 'package:axolotl/adventure/tasks/verbs/collection/states.dart';
import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/common/common_widgets.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/utils/flutter_utils.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AdventureOptionButton {
  static List<AdventureOptionButton> buttons = [
    AdventureOptionButton('Select', Icons.refresh, (context) async {
      FlutterUtils.pushPage(
          context: context, builder: (context) => AdventureListPage());
    }, bar: false),
    AdventureOptionButton('Back', Icons.arrow_back, (context) async {
      Redux.dispatch(AdventureClose());
    },
        screen: false),
    AdventureOptionButton('Add', Icons.add, (context) {}),
    AdventureOptionButton('Edit', Icons.create, (context) {}),
    AdventureOptionButton('Settings', Icons.settings, (context) {})
  ];

  final String title;
  final IconData icon;
  final bool bar;
  final bool screen;
  final void Function(BuildContext context)
      onPressed;

  AdventureOptionButton(this.title, this.icon, this.onPressed,
      {this.bar = true, this.screen = true});
}

class AdventurePage extends StatelessWidget {
  final String title;

  const AdventurePage({this.title = 'Adventure'});

  static Widget createBottomView(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 80,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: VocabularyView()
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            ...AdventureOptionButton.buttons
                .where((element) => element.bar)
                .map((button) => IconButton(
                      icon: Icon(button.icon),
                      onPressed: () => button.onPressed(context),
                    ))
          ],
        ),
        body: StoreConnector<AppState, AdventureState>(
            converter: (store) => store.state.adventureState,
            distinct: true,
            builder: (context, state) {
              if (state.adventure.isEmpty) {
                return Center(
                    child: Container(
                        height: 440,
                        child: GridView.count(
                          primary: false,
                          padding: const EdgeInsets.all(50),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: [
                            ...AdventureOptionButton.buttons
                                .where((element) => element.screen)
                                .map((button) => Column(
                                      children: [
                                        IconButton(
                                            icon: Icon(button.icon),
                                            iconSize: 100,
                                            onPressed: () => button.onPressed(
                                                context)),
                                        Text(button.title)
                                      ],
                                    )),
                          ],
                        )));
              }
              int index = min(state.taskIndex, state.adventure.tasks.length - 1);
              return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                      elevation: 5.0,
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: state.adventure.tasks[index]
                              .build(context, state.taskStates[index]))));
            }),
    );
  }
}

class VocabularyView extends StatefulWidget {

  const VocabularyView({Key key}) : super(key: key);

  @override
  _VocabularyViewState createState() => _VocabularyViewState();

}

class _VocabularyViewState extends State<VocabularyView> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AdventureState>(
        converter: (store)=>store.state.adventureState,
        builder: (context, state){
          if(state.adventure.isEmpty){
            return Container();
          }
          BoxDecoration selected = BoxDecoration(
              boxShadow: [
                 BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]
          );
          return Container(
          //elevation: 5.0,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 38,
                          onPressed: state.hasPrevious ? (){
                            Redux.dispatch(AdventureMovePage(false));
                          } : null,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${state.taskIndex + 1} / ${state.taskStates.length}",
                              style: TextStyle(fontSize: 18),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(state.taskStates.length, (index) {
                                  Color color = getDiffColor(state.taskStates[index].diff);
                                  return <Widget>[
                                    Container(child: CircleColor(color: color, circleSize: 20, elevation: 5,),
                                      decoration: index == state.taskIndex ? selected : null,)
                                  ];}).reduce((value, element){
                                  value.add(SizedBox(width: 20,));
                                  value.addAll(element);
                                  return value;
                                })
                              ],
                            )
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          iconSize: 38,
                          onPressed: state.hasNext ? (){
                            Redux.dispatch(AdventureMovePage(true));
                          } : null,
                        ),
                      ],
                    ),
          ),
        );});
  }
}
