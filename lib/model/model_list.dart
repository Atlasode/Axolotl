class ModelList<V>  {
  final Map<String, V> entries;

  ModelList(this.entries);

  Iterable<String> keys() {
    return entries.keys;
  }

  Iterable<V> values() {
    return entries.values;
  }

  V operator [](String key) {
    return entries[key];
  }
}
