class DictionaryState {
  final String infinitive;

  const DictionaryState({this.infinitive});

  DictionaryState copyWith({String infinitive}){
    return DictionaryState(infinitive: infinitive??this.infinitive);
  }
}