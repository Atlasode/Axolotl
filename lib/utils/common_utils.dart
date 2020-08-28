typedef Supplier<T> = T Function();
typedef Consumer<T> = void Function(T value);
typedef UnaryOperator<T> = T Function(T value);
typedef Operator<T, R> = R Function(T value);

extension CapitalizeString on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return split(' ').map((subString) => subString[0].toUpperCase() + subString.substring(1)).join(' ');
  }
}

extension ChunkList<T> on List<T>{

  List<List<T>> chunk(int len) {
    List<List<T>> chunks = [];
    int i = 0;

    while (i < length) {
      chunks.add(sublist(i, i = (((i + len) > length) ? length : i + len)));
    }

    return chunks;
  }
}
