import 'package:axolotl/adventure/tasks/verbs/collection/pages.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:flutter/material.dart';


enum TaskState {
  NONE,
  //This task was not touched by the user
  UNTOUCHED,
  //This task was edited by the user, not all fields are filled and it is not validated
  EDITED,
  //This task was edited by the user, all fields are filled and it is not validated
  EDITED_DONE,
  //This task has been validated and has no mistakes
  DONE,
  //This task has been validated and has mistakes
  FAILED,
  MISTAKE,
}

class AdventureState {
  final Adventure adventure;
  final List<TaskState> taskStates;
  final int taskIndex;
  final AdventureSettings settings;

  const AdventureState({this.adventure = const Adventure(), this.taskStates = const [], this.taskIndex = -1, this.settings = AdventureSettings.EASY});

  AdventureState copyWith({Adventure adventure, List<TaskState> taskStates, int taskIndex, AdventureSettings settings}) {
    return AdventureState(
      adventure: adventure,
      taskStates: taskStates,
      taskIndex: taskIndex,
      settings: settings
    );
  }
}

class AdventureSettings {
  static const AdventureSettings EDIT = AdventureSettings(
    editEnabled: true,
    switchEnabled: true
  );
  static const AdventureSettings EASY = AdventureSettings();
  static const AdventureSettings HARD = AdventureSettings(switchEnabled: false, testDirectly: true);

  //Allows to edit the adventures
  final bool editEnabled;
  //Tests the adventures directly after the done or "switch right" button was
  // pressed. And shows the results directly after
  final bool testDirectly;
  //If the user can switch between the tasks in an adventure back and forth
  final bool switchEnabled;

  const AdventureSettings({this.editEnabled = false, this.testDirectly = false, this.switchEnabled = true});
}

class Adventure {
  final List<AdventureTask> tasks;

  const Adventure({this.tasks});

  copyWith(List<AdventureTask> tasks) {
    return Adventure(tasks: tasks??this.tasks);
  }

}

enum TaskType {
  VERB_COLLECTION,
  VERB_SENTENCE,
  VOCABULARY_COLLECTION,
}

abstract class AdventureTask {
  final TaskType type;
  final String name;

  const AdventureTask(this.type, this.name);

  Widget build(BuildContext context);

  String getDisplayName();
}

class VerbCollectionTask extends AdventureTask {
  final Verb verb;
  final Set<Person> persons;

  VerbCollectionTask(String name, this.verb, this.persons) : super(TaskType.VERB_COLLECTION, name);

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  String getDisplayName() {
    return verb.infinitive.capitalize();
  }

}

abstract class BlankText {
  String getText();

  String getHintText();
}

class TextSection {
  final List<String> texts;
  final List<BlankText> blanks;

  TextSection(this.texts, this.blanks) : assert(texts.length == (blanks.length + 1));
}

abstract class TextAreaTask extends AdventureTask {
  final List<TextSection> sections;

  TextAreaTask(TaskType type, String name, this.sections) :
        super(type, name);
}

abstract class VocabularyProvider {
  Iterable<VocabularyPair> getPairs();
}

class VocabularyCollectionTask extends AdventureTask {
  final VocabularyProvider provider;

  VocabularyCollectionTask(String name, this.provider) : super(TaskType.VOCABULARY_COLLECTION, name);

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  String getDisplayName() {
    return provider.getPairs().join(', ');
  }

}

class VerbBlankText implements BlankText{
  static const List<String> fieldLabels = [
    "yo",
    "tú",
    "él",
    "nosotros",
    "vosotros/as",
    "ellos"
  ];

  final Verb verb;
  final Person person;
  final bool showPronoun;
  final bool showTense;

  VerbBlankText(this.verb, this.person, {this.showPronoun = false, this.showTense = false});

  @override
  String getText() {
    return verb.getForm(person);
  }

  @override
  String getHintText() {
    StringBuffer buffer = StringBuffer();
    buffer.write(verb.infinitive);
    if(showPronoun){
      buffer.write('/${fieldLabels[person.index]}');
    }
    if(showTense){
      buffer.write('/${verb.category.displayName.toLowerCase()}');
    }
    return buffer.toString();
  }
}

class VerbTextAreaTask extends TextAreaTask {

  VerbTextAreaTask(String name, List<TextSection> sections) :super(TaskType.VERB_SENTENCE, name, sections);

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  String getDisplayName() {
    throw UnimplementedError();
  }

}