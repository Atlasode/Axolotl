import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FilterProvider<P> {
  String get siblingKey;

  FilterProvider();

  Query getQuery(Query collection);

  Query handleQuery(Query query);

  bool needsUpdate(P oldProvider);

  bool needsSibling();
}
