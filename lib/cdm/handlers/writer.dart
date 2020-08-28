import 'package:axolotl/cdm/caches/data_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Writer {
  final Transaction transaction;

  Writer._(this.transaction);

  Future<void> updateOrCreate(DataObject doc, Object data, {bool update = false}) async {
    if (update) {
      await this.update(doc, data);
    } else {
      await set(doc, data);
    }
  }

  Future<void> set(DataObject doc, object) async {
    doc.internalSet(transaction, object);
  }

  Future<void> update(DataObject doc, object) async {
    doc.internalUpdate(transaction, object);
  }

  Future<void> delete(DataObject doc) async {
    doc.internalDelete(transaction);
  }

  static Future<void> start(Future<void> handleWriting(Writer writer)) {
    return Firestore.instance.runTransaction((transaction) async => await handleWriting(Writer._(transaction)), timeout: Duration(minutes: 2));
  }
}
