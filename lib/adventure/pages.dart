import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/adventure/tasks/verbs/blank_sentense/pages.dart';
import 'package:axolotl/adventure/tasks/verbs/collection/pages.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:flutter/material.dart';

class AdventurePage extends StatefulWidget {
  final String title;

  const AdventurePage({this.title = 'Adventure'});

  @override
  State<StatefulWidget> createState() => _AdventurePageState();
}

class _AdventurePageState extends State<AdventurePage> {
  List<Widget> taskWidgets = [];
  int index;

  @override
  void initState() {
    index = 0;
    wait();
    super.initState();
  }

  void wait() async {
    taskWidgets = [
      VerbTextArea(
        task: VerbTextAreaTask(
          'Test',
          [TextSection(
              [ 'Hoy Luis y María', 'con nosotros.'],
              [VerbBlankText(await Repositories.verbRepository.getVerb(VerbDefinition('comer')), Person.THIRD_PLURAL, showPronoun: true)]
          ),
          TextSection(
            ['Antes','comer en la cafetería.'],
            [VerbBlankText(await Repositories.verbRepository.getVerb(VerbDefinition('soler')), Person.FIRST_SINGULAR, showPronoun: true, showTense: true)]
          )],
        ),
      ),
      VerbCollection(
        task: VerbCollectionTask(
            "Test",
            await Repositories.verbRepository.getVerb(VerbDefinition('comer')),
            Person.values.toSet()),
      )
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.title),
    ),
    body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: taskWidgets.isNotEmpty ? taskWidgets[index] : Text('Loading'),
            ))));
  }
}
