import 'package:axolotl/adventure/actions.dart';
import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/adventure/tasks/common_widgets.dart';
import 'package:axolotl/adventure/tasks/verbs/blank_sentence/states.dart';
import 'package:axolotl/common/app_state.dart';
import 'package:flutter/material.dart';

class VerbTextArea extends StatelessWidget {
  final TextAreaTask task;
  final TaskState taskState;

  const VerbTextArea({Key key, this.task, this.taskState}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(
        title: Text('Presente Examples', style: Theme.of(context).textTheme.headline5,),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          ...List.generate(task.sections.length, (sectionIndex) {
            TextSection section = task.sections[sectionIndex];
            List<InlineSpan> spans = [];
            List<String> texts = section.getTexts();
            for (int i = 0; i < (texts.length / 2).floor(); i++) {
              TextStyle style = fieldStyle(context, taskState, sectionIndex);
              double width = blankFieldSize(section.blanks[i].getText(), style).width;
              spans.add(TextSpan(
                  style: blankTextStyle(context),
                  text:
                      '${texts[i * 2]} (${section.blanks[i].getHintText()}) '));
              spans.add(WidgetSpan(
                  child: Container(
                      width: width * 2, height: 20, child: TaskTextField(taskState: taskState, fieldIndex: sectionIndex, selection: false))));
              spans.add(TextSpan(text: texts[i * 2 + 1]));
            }
            return <Widget>[
              RichText(
                text: TextSpan(
                    style: blankTextStyle(context),
                    children: [...spans]),
              )
            ];
          }).reduce((value, element) {
            value.add(SizedBox(height: 10));
            value.addAll(element);
            return value;
          })
        ]),
      )
    ]);
  }
}
