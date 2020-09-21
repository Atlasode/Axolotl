import 'package:axolotl/adventure/tasks/verbs/blank_sentence/states.dart';
import 'package:axolotl/adventure/tasks/verbs/collection/pages.dart';
import 'package:axolotl/adventure/tasks/verbs/collection/states.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:flutter/material.dart';

enum TaskDifference {
  NONE,
  //This task was not touched by the user
  UNTOUCHED,
  //This task was edited by the user, not all fields are filled and it is not validated
  EDITED,
  //This task was edited by the user, all fields are filled and it is not validated
  EDITED_DONE,
  //This task has been validated and has no mistakes
  DONE,
  //This task has been validated, has mistakes and has hard validation settings
  FAILED,
  //This task has been validated, has mistakes and loose validation settings
  MISTAKE,
}

Color getDiffColor(TaskDifference diff){
  switch(diff){
    case TaskDifference.DONE:
      return Colors.green;
    case TaskDifference.UNTOUCHED:
      return Colors.blueGrey;
    case TaskDifference.EDITED:
      return Colors.deepOrangeAccent;
    case TaskDifference.EDITED_DONE:
      return Colors.yellow;
    case TaskDifference.FAILED:
      return Colors.red[800];
    case TaskDifference.MISTAKE:
      return Colors.redAccent[200];
    default:
      return Colors.grey[400].withAlpha(125);
  }
}

class AdventureState {
  final Adventure adventure;
  final List<TaskState> taskStates;
  final int taskIndex;
  final AdventureSettings settings;
  final int listIndex;

  const AdventureState(
      {this.adventure = Adventure.EMPTY,
        this.listIndex = -1,
      this.taskStates = const [],
      this.taskIndex = -1,
      this.settings = AdventureSettings.EASY});

  factory AdventureState.open(Adventure adventure, int listIndex, {AdventureSettings settings}) {
    return AdventureState(
      adventure: adventure,
      listIndex: listIndex,
      settings: settings,
      taskIndex: 0,
      taskStates: adventure.tasks.map((task) => TaskState.task(task)).toList()
    );
  }

  List<bool> validate(){
    return taskStates[taskIndex].validate(adventure.tasks[taskIndex]);
  }

  bool validateSingle(int index){
    return taskStates[taskIndex].validateSingle(adventure.tasks[taskIndex], index);
  }

  bool get hasNext {
    return taskIndex < taskStates.length - 1;
  }

  bool get hasPrevious {
    return taskIndex > 0 ;
  }

  AdventureState close() {
    return AdventureState(settings: settings);
  }

  AdventureState copyWith(
      {Adventure adventure,
        int listIndex,
      List<TaskState> taskStates,
      int taskIndex,
      AdventureSettings settings}) {
    return AdventureState(
        adventure: adventure??this.adventure,
        listIndex: listIndex??this.listIndex,
        taskStates: taskStates??this.taskStates,
        taskIndex: taskIndex??this.taskIndex,
        settings: settings??this.settings);
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

  bool get isEmpty => name.isEmpty;
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

abstract class AdventureTask<T> {
  final TaskType type;
  final String name;

  const AdventureTask(this.type, this.name);

  Widget build(BuildContext context, TaskState taskState);

  List<T> createData() {
    //TODO: make abstract
    return [];
  }

  List<bool> validate(TaskDataGroup group, {Comparator comparator}) {
    return group.fields.map((element) => element.equal(comparator: comparator)).toList();
  }

  bool validateSingle(TaskDataGroup group, int index, {Comparator comparator}) {
    assert(group.fields.length < index);
    return group.fields[index].equal(comparator: comparator);
  }

  String getDisplayName();
}

// 00000000
// 00000000
// 00000000
// 00000000

typedef Comparator = bool Function<V>(V valid, V current);

class TaskDataField<V> {
  final V valid;
  final V current;

  TaskDataField(this.valid, [this.current]);

  TaskDataField<V> copyWith({V valid, V current}){
    return TaskDataField(
      valid??this.valid,
      current??this.current
    );
  }

  bool equal({Comparator comparator}) {
    return comparator != null ? comparator(valid, current) : valid == current;
  }
}

class TaskDataGroup {
  final List<TaskDataField> fields;

  TaskDataGroup._(this.fields);

  factory TaskDataGroup({List validValues = const [], List currentValues = const [], List<TaskDataField> fields = const [], bool clear = false}) {
    if(clear){
      return TaskDataGroup._(validValues.map((valid) => TaskDataField(valid)));
    }
    bool copy = fields.isNotEmpty;
    int startIndex = copy ? fields.length : currentValues.length;
    return TaskDataGroup._(List.generate(validValues.length, (index){
      dynamic valid = validValues[startIndex + index];
      if(copy){
        if(index < startIndex) {
          return fields[index].copyWith(valid: valid);
        }else{
          return TaskDataField(valid);
        }
      }
      dynamic current = index < startIndex ? currentValues[index] : null;
      return TaskDataField(valid, current);
    }));
  }

  TaskDataGroup copyWith({List<TaskDataField> fields = const [], List validValues = const [], List currentValues = const [], bool clear = false}){
    return fields.isNotEmpty ? TaskDataGroup._(fields??this.fields) : TaskDataGroup(
        validValues: validValues,
        currentValues: currentValues,
        fields: this.fields,
        clear: clear);
  }
}

class TaskState {
  final TaskDataGroup group;
  final TaskDifference diff;

  const TaskState._(this.group, this.diff);

  factory TaskState.task(AdventureTask task){
    return TaskState(validValues: task.createData());
  }

  factory TaskState({TaskDataGroup group, List validValues = const [], List currentValues = const [], TaskDifference diff = TaskDifference.UNTOUCHED}) {
    return TaskState._(group ?? TaskDataGroup(validValues: validValues, currentValues: currentValues),
        diff??diff
    );
  }

  TaskState copyWith({TaskDataGroup group, List validValues = const [], List currentValues = const [], TaskDifference diff, bool clear = false}){
    return TaskState(
        group: group != null ? group : validValues.isNotEmpty ? group.copyWith(validValues: validValues, currentValues: currentValues, clear: clear): this.group,
        diff: diff??this.diff
    );
  }

  List<bool> validate(AdventureTask task, {Comparator comparator}) {
    return task.validate(group, comparator: comparator);
  }

  bool validateSingle(AdventureTask task, int index, {Comparator comparator}) {
    return task.validateSingle(group, index, comparator: comparator);
  }
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

abstract class TextAreaTask extends AdventureTask<String> {
  final List<TextSection> sections;

  const TextAreaTask(TaskType type, String name, this.sections)
      : super(type, name);

  @override
  List<String> createData() {
    return sections.map((e) => e.blanks.map((e) => e.getText())).reduce((value, element) => [...value, ...element]).toList();
  }
}

abstract class VocabularyProvider {
  Iterable<VocabularyPair> getPairs();
}

class VocabularyCollectionTask extends AdventureTask {
  final VocabularyProvider provider;

  VocabularyCollectionTask(String name, this.provider)
      : super(TaskType.VOCABULARY_COLLECTION, name);

  @override
  Widget build(BuildContext context, TaskState taskState) {
    throw UnimplementedError();
  }

  @override
  String getDisplayName() {
    return provider.getPairs().join(', ');
  }
}
