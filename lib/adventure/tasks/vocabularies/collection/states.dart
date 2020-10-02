import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/adventure/tasks/vocabularies/collection/pages.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:flutter/cupertino.dart';

class VocabularyCollectionTask extends AdventureTask {
  final List<VocabularyPair> vocabularies;
  final String firstLang;
  final String secondLang;

  VocabularyCollectionTask(String name, this.vocabularies, this.firstLang, this.secondLang) : super(TaskType.COLLECTION, name);

  @override
  Widget build(BuildContext context, TaskState taskState) {
    return VocabularyCollection(task: this, taskState: taskState,);
  }

  @override
  List<List<String>> createData() {
    return vocabularies.map((pair) => pair.expected.terms).toList();
   // return provider.getPairs().map((pair) => pair.expected.terms).toList();
  }

  @override
  String getDisplayName() {
    //return provider.getPairs().join(', ');
    return '';
  }

}

class VocabularyCollectionData extends AdventureTaskData{
  final List<VocabularyInfo> vocabularyInfo;
  final String firstLang;
  final String secondLang;

  VocabularyCollectionData(String name, this.vocabularyInfo, this.firstLang, this.secondLang) : super(name);

  @override
  Future<AdventureTask> createTask() async {
    return VocabularyCollectionTask(name, await Future.wait<VocabularyPair>(vocabularyInfo.map(
            (info) => Repositories.vocabularies.getPair(info))), firstLang, secondLang);
  }
}