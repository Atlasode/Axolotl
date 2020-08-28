import 'package:axolotl/cdm/caches/data_collection.dart';
import 'package:axolotl/cdm/caches/data_node.dart';
import 'package:axolotl/cdm/caches/path.dart';
import 'package:axolotl/cdm/handlers/writer.dart';
import 'package:axolotl/utils/firestore_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataObject extends DataNode<DocumentSnapshot> {
  /// The path of the document in the database.
  final String path;

  /// A map with all collections of this document
  final Map<String, DataCollection> collections;

  /// If this document is the root document of the current collection-document tree
  final bool root;

  final DocumentReference reference;

  /// The currently cached data object of this document
  DataObject dataCache;

  DataObject(this.path, {this.root = false})
      : collections = {},
        reference = Firestore.instance.document(path),
        super(FirestoreUtils.referenceToStream<DocumentSnapshot>(Firestore.instance.document(path)));

  String get documentID => path.split('/').last;

  DataCollection collection(CollectionKey key) {
    return collections.putIfAbsent(key.subPath, () => DataCollection(root ? key.subPath : this.path + '/' + key.subPath));
  }

  DataObject document(CollectionKey key, String subPath) {
    return collection(key).document(subPath);
  }

  DataCollection getCollection(String path) {
    assert(path != null && path.length % 2 == 0);
    List<String> pathComponent = path.split('/');
    return subCollection(collections, pathComponent, 0);
  }

  DataObject getDocument(String path) {
    assert(path != null && path.length % 2 == 1);
    List<String> pathComponent = path.split('/');
    return subCollection(collections, pathComponent, 0).document(pathComponent.last);
  }

  DataCollection subCollection(Map<String, DataCollection> collections, List<String> pathComponent, int index) {
    if (pathComponent.length == index || (pathComponent.length - index) == 1) {
      return collections[pathComponent[index]];
    }
    return subCollection(collections[pathComponent[index]].document(pathComponent[index + 1]).collections, pathComponent, index + 2);
  }

  Future<void> set(object) => Writer.start((write) => write.set(this, object));

  Future<void> update(object) => Writer.start((write) => write.update(this, object));

  Future<void> delete() => Writer.start((write) => write.delete(this));

  Future<void> internalSet(Transaction transaction, object){
    try{
      return transaction.set(reference, object.toJson());
    }catch(e) {
      return null;
    }
  }

  Future<void> internalUpdate(Transaction transaction, object) => transaction.update(reference, FirestoreUtils.serialize(object));

  Future<void> internalDelete(Transaction transaction) => transaction.delete(reference);
}
