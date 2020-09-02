import 'package:axolotl/vocabulary/vocabulary.dart';

abstract class VocabularyRepository {

  Future<VocabularyData> getData(VocabularyDefinition entry);

  Future<VocabularyPair> getPair(VocabularyInfo info);
}

class SQLVocRepository extends VocabularyRepository {
  @override
  Future<VocabularyData> getData(VocabularyDefinition entry) {
    throw UnimplementedError();
  }

  @override
  Future<VocabularyPair> getPair(VocabularyInfo info) {
    info.
    throw UnimplementedError();
  }

}