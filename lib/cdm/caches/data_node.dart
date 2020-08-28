import 'dart:async';

import 'package:axolotl/cdm/caches/cache_listener.dart';
import 'package:axolotl/cdm/handlers/data_controller.dart';
import 'package:axolotl/utils/common_utils.dart';


abstract class StreamHandler<T> {
  void clear();

  void update(T data);

  void clearData();
}

class DataNode<V> {
  final List<CacheListener<V>> dataListeners = [];
  final Stream<V> stream;
  StreamSubscription<dynamic> subscription;
  int listenerCount;
  Controller controller;
  bool disabledByController = false;

  DataNode(Stream<V> stream)
      : listenerCount = 0,
        this.stream = stream;

  CacheListener addDataListener(Consumer<V> handler) {
    subscribe();
    CacheListener<V> listener = CacheListener<V>(handler, (listener) {
      dataListeners.remove(listener);
      unsubscribe();
    });
    dataListeners.add(listener);
    return listener;
  }

  void subscribe() {
    listenerCount += 1;
    _subscribe();
  }

  void unsubscribe() {
    assert(listenerCount > 0);
    if (listenerCount > 1) {
      listenerCount -= 1;
    } else if (listenerCount == 1) {
      _unsubscribe();
    }
  }

  void control(Controller controller) {
    this.controller = controller;
    this.controller.addStateListener((state) {
      if (state) {
        disabledByController = true;
        _unsubscribe();
      } else {
        disabledByController = false;
        _subscribe();
      }
    });
  }

  void decontrol() {
    if (controller != null && disabledByController) {
      disabledByController = false;
      subscribe();
      controller = null;
    }
  }

  void _subscribe() {
    if (listenerCount <= 0 || controller != null && disabledByController) {
      return;
    }
    if (subscription != null) {
      subscription.cancel();
    }
    subscription = stream.listen((data) {
      for (CacheListener<V> listener in dataListeners) {
        listener.apply(data);
      }
    });
  }

  void _unsubscribe() {
    subscription.cancel();
    subscription = null;
  }
}
