import 'package:axolotl/repositories/list_repository.dart';
import 'package:axolotl/repositories/verb_repository.dart';
import 'package:axolotl/repositories/vocabulary_repository.dart';

class Repositories {
  static VerbRepository verbs = SQLRepository();
  static ListRepository lists = FileRepository();
  static VocabularyRepository vocabularies = VocFirebaseRepository();
}