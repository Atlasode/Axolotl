import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:flutter/cupertino.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/adventure/tasks/verbs/collection/pages.dart';

class VerbCollectionTask extends AdventureTask<String> {
  final Verb verb;
  final Set<Person> persons;

  VerbCollectionTask(String name, this.verb, this.persons) : super(TaskType.VERB_COLLECTION, name);

  @override
  Widget build(BuildContext context) {
    return VerbCollection(task: this);
  }

  @override
  String getDisplayName() {
    return verb.infinitive.capitalize();
  }

  @override
  List<String> createData() {
    return persons.map((e) => verb.getForm(e)).toList();
  }

}
