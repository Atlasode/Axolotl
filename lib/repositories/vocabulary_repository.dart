import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

abstract class VocabularyRepository {
  Future<VocabularyData> getVocabulary(VocabularyDefinition entry);

  Future<VocabularyPair> getPair(VocabularyInfo info);
}

class VocFirebaseRepository implements VocabularyRepository {
  final String collectionVocabularies = 'vocabularies';

  @override
  Future<VocabularyPair> getPair(VocabularyInfo info) async {
    return VocabularyPair(info.id, await getVocabulary(info.getGiven()),
        await getVocabulary(info.getExpected()));
  }

  @override
  Future<VocabularyData> getVocabulary(VocabularyDefinition entry) async {
    var snap = await Firestore.instance
        .collection(collectionVocabularies)
        .document('${entry.id}_${entry.langKey}')
        .get();
    return VocabularyData.fromJson(snap.data);
  }
}

class SQLVocRepository extends VocabularyRepository {
  final String tableVocabularies = 'vocabularies';
  final String columnID = 'id';
  final String columnLangKey = 'lang_key';
  final String columnTerm = 'term';

  BehaviorSubject<bool> ready = BehaviorSubject.seeded(false);
  BehaviorSubject<Database> database = new BehaviorSubject<Database>();
  BehaviorSubject<Set<String>> langKeys =
      new BehaviorSubject<Set<String>>.seeded({});
  BehaviorSubject<Set<String>> vocabularyKeys =
      new BehaviorSubject<Set<String>>.seeded({});

  void _checkState() {
    if (ready.value == null) {
      throw StateError("Getter was called before the database was opened");
    }
    if (database.value == null) {
      throw StateError("Failed to create the database");
    }
  }

  @override
  Future<VocabularyData> getVocabulary(VocabularyDefinition definition) async {
    _checkState();
    if (database.value == null) {
      throw StateError("Getter was called before the database was opened");
    }
    return database.value.transaction((txn) async {
      List<Map<String, dynamic>> data = await txn.query(tableVocabularies,
          columns: [columnID, columnLangKey, columnTerm],
          where: '$columnID = ? AND $columnLangKey = ?',
          whereArgs: [definition.id, definition.langKey]);
      Map<String, dynamic> first = data.first;
      return VocabularyData.fromJson(first);
    });
  }

  @override
  Future<VocabularyPair> getPair(VocabularyInfo info) async {
    VocabularyData first = await getVocabulary(info.getGiven());
    VocabularyData second = await getVocabulary(info.getExpected());
    return VocabularyPair(info.id, first, second);
  }

  void close() {
    ready.close();
    database.close();
    langKeys.close();
    vocabularyKeys.close();
  }
}
