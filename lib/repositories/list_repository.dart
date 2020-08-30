import 'dart:convert';
import 'dart:io';

import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class ListRepository {
  Future<Iterable<String>> getValidPaths();

  Future<Iterable<VocabularyList>> getAllLists();

  Future<VocabularyList> getList(String name);

  Future<void> addList(VocabularyList list);
}


class FileRepository extends ListRepository {

  Future<Directory> getDirectory(){
    return getApplicationDocumentsDirectory().then((value) => Directory('${value.path}/vocabulary_lists'));
  }

  @override
  Future<Iterable<String>> getValidPaths() =>
      getDirectory()
      .then((value) async {
        await value.exists().then((exists) async {
          if(!exists){
            await value.create(recursive: true);
          }
        });
        return value;
      }).then((directory) => directory.list(recursive: false, followLinks: false)
      .where((entity) => entity.statSync().type == FileSystemEntityType.file)
        .map((entity)=>entity.path).where((path) => extension(path) == '.json')
        .toList());

  @override
  Future<Iterable<VocabularyList>> getAllLists() =>
      getValidPaths().then((paths) => Future.wait(paths.map((path) => File(path))
          .where((file) => file.existsSync())
          .map((file) => file.readAsString()))
          .then((value) => value.map((jsonString) => jsonDecode(jsonString) as Map<String, dynamic>))
          .then((jsonList) => jsonList.map((json) => VocabularyList.fromJson(json))));

  @override
  Future<File> addList(VocabularyList list) {
    return getDirectory()
        .then((directory) => File('${directory.path}/${list.name}.json').create())
        .then((file) => file.writeAsString(jsonEncode(list.toJson())));
  }

  @override
  Future<VocabularyList> getList(String name) async {
    final directory = await getDirectory();
    final file = File('${directory.path}/$name.json');
    if(!file.existsSync()){
      return VocabularyList.EMPTY;
    }
    return file.readAsString()
        .then((json) => VocabularyList.fromJson(jsonDecode(json) as Map<String, dynamic>));
  }

}

