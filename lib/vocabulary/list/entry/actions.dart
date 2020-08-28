import 'package:axolotl/vocabulary/verb.dart';

class EntryInfoAction {
  const EntryInfoAction();
}

class VocabularyAction extends EntryInfoAction {
  const VocabularyAction();
}

class VerbAction extends EntryInfoAction {
  const VerbAction();
}

class VerbUpdateCategory extends VerbAction {
  final VerbCategory category;
  final int index;

  const VerbUpdateCategory(this.category, this.index);
}

class VerbAddCategory extends VerbAction {
  final VerbCategory category;

  const VerbAddCategory(this.category);
}

class VerbRemoveCategory extends VerbAction {
  final int index;

  VerbRemoveCategory(this.index);
}

class VerbSetInfinitive extends VerbAction {
  final String infinitive;

  const VerbSetInfinitive(this.infinitive);
}

class VerbUpdatePerson extends VerbAction {
  final bool person;
  final int index;

  VerbUpdatePerson(this.person, this.index);
}