import 'dart:developer';
import 'dart:io';

import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moor/ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:moor/moor.dart';

//part 'verb_repository.g.dart';

abstract class VerbRepository {
  Future<Set<String>> getAllVerbs();

  Future<List<String>> getVerbsQuery(String infinitive);

  Future<Verb> getVerb(VerbDefinition pair);

  Future<Iterable<Verb>> getVerbs(VerbInfoRange info);

  Future<List<String>> getTenses();

  Future<List<String>> getMoods();
}

//https://pub.dev/packages/moor
class SQLRepository implements VerbRepository {
  final String tableVerbs = 'verbs';
  final String columnInfinitive = 'infinitive';
  final String columnMood = 'mood';
  final String columnTense = 'tense';
  final String columnVerbEnglish = 'verb_english';
  final String columnForm1s = 'form_1s';
  final String columnForm2s = 'form_2s';
  final String columnForm3s = 'form_3s';
  final String columnForm1p = 'form_1p';
  final String columnForm2p = 'form_2p';
  final String columnForm3p = 'form_3p';

  BehaviorSubject<bool> ready = BehaviorSubject.seeded(false);
  BehaviorSubject<Database> database = new BehaviorSubject<Database>();
  BehaviorSubject<Set<String>> verbs = new BehaviorSubject<Set<String>>.seeded({});
  BehaviorSubject<List<String>> tenses = new BehaviorSubject<List<String>>.seeded([]);
  BehaviorSubject<List<String>> moods = new BehaviorSubject<List<String>>.seeded([]);

  SQLRepository() {
    loadDatabase();
    ready.listen((value) {
      if (value) {
        database.value.transaction((txn) => txn.query(tableVerbs, columns: [columnInfinitive]).then((value) => verbs.add(value.map((e) => e[columnInfinitive] as String).toSet())));
        database.value.transaction((txn) => txn.query('tense').then((value) =>
            tenses.add(value.map((row) => row['tense'] as String).toList())));
        database.value.transaction((txn) => txn.query('mood').then((value) =>
            moods.add(value.map((row) => row['mood'] as String).toList())));
        /*database.value.transaction((txn){
          return Future.wait([
            txn.query("mood"),
            txn.query("tense")
          ]).then((values) async {
            List<Map<String, dynamic>> moods = values[0];
            List<Map<String, dynamic>> tenses = values[1];
            await Firestore.instance.runTransaction((transaction) async {
              for(Map<String, dynamic> mood in moods) {
                await transaction.set(Firestore.instance.collection('moods').document((mood['mood'] as String).toLowerCase().replaceAll(' ', '_')), mood);
              }
            });
            await Firestore.instance.runTransaction((transaction) async {
              for(Map<String, dynamic> tense in tenses) {
                await transaction.set(Firestore.instance.collection('tenses').document((tense['tense'] as String).toLowerCase().replaceAll(' ', '_')), tense);
              }
            });
          });
        });*/
        /*database.value.transaction((txn) {
          return Future.wait([
            txn.query('verbs'),
            txn.query('pastparticiple'),
            txn.query('infinitive'),
            txn.query('gerund')
          ]).then((values) async {
            List<Map<String, dynamic>> verbs = values[0];
            List<Map<String, dynamic>> participles = values[1];
            List<Map<String, dynamic>> infinitives = values[2];
            List<Map<String, dynamic>> gerunds = values[3];
            Map<String, List<Map<String, dynamic>>> conjugationData = {};
            Map<String, Map<String, dynamic>> verbsData = {};
            for (Map<String, dynamic> data in infinitives) {
              String infinitive = data['infinitive'];
              verbsData.putIfAbsent(infinitive, () => {}).addAll({
                'infinitive': infinitive,
                'infinitive_english': data['infinitive_english']
              });
            }
            for (Map<String, dynamic> data in gerunds) {
              String infinitive = data['infinitive'];
              verbsData.putIfAbsent(infinitive, () => {}).addAll({
                'gerund': data['gerund'],
                'gerund_english': data['gerund_english']
              });
            }
            for (Map<String, dynamic> data in participles) {
              String infinitive = data['infinitive'];
              verbsData.putIfAbsent(infinitive, () => {}).addAll({
                'pastparticiple': data['pastparticiple'],
                'pastparticiple_english': data['pastparticiple_english']
              });
            }
            for (Map<String, dynamic> data in verbs) {
              String infinitive = data['infinitive'];
              conjugationData.putIfAbsent(infinitive, () => []).add({
                'infinitive': infinitive,
                'mood': data['mood'],
                'tense': data['tense'],
                'verb_english': data['verb_english'],
                'form_1s': data['form_1s'],
                'form_2s': data['form_2s'],
                'form_3s': data['form_3s'],
                'form_1p': data['form_1p'],
                'form_2p': data['form_2p'],
                'form_3p': data['form_3p'],
              });
            }
            List<String> superList = verbsData.keys.toList();
            int index = superList.indexOf('ofrecer');
            List<String> nestedList = superList.sublist(index);
            List<List<String>> infinitiveChunked = nestedList.chunk(22);
            List<String> doneInf = [];
            for(List<String> infinitiveList in infinitiveChunked){
              await Firestore.instance.runTransaction((transaction) async {
                for(String infinitive in infinitiveList){
                  if(doneInf.contains(infinitive)){
                    continue;
                  }
                  List<Map<String, dynamic>> conData = conjugationData[infinitive];
                  Map<String, dynamic> verbData = verbsData[infinitive];
                  DocumentReference ref = Firestore.instance.collection("verbs").document(infinitive);
                  await transaction.set(ref, verbData);
                  if(conData == null){
                    print(infinitive);
                  }
                  if(conData != null) {
                    for (Map<String, dynamic> conjugation in conData) {
                      await transaction.set(ref.collection("conjugations").document(),
                          conjugation);
                    }
                  }
                  doneInf.add(infinitive);
                }
              }, timeout: Duration(minutes: 5));
            }
          });
        });*/
        getVerb(VerbDefinition("comer"));
      }
    });
  }

  Future<List<String>> getTenses() async {
    return tenses.value;
  }

  Future<List<String>> getMoods() async {
    return moods.value;
  }

  Future<void> loadDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "verb_database.sqlite");

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "example.sqlite"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    var db = await openDatabase(path, readOnly: true);
    ready.add(db != null);
    database.add(db);
  }

  void _checkState() {
    if (ready.value == null) {
      throw StateError("Getter was called before the database was opened");
    }
    if (database.value == null) {
      throw StateError("Failed to create the database");
    }
  }

  @override
  Future<Verb> getVerb(VerbDefinition pair) async {
    _checkState();
    if (database.value == null) {
      throw StateError("Getter was called before the database was opened");
    }
    return database.value.transaction((txn) async {
      List<Map<String, dynamic>> data = await txn.query("verbs",
          columns: [
            columnInfinitive,
            columnMood,
            columnTense,
            columnVerbEnglish,
            columnForm1s,
            columnForm2s,
            columnForm3s,
            columnForm1p,
            columnForm2p,
            columnForm3p
          ],
          where:
              '$columnInfinitive = ? AND $columnMood = ? AND $columnTense = ?',
          whereArgs: [
            pair.infinitive,
            pair.category.mood,
            pair.category.tense
          ]);
      Map<String, dynamic> first = data.first;
      return Verb.fromJson(first);
    });
  }

  @override
  Future<Iterable<Verb>> getVerbs(VerbInfoRange info) async {
    _checkState();
    return Future.wait(info.toPairs().map((pair) {
      return getVerb(pair);
    }));
  }

  void close() {
    ready.close();
    database.close();
    moods.close();
    tenses.close();
    verbs.close();
  }

  @override
  Future<Set<String>> getAllVerbs() {
    return verbs.first;
  }

  @override
  Future<List<String>> getVerbsQuery(String infinitive) {
    return getAllVerbs().then((value) => value.where((e) => e.startsWith(infinitive)).toList());
  }
}

/*class PastParticiples extends Table {
  TextColumn get infinitive => text()();
  TextColumn get pastparticiple => text()();
  TextColumn get pastparticipleEnglish => text()();
}

class Gerunds extends Table {
  TextColumn get infinitive => text()();
  TextColumn get gerund => text()();
  TextColumn get gerundEnglish => text()();
}

class Infinitives extends Table {
  TextColumn get infinitive => text()();
  TextColumn get infinitiveEnglish => text()();
}

class Tenses extends Table {
  TextColumn get tense => text()();
  TextColumn get tenseEnglish => text()();
}

class Moods extends Table {
  TextColumn get mood => text()();
  TextColumn get moodEnglish => text()();
}

class Verbs extends Table {
  TextColumn get infinitive => text()();
  TextColumn get mood => text()();
  TextColumn get tense => text()();
  TextColumn get verbEnglish => text()();
  TextColumn get form_1s => text()();
  TextColumn get form_2s => text()();
  TextColumn get form_3s => text()();
  TextColumn get form_1p => text()();
  TextColumn get form_2p => text()();
  TextColumn get form_3p => text()();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'demo_asset_example.sqlite'));
    return VmDatabase(file);
  });
}

@UseDao(tables: [Verbs])
class VerbsDao extends DatabaseAccessor<MyDatabase> with _$VerbsDaoMixin {
  VerbsDao(MyDatabase db) : super(db);
  Future<List<Verb>> get allWatchingVerbs => select(verbs).get();
  Stream<List<Verb>> get watchAllVerbs => select(verbs).watch();
}

@UseDao(tables: [Moods])
class MoodsDao extends DatabaseAccessor<MyDatabase> with _$MoodsDaoMixin {
  MoodsDao(MyDatabase db) : super(db);
  Future<List<Mood>> get allWatchingMoods => select(moods).get();
  Stream<List<Mood>> get watchAllMoods => select(moods).watch();
}

@UseDao(tables: [Tenses])
class TensesDao extends DatabaseAccessor<MyDatabase> with _$TensesDaoMixin {
  TensesDao(MyDatabase db) : super(db);
  Future<List<Tense>> get allWatchingTenses => select(tenses).get();
  Stream<List<Tense>> get watchAllTenses => select(tenses).watch();
}

@UseMoor(
  tables: [Verbs, Tenses, Moods, Infinitives, Gerunds, PastParticiples],
  daos: [VerbsDao, MoodsDao, TensesDao]
)
class MyDatabase extends _$MyDatabase {
  MyDatabase()
      : super(/*_openConnection()*/
            FlutterQueryExecutor.inDatabaseFolder(
                path: 'demo_asset_example.sqlite'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          final initialData =
              await rootBundle.loadString('assets/example_sql.sql');
          // hopefully you're not using ; anywhere else in your SQL besides ending statements
          for (final data in initialData.split(';')) {
            if (data.trim().isNotEmpty) {
              try {
                await customStatement(data);
              }catch(error) {
                log(error.toString());
              }
            }
          }
        },
        onUpgrade: (Migrator m, int from, int to) async {},
      );
}

class MoorRepository implements VerbRepository {
  MyDatabase database = MyDatabase();

  @override
  Future<List<String>> getMoods() {
    return database.moodsDao.allWatchingMoods.then((value) => value.map((e) => e.mood).toList());
  }

  @override
  Future<List<String>> getTenses() {
    return database.tensesDao.allWatchingTenses.then((value) => value.map((e) => e.tense).toList());
  }

  @override
  Future<Verb> getVerb(VerbInfo info) {
    return (database.verbsDao.select(database.verbs)..where(
            (verb)=>verb.tense.equals(info.tense))
      ..where((verb) => verb.mood.equals(info.mood))
      ..where((verb) => verb.infinitive.equals(info.infinitive))).get().then((value) => value[0]);
  }

  @override
  Future<Iterable<Verb>> getVerbs(VerbInfoRange info) {
    throw UnimplementedError();
  }
}*/

class FirebaseRepository implements VerbRepository {
  BehaviorSubject<List<String>> tenses = new BehaviorSubject<List<String>>();
  BehaviorSubject<List<String>> moods = new BehaviorSubject<List<String>>();


  FirebaseRepository() {
    Firestore.instance.collection('moods').getDocuments().then((snapshot){
      List<String> moods  = [];
      for(DocumentSnapshot snapshot in snapshot.documents){
        moods.add(snapshot.data['mood']);
      }
      this.moods.add(moods);
    });
    Firestore.instance.collection('tenses').getDocuments().then((snapshot){
      List<String> tenses  = [];
      for(DocumentSnapshot snapshot in snapshot.documents){
        tenses.add(snapshot.data['tense']);
      }
      this.tenses.add(tenses);
    });
  }

  Future<List<String>> getTenses() async {
    return tenses.value;
  }

  Future<List<String>> getMoods() async {
    return moods.value;
  }

  void close() {
    moods.close();
    tenses.close();
  }

  @override
  Future<Verb> getVerb(VerbDefinition pair) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Verb>> getVerbs(VerbInfoRange info) {
    throw UnimplementedError();
  }

  @override
  Future<Set<String>> getAllVerbs() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getVerbsQuery(String infinitive) {
    throw UnimplementedError();
  }

}
