import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/adventure/tasks/verbs/blank_sentence/states.dart';
import 'package:flutter/material.dart';

class VerbTextArea extends StatefulWidget {
  final VerbTextAreaTask task;

  const VerbTextArea({Key key, this.task}) : super(key: key);

  @override
  VerbTextAreaState createState() => VerbTextAreaState();
}

class VerbTextAreaState extends State<VerbTextArea> {

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = DefaultTextStyle.of(context).style.merge(TextStyle(fontSize: 16));
    TextStyle fieldStyle = textStyle.merge(TextStyle(fontWeight: FontWeight.bold));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(
        title: Text('Presente Examples', style: Theme.of(context).textTheme.headline5,),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          ...widget.task.sections.map((section) {
            List<InlineSpan> spans = [];
            for (int i = 0; i < (section.texts.length / 2).floor(); i++) {
              double width = _textSize(section.blanks[i].getText(), fieldStyle).width;
              spans.add(TextSpan(
                  text:
                      '${section.texts[i * 2]} (${section.blanks[i].getHintText()}) '));
              spans.add(WidgetSpan(
                  child: Container(
                      width: width * 2, height: 20, child: TextField(style: fieldStyle, enableInteractiveSelection: false))));
              spans.add(TextSpan(text: section.texts[i * 2 + 1]));
            }
            return <Widget>[
              RichText(
                text: TextSpan(
                    style: textStyle,
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

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
