import 'package:axolotl/model/group.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empty_collections/empty_collections.dart';

class FirestoreUtils {
  static String generateId() {
    return Firestore.instance.collection('groups').document().documentID;
  }

  static Type deserialize<Type>(DocumentSnapshot doc) {
    if (Type is Group) {
      return Group.fromJson(doc.data) as Type;
    }
    if (Type is VerbCategory) {
      return VerbCategory.fromJson(doc.data) as Type;
    }
    if (Type is Verb) {
      return Verb.fromJson(doc.data) as Type;
    }
    if (Type is VerbInfoRange) {
      return VerbInfoRange.fromJson(doc.data) as Type;
    }
    return null;
  }

  static Map<String, dynamic> serialize(value) {
    return value?.toJson() ?? EmptyMap();
  }

  static Stream<V> referenceToStream<V>(reference) {
    return reference is DocumentReference
        ? reference.snapshots()
        : reference is Query ? reference.snapshots() : Stream.empty();
  }
}
