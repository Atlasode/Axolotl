import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/adventure/tasks/common_widgets.dart';
import 'package:axolotl/adventure/tasks/verbs/single_instance/states.dart';
import 'package:axolotl/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerbSingleInstance extends StatelessWidget {
  final VerbInstanceTask task;
  final TaskState taskState;

  const VerbSingleInstance({Key key, this.task, this.taskState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.verb.displayInfinitive,
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          task.verb.category.displayName,
          style: Theme.of(context).textTheme.subhead,
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListView(children: [
              ...List.generate(6, (index)=>TaskTextField(
                      taskState: taskState,
                      fieldIndex: index,
                      label: conjugationPronouns[index],
                    )
                   /* TextFormField(
                      decoration:
                          InputDecoration(labelText: fieldLabels[index]),
                      controller: value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    )*/)
            ]),
          ),
        )
      ],
    );
  }
}
