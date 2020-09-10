import 'package:axolotl/adventure/tasks/verbs/blank_sentence/states.dart';
import 'package:axolotl/adventure/tasks/verbs/collection/pages.dart';
import 'package:axolotl/adventure/tasks/verbs/collection/states.dart';
import 'package:axolotl/repositories/repositories.dart';
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
  final int index;

  const AdventureState(
      {this.adventure = const Adventure(),
        this.index = -1,
      this.taskStates = const [],
      this.taskIndex = -1,
      this.settings = AdventureSettings.EASY});

  factory AdventureState.open(Adventure adventure, int index, {AdventureSettings settings}) {
    return AdventureState(
      adventure: adventure,
      index: index,
      settings: settings,
      taskIndex: 0,
      taskStates: adventure.tasks.map((e) => TaskState.UNTOUCHED)
    );
  }

  AdventureState copyWith(
      {Adventure adventure,
        int index,
      List<TaskState> taskStates,
      int taskIndex,
      AdventureSettings settings}) {
    return AdventureState(
        adventure: adventure,
        index: index,
        taskStates: taskStates,
        taskIndex: taskIndex,
        settings: settings);
  }
}

class AdventureSettings {
  static const AdventureSettings EDIT =
      AdventureSettings(editEnabled: true, switchEnabled: true);
  static const AdventureSettings EASY = AdventureSettings();
  static const AdventureSettings HARD =
      AdventureSettings(switchEnabled: false, testDirectly: true);

  //Allows to edit the adventures
  final bool editEnabled;
  //Tests the adventures directly after the done or "switch right" button was
  // pressed. And shows the results directly after
  final bool testDirectly;
  //If the user can switch between the tasks in an adventure back and forth
  final bool switchEnabled;

  const AdventureSettings(
      {this.editEnabled = false,
      this.testDirectly = false,
      this.switchEnabled = true});
}

class Adventure {
  // ignore: non_constant_identifier_names
  static const EMPTY = Adventure(name: "", displayName: "", tasks: const []);

  final List<AdventureTask> tasks;
  final String name;
  final String displayName;

  const Adventure({this.tasks, this.name, this.displayName,});

  copyWith({List<AdventureTask> tasks, String name, String displayName}) {
    return Adventure(tasks: tasks ?? this.tasks,
    name: name??this.name,
      displayName: displayName??this.displayName
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Adventure &&
          runtimeType == other.runtimeType &&
          tasks == other.tasks;

  @override
  int get hashCode => tasks.hashCode;
}

class DummyAdventure {
  static Adventure _instance;

  static Future<Adventure> get() async {
    if (_instance == null) {
      _instance = Adventure(tasks: [
        VerbTextAreaTask(
          'Test',
          [
            TextSection([
              'Hoy Luis y María',
              'con nosotros.'
            ], [
              VerbBlankText(
                  await Repositories.verbRepository
                      .getVerb(VerbDefinition('comer')),
                  Person.THIRD_PLURAL,
                  showPronoun: true)
            ]),
            TextSection([
              'Antes',
              'comer en la cafetería.'
            ], [
              VerbBlankText(
                  await Repositories.verbRepository
                      .getVerb(VerbDefinition('soler')),
                  Person.FIRST_SINGULAR,
                  showPronoun: true,
                  showTense: true)
            ])
          ],
        ),
        VerbCollectionTask(
            "Test",
            await Repositories.verbRepository.getVerb(VerbDefinition('comer')),
            Person.values.toSet()),
      ], displayName: 'Tim Test', name: 'tim_test');
    }
    return _instance;
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

abstract class BlankText {
  String getText();

  String getHintText();
}

class TextSection {
  final List<String> texts;
  final List<BlankText> blanks;

  TextSection(this.texts, this.blanks)
      : assert(texts.length == (blanks.length + 1));
}

abstract class TextAreaTask extends AdventureTask {
  final List<TextSection> sections;

  const TextAreaTask(TaskType type, String name, this.sections)
      : super(type, name);
}

abstract class VocabularyProvider {
  Iterable<VocabularyPair> getPairs();
}

class VocabularyCollectionTask extends AdventureTask {
  final VocabularyProvider provider;

  VocabularyCollectionTask(String name, this.provider)
      : super(TaskType.VOCABULARY_COLLECTION, name);

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  String getDisplayName() {
    return provider.getPairs().join(', ');
  }
}
