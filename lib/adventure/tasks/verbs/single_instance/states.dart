import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:flutter/cupertino.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/adventure/tasks/verbs/single_instance/pages.dart';

class VerbInstanceTaskData extends AdventureTaskData {
  final VerbDefinition verb;
  final Set<Person> persons;

  VerbInstanceTaskData(String name, this.verb, this.persons) : super(name);

  @override
  Future<AdventureTask> createTask() async {
    return VerbInstanceTask(name, await Repositories.verbs.getVerb(verb), persons);
  }
  
}

class VerbInstanceTask extends AdventureTask<String> {
  final Verb verb;
  final Set<Person> persons;

  VerbInstanceTask(String name, this.verb, this.persons) : super(TaskType.VERB_INSTANCE, name);

  @override
  Widget build(BuildContext context, TaskState taskState) {
    return VerbSingleInstance(task: this, taskState: taskState,);
  }

  @override
  String getDisplayName() {
    return verb.infinitive.capitalize();
  }

  @override
  List<List<String>> createData() {
    return persons.map((e) => [verb.getForm(e)]).toList();
  }

}
