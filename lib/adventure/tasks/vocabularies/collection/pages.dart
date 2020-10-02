import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/adventure/tasks/common_widgets.dart';
import 'package:axolotl/adventure/tasks/vocabularies/collection/states.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VocabularyCollection extends StatelessWidget {
  final VocabularyCollectionTask task;
  final TaskState taskState;

  const VocabularyCollection({Key key, this.task, this.taskState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        DefaultTextStyle.of(context).style.merge(TextStyle(fontSize: 16));
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'Presente Examples',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                constraints: BoxConstraints.tightForFinite(
                    width: constraints.maxWidth * 0.8),
                child: DataTable(
                        columns: [
                          DataColumn(label: Text('Deutsch', style: style)),
                          DataColumn(label: Text('Español', style: style)),
                        ],
                        rows: [
                          ...List.generate(task.vocabularies.length, (index) {
                            VocabularyPair pair = task.vocabularies[index];
                            return DataRow(cells: [
                              DataCell(Center(
                                  child: Container(
                                      constraints:
                                      BoxConstraints.tightForFinite(
                                          width:
                                          constraints.maxWidth * 0.3),
                                      child: Text(pair?.given?.terms?.join('/')??'Loading...',
                                          style: style)))),
                              DataCell(Center(
                                child: Container(
                                  constraints: BoxConstraints.tightForFinite(
                                      width: constraints.maxWidth * 0.3),
                                  child: TaskTextField(
                                    taskState: taskState,
                                    fieldIndex: index++,
                                  ),
                                ),
                              ))
                            ]);
                          })
                        ],
                      ),
              ),
            ),
          )
        ]);
    /*return Column(
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
    );*/
  }
}
