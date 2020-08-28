import 'package:axolotl/cdm/caches/cache_listener.dart';
import 'package:axolotl/cdm/caches/data_node.dart';
import 'package:axolotl/cdm/caches/data_object.dart';
import 'package:axolotl/cdm/handlers/data_controller.dart';
import 'package:axolotl/cdm/handlers/filter_provider.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/utils/firestore_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DataCollection extends DataNode<QuerySnapshot> implements Controller {
  /// The path of the collection in the database.
  final String path;

  /// Documents are the children and entries of this collection.
  final Map<String, DataObject> documents;

  /// Siblings are versions of the same collection but with filters applied to them. Every sibling needs a special key to represent its filters.
  final Map<String, DataCollection> siblings;

  final List<CacheListener<bool>> stateListeners = [];

  final FilterProvider filter;

  /// True if this collection is subscribed to a stream and updates ('controls') the values of its documents.
  bool controlsObject;

  DataCollection(this.path, {this.filter})
      : documents = {},
        siblings = {},
        super(FirestoreUtils.referenceToStream<QuerySnapshot>(
            filter != null ? filter.getQuery(Firestore.instance.collection(path)) : Firestore.instance.collection(path)));

  DataCollection where(FilterProvider provider) {
    String key = provider.siblingKey;
    DataCollection sibling = siblings[key];
    if (sibling == null || provider.needsUpdate(sibling.filter)) {
      sibling = DataCollection(path, filter: provider);
      siblings[key] = sibling;
      return sibling;
    }
    return sibling;
  }

  void enableControl() {
    documents.forEach((key, value) => value.control(this));
    controlsObject = true;
  }

  void disableControl() {
    documents.forEach((key, value) => value.decontrol());
    controlsObject = false;
  }

  void disposeChild(String location) {
    var removeChild = documents.remove(location);
    if (removeChild != null) {
      removeChild.unsubscribe();
    }
  }

  void dispose() {
    documents.forEach((key, storage) => storage.unsubscribe());
  }

  DataObject document(String location) {
    return documents.putIfAbsent(location, () => DataObject(this.path + '/' + location));
  }

  @override
  CacheListener addStateListener(Consumer<bool> handler) {
    CacheListener listener = new CacheListener(handler, (list) => stateListeners.remove(list));
    stateListeners.add(listener);
    return listener;
  }

  @override
  bool isActive() {
    return controlsObject;
  }
}
