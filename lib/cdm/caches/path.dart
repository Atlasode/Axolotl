
import 'package:axolotl/cdm/caches/data_collection.dart';
import 'package:axolotl/cdm/caches/data_object.dart';
import 'package:axolotl/constants.dart';


class CollectionKey {
  final String subPath;

  const CollectionKey(this.subPath);
}

class GroupCache {
  static CollectionKey subjects = CollectionKey('subjects');
  static CollectionKey courses = CollectionKey('courses');
  static CollectionKey conditions = CollectionKey('conditions');
  static CollectionKey tags = CollectionKey('tags');
  static CollectionKey timetables = CollectionKey('timetables');
  static CollectionKey persons = CollectionKey('persons');
  static CollectionKey rooms = CollectionKey('rooms');
}

class Caches {
  static DataObject document = DataObject('', root: true);
  static CollectionKey groups = CollectionKey('groups');
  static CollectionKey users = CollectionKey('users');

  static DataObject userDocument() {
    return Caches.document.document(users, defaultUser);
  }

  static DataObject groupDocument({CollectionKey key, String path}) {
    if (key != null && path != null) {
      return Caches.document.document(Caches.groups, debugGroup).document(key, path);
    }
    return Caches.document.document(Caches.groups, debugGroup);
  }

  static DataCollection groupCollection(CollectionKey key) {
    return Caches.document.document(Caches.groups, debugGroup).collection(key);
  }
}

class Path {}

class PathBuilder {}
