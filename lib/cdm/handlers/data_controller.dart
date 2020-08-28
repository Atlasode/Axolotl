

import 'package:axolotl/cdm/caches/cache_listener.dart';
import 'package:axolotl/utils/common_utils.dart';

/// A controller is used to remote control the subscription of a data object.
///
/// As an example a firestore collection uses the same data pool as the documents it contains. So the controller can be used to disable the description
/// of the object in favor of the collection subscription.
abstract class Controller {
  ///True if the controller currently disables the subscription of the controlled objects.
  bool isActive();

  CacheListener addStateListener(Consumer<bool> handler);
}
