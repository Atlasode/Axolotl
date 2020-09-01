class DictionaryAction {

  const DictionaryAction();
}

class DictionarySetFilter extends DictionaryAction {
  final String infinitive;

  const DictionarySetFilter(this.infinitive);
}