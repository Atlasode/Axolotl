import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/adventure/tasks/verbs/blank_sentence/pages.dart';
import 'package:axolotl/constants.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:flutter/material.dart';

class VerbBlankText implements BlankText{

  final Verb verb;
  final Person person;
  final bool showPronoun;
  final bool showTense;

  const VerbBlankText(this.verb, this.person, {this.showPronoun = false, this.showTense = false});

  @override
  String getText() {
    return verb.getForm(person);
  }

  @override
  String getHintText() {
    StringBuffer buffer = StringBuffer();
    buffer.write(verb.infinitive);
    if(showPronoun){
      buffer.write('/${conjugationPronouns[person.index]}');
    }
    if(showTense){
      buffer.write('/${verb.category.displayName.toLowerCase()}');
    }
    return buffer.toString();
  }
}

class VerbTextAreaTask extends TextAreaTask {

  const VerbTextAreaTask(String name, List<TextSection> sections) :super(TaskType.VERB_SENTENCE, name, sections);

  @override
  Widget build(BuildContext context, TaskState taskState) {
    return VerbTextArea(task: this, taskState: taskState,);
  }

  @override
  String getDisplayName() {
    throw UnimplementedError();
  }

}