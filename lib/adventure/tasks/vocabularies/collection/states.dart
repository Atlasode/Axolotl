import 'package:axolotl/adventure/states.dart';
import 'package:flutter/cupertino.dart';

class VocabularyCollectionTask extends AdventureTask {
  final VocabularyProvider provider;

  VocabularyCollectionTask(String name, this.provider) : super(TaskType.VOCABULARY_COLLECTION, name);

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  String getDisplayName() {
    return provider.getPairs().join(', ');
  }

}