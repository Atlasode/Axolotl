import 'package:axolotl/adventure/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerbCollection extends StatefulWidget {
  final VerbCollectionTask task;

  const VerbCollection({Key key, this.task}) : super(key: key);

  @override
  _VerbCollectionState createState() => _VerbCollectionState();
}

class _VerbCollectionState extends State<VerbCollection> {
  static const List<String> fieldLabels = [
    "Yo",
    "Tú",
    "Èl / Ella / Usted",
    "Nosotros/as",
    "Vosotros/as",
    "Ellos / Ellas / Ustedes"
  ];
  Map<int, TextEditingController> controllers = {};

  @override
  void initState() {
    widget.task.persons.forEach((person) {
      controllers[person.index] = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    controllers.forEach((index, element) => element.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.task.verb.displayInfinitive,
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          widget.task.verb.category.displayName,
          style: Theme.of(context).textTheme.subhead,
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListView(children: [
              ...controllers.map((index, value) {
                return MapEntry(
                    index,
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: fieldLabels[index]),
                      controller: value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    ));
              }).values
            ]),
          ),
        )
      ],
    );
  }
}
