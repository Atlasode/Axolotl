

import 'package:axolotl/utils/common_utils.dart';

///Represents a listening of a cache object. Can be used to cancel the listening
class CacheListener<V> {
  final Consumer<V> _consumer;
  final Consumer<CacheListener> _cancelTask;

  CacheListener(this._consumer, this._cancelTask);

  void apply(V value) => _consumer(value);

  void cancel() => _cancelTask(this);
}
