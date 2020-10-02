
import 'package:axolotl/adventure/actions.dart';
import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/common/app_state.dart';
import 'package:flutter/material.dart';

TextStyle blankTextStyle(BuildContext context){
  return DefaultTextStyle.of(context).style.merge(TextStyle(fontSize: 16));
}

TextStyle fieldStyle(BuildContext context, TaskState taskState, int fieldIndex) {
  TextStyle textStyle = blankTextStyle(context);
  TextStyle fieldStyle = textStyle.merge(TextStyle(fontWeight: FontWeight.bold));
  TextStyle style = fieldStyle;
  if(taskState.hasError(fieldIndex)) {
    style = style.copyWith(color: Theme.of(context).errorColor);
  }
  if(taskState.isValid(fieldIndex)) {
    style = style.copyWith(color: Colors.green[800]);
  }
  return style;
}

TextField buildField(
    {BuildContext context,
    TaskState taskState,
    int fieldIndex,
    TextEditingController controller}){
  TextStyle style = fieldStyle(context, taskState, fieldIndex);
  return TextField(style: style, enableInteractiveSelection: false, controller: controller, onChanged:(value){
    Redux.dispatch(AdventureUpdateField(value, fieldIndex));
    //widget.taskState.currentValues[sectionIndex] = value;
  });
}

Size blankFieldSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

class TaskTextField extends StatefulWidget {
  final TaskState taskState;
  final int fieldIndex;
  final bool selection;
  final String label;

  const TaskTextField({Key key, this.taskState, this.fieldIndex, this.selection = false, this.label}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_TaskTextFieldState();

}

class _TaskTextFieldState extends State<TaskTextField> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.taskState.getValue(widget.fieldIndex));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = fieldStyle(context, widget.taskState, widget.fieldIndex);
    if(widget.taskState.hasError(widget.fieldIndex)) {
      style = style.copyWith(color: Theme.of(context).errorColor);
    }
    return TextField(
        style: style,
        enableInteractiveSelection: widget.selection,
        controller: controller,
        decoration: widget.label != null ? InputDecoration(labelText: widget.label) : const InputDecoration(),
        onChanged:(value){
      Redux.dispatch(AdventureUpdateField(value, widget.fieldIndex));
      //widget.taskState.currentValues[sectionIndex] = value;
    });
  }

}