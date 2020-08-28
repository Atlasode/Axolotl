import 'package:axolotl/repositories/list_repository.dart';
import 'package:axolotl/repositories/verb_repository.dart';

class Repositories {
  static VerbRepository verbRepository = SQLRepository();
  static ListRepository listRepository = FileRepository();
}