import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:flutter/cupertino.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/adventure/tasks/verbs/single_instance/pages.dart';
import 'package:json_annotation/json_annotation.dart';

part 'states.g.dart';

@JsonSerializable(explicitToJson: true)
class VerbInstanceTaskData extends AdventureTaskData {
  final VerbDefinition verb;
  final Set<Person> persons;

  VerbInstanceTaskData(String name, this.verb, this.persons) : super(name, TaskType.VERB_INSTANCE);

  @override
  Future<AdventureTask> createTask() async {
    return VerbInstanceTask(name, await Repositories.verbs.getVerb(verb), persons);
  }

  factory VerbInstanceTaskData.fromJson(Map<String, dynamic> json) => _$VerbInstanceTaskDataFromJson(json);

  Map<String, dynamic> toJson() => _$VerbInstanceTaskDataToJson(this);
  
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
