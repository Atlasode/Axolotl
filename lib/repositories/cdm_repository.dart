

import 'package:axolotl/cdm/caches/data_collection.dart';

abstract class CDMRepository {
  final DataCollection collection;

  CDMRepository(this.collection);

/*CollectionReference collection({String subPath}){
    return firestore.collection(this.path + subPath != null ? '/$subPath' : '');
  }*/
}
