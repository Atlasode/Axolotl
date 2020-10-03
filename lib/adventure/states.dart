import 'package:axolotl/adventure/list/states.dart';
import 'package:axolotl/adventure/tasks/verbs/blank_sentence/pages.dart';
import 'package:axolotl/adventure/tasks/verbs/blank_sentence/states.dart';
import 'package:axolotl/adventure/tasks/verbs/single_instance/pages.dart';
import 'package:axolotl/adventure/tasks/verbs/single_instance/states.dart';
import 'package:axolotl/adventure/tasks/vocabularies/collection/states.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';

part 'states.g.dart';

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

bool canEdit(TaskDifference difference) {
  return difference != TaskDifference.FAILED &&
      difference != TaskDifference.DONE;
}

Color getDiffColor(TaskDifference diff) {
  switch (diff) {
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
  final List<AdventureTask> tasks;
  final List<TaskState> taskStates;
  final int taskIndex;
  final AdventureSettings settings;
  final int listIndex;

  const AdventureState(
      {this.adventure = Adventure.EMPTY,
      this.listIndex = -1,
        this.tasks  = const [],
        this.taskStates = const [],
      this.taskIndex = -1,
      this.settings = AdventureSettings.EASY});

  factory AdventureState.open(Adventure adventure, List<AdventureTask> tasks, int listIndex,
      {AdventureSettings settings}) {
    return AdventureState(
        adventure: adventure,
        listIndex: listIndex,
        settings: settings,
        taskIndex: 0,
        tasks: tasks,
        taskStates: tasks.map((task) => TaskState.task(task)).toList());
  }

  AdventureState move(bool next) {
    return next ? moveNext() : movePrevious();
  }

  AdventureState jump(int index) {
    assert(taskStates.length > index);
    return copyWith(taskIndex: index);
  }

  AdventureState validateAll() {
    List<TaskState> newStates = List.of(taskStates);
    for (int index = 0; index < taskStates.length; index++) {
      TaskState state = taskStates[index];
      newStates[index] = state.validate(tasks[index], settings);
    }
    return copyWith(taskStates: newStates);
  }

  AdventureState validate(int index) {
    TaskState state = taskStates[index];
    List<TaskState> newStates = List.of(taskStates);
    newStates[index] = state.validate(tasks[index], settings);
    return copyWith(taskStates: newStates);
  }

  AdventureState moveNext() {
    assert(taskStates.length > this.taskIndex + 1);
    AdventureState state = this;
    if (settings.testDirectly) {
      state = validate(taskIndex + 1);
    }
    return state.copyWith(taskIndex: this.taskIndex + 1);
  }

  AdventureState movePrevious() {
    assert(taskStates.length > this.taskIndex - 1);
    AdventureState state = this;
    if (settings.testDirectly) {
      state = validate(taskIndex - 1);
    }
    return state.copyWith(taskIndex: this.taskIndex - 1);
  }

  bool get canNext {
    return hasNext;
  }

  bool get canPrevious {
    return hasPrevious && settings.switchEnabled;
  }

  bool get canJump {
    return settings.switchEnabled;
  }

  bool get hasNext {
    return taskIndex < taskStates.length - 1;
  }

  bool get hasPrevious {
    return taskIndex > 0;
  }

  // Validation for single page
  bool get hasTestButton {
    return !adventure.isEmpty && hasNext && settings.testSingle;
  }

  // Validation for all pages at the end
  bool get hasDoneButton {
    return !hasNext;
  }

  bool canEditTask(int taskIndex) {
    return canEdit(taskStates[taskIndex].diff);
  }

  AdventureState close() {
    return AdventureState(settings: settings);
  }

  AdventureState setField(int index, dynamic value, {int taskIndex}) {
    int tIndex = taskIndex ?? this.taskIndex;
    List<TaskState> newList = List.of(taskStates);
    TaskState taskState = newList[tIndex];
    newList[tIndex] = taskState.setField(index, value);
    return copyWith(
      taskStates: newList.toList(growable: false),
    );
  }

  AdventureState copyWith(
      {Adventure adventure,
      int listIndex,
        List<AdventureTask> tasks,
      List<TaskState> taskStates,
      int taskIndex,
      AdventureSettings settings}) {
    return AdventureState(
        adventure: adventure ?? this.adventure,
        listIndex: listIndex ?? this.listIndex,
        taskStates: taskStates ?? this.taskStates,
        tasks: tasks?? this.tasks,
        taskIndex: taskIndex ?? this.taskIndex,
        settings: settings ?? this.settings);
  }
}

@JsonSerializable()
class AdventureSettings {
  static const AdventureSettings EDIT =
      AdventureSettings(editEnabled: true, switchEnabled: true);
  static const AdventureSettings EASY = AdventureSettings();
  static const AdventureSettings HARD = AdventureSettings(
      switchEnabled: false,
      testDirectly: true,
      canEditAfterTest: false,
      replaceWithValid: true,
      testSingle: false);

  //Allows to edit the adventures
  final bool editEnabled;
  //Tests the adventures directly after the done or "switch right" button was
  // pressed. And shows the results directly after
  final bool testDirectly;
  // Shows a text button on every page to test the pages individually
  final bool testSingle;
  // If the use can edit the fields after they were tested
  final bool canEditAfterTest;
  //If the user can switch between the tasks in an adventure back and forth
  final bool switchEnabled;
  // If the field should contain the valid value after the test.
  final bool replaceWithValid;

  const AdventureSettings(
      {this.editEnabled = false,
      this.testSingle = true,
      this.canEditAfterTest = true,
      this.replaceWithValid = false,
      this.testDirectly = false,
      this.switchEnabled = true});

  factory AdventureSettings.fromJson(Map<String, dynamic> json) => _$AdventureSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AdventureSettingsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Adventure {
  // ignore: non_constant_identifier_names
  static const EMPTY = Adventure(name: "", displayName: "", taskData: const []);

  final List<AdventureTaskData> taskData;
  final String name;
  final String displayName;

  const Adventure({
    this.taskData,
    this.name,
    this.displayName,
  });

  factory Adventure.fromJson(Map<String, dynamic> json) => _$AdventureFromJson(json);

  Map<String, dynamic> toJson() => _$AdventureToJson(this);

  copyWith({List<AdventureTaskData> taskData, String name, String displayName}) {
    return Adventure(
        taskData: taskData??this.taskData,
        name: name ?? this.name,
        displayName: displayName ?? this.displayName);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Adventure &&
          taskData == other.taskData &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => taskData.hashCode;

  bool get isEmpty => name.isEmpty;
}

class DummyAdventure {
  static Adventure _instance;

  static Future<Adventure> get() async {
    if (_instance == null) {
      String firstLang = 'de';
      String secondLang = 'es';
      _instance = Adventure(
          taskData: [
            TextAreaTaskData(
              'Test',
              [
                TextSectionData(
                    'Hoy Luis y María {0} con nosotros.'
                    , [
                  VerbBlankTextData(
                      VerbDefinition('comer'),
                      Person.THIRD_PLURAL,
                      showPronoun: true)
                ]),
                TextSectionData(
                    'Antes {0} comer en la cafetería.'
                    , [
                  VerbBlankTextData(
                      VerbDefinition('soler'),
                      Person.FIRST_SINGULAR,
                      showPronoun: true,
                      showTense: true)
                ])
              ],
            ),
            VerbInstanceTaskData(
                "Test",
                VerbDefinition('comer'),
                Person.values.toSet()),
            VocabularyCollectionData(
              'Test',
                [
                  VocabularyInfo('7', firstLang, secondLang),
                  VocabularyInfo('3', firstLang, secondLang),
                  VocabularyInfo('10', firstLang, secondLang),
                  VocabularyInfo('0', firstLang, secondLang),
                  VocabularyInfo('11', firstLang, secondLang),
                  VocabularyInfo('4', firstLang, secondLang),
                  VocabularyInfo('2', firstLang, secondLang),
                  VocabularyInfo('6', firstLang, secondLang),
                  VocabularyInfo('8', firstLang, secondLang)
                ], 'de', 'se'
            )
          ],
          displayName: 'Tim Test', name: 'tim_test');
    }
    return _instance;
  }
}

enum TaskType {
  NONE,
  COLLECTION,
  SENTENCE,
  GAP_SENTENCE,
  VERB_INSTANCE
}

bool compareString(List<dynamic> valid, dynamic current) {
  if (valid == null || current == null) {
    return false;
  }
  for (dynamic value in valid) {
    String formattedValid = (value as String)
        .replaceAll('á', 'a')
        .replaceAll('í', 'i')
        .replaceAll('é', 'e')
        .replaceAll('ú', 'u')
        .replaceAll('ó', 'o')
        .replaceAll('ñ', 'n')
        .replaceAll('ü', 'u')
        .replaceAll('¡', '!')
        .replaceAll('¿', '?')
        .replaceAll('È', 'E')
        .replaceAll('À', 'A')
        .replaceAll('Ù', 'U')
        .replaceAll('Ñ', 'N');
    String formattedCurrent = (current as String)
        .replaceAll('á', 'a')
        .replaceAll('í', 'i')
        .replaceAll('é', 'e')
        .replaceAll('ú', 'u')
        .replaceAll('ó', 'o')
        .replaceAll('ñ', 'n')
        .replaceAll('ü', 'u')
        .replaceAll('¡', '!')
        .replaceAll('¿', '?')
        .replaceAll('È', 'E')
        .replaceAll('À', 'A')
        .replaceAll('Ù', 'U')
        .replaceAll('Ñ', 'N');
    if (formattedValid == formattedCurrent) {
      return true;
    }
  }
  return false;
}

bool compareStringStrict(dynamic valid, dynamic current) {
  return valid == current;
}

abstract class AdventureTask<T> {
  final TaskType type;
  final String name;

  const AdventureTask(this.type, this.name);

  Widget build(BuildContext context, TaskState taskState);

  List<List<T>> createData() {
    //TODO: make abstract
    return [];
  }

  Comparator getComparator() {
    return compareString;
  }

  List<bool> validate(TaskDataGroup group, {Comparator comparator}) {
    return group.fields
        .map((element) =>
            element.equal(comparator: comparator ?? getComparator()))
        .toList();
  }

  bool validateSingle(TaskDataGroup group, int index, {Comparator comparator}) {
    assert(group.fields.length < index);
    return group.fields[index].equal(comparator: comparator ?? getComparator());
  }

  String getDisplayName();
}

@JsonSerializable(createFactory: false)
abstract class AdventureTaskData {
  final String name;
  final TaskType type;

  AdventureTaskData(this.name, this.type);

  Future<AdventureTask> createTask();

  factory AdventureTaskData.fromJson(Map<String, dynamic> json){
    TaskType type = json['type'];
    switch (type) {
      case TaskType.GAP_SENTENCE:
        return TextAreaTaskData.fromJson(json);
      case TaskType.VERB_INSTANCE:
        return VerbInstanceTaskData.fromJson(json);
      case TaskType.COLLECTION:
        return VocabularyCollectionData.fromJson(json);
      case TaskType.SENTENCE:
        return null;
      case TaskType.NONE:
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson();
}

// 00000000
// 00000000
// 00000000
// 00000000

typedef Comparator<V> = bool Function(List<V> valid, V current);

class TaskDataField<V> {
  final List<V> valid;
  final V current;
  final TaskDifference diff;

  TaskDataField(this.valid,
      {this.current, this.diff = TaskDifference.UNTOUCHED});

  TaskDataField<V> copyWith({List<V> valid, V current, TaskDifference diff}) {
    return TaskDataField(valid ?? this.valid,
        current: current ?? this.current, diff: diff ?? this.diff);
  }

  bool equal({Comparator comparator}) {
    return comparator != null ? comparator(valid, current) : valid == current;
  }
}

class TaskDataGroup {
  final List<TaskDataField> fields;

  TaskDataGroup._(this.fields);

  factory TaskDataGroup(
      {List<List> validValues = const [],
      List currentValues = const [],
      List<TaskDataField> fields = const [],
      bool clear = false}) {
    if (clear) {
      return TaskDataGroup._(validValues.map((valid) => TaskDataField(valid)));
    }
    bool copy = fields.isNotEmpty;
    int startIndex = copy ? fields.length : currentValues.length;
    return TaskDataGroup._(List.generate(validValues.length, (index) {
      dynamic valid = validValues[startIndex + index];
      if (copy) {
        if (index < startIndex) {
          return fields[index].copyWith(valid: valid);
        } else {
          return TaskDataField(valid);
        }
      }
      dynamic current = index < startIndex ? currentValues[index] : null;
      return TaskDataField(valid, current: current);
    }));
  }

  TaskDataGroup setField(int index, dynamic value) {
    List<TaskDataField> fieldsList = List.of(fields);
    fieldsList[index] =
        fieldsList[index].copyWith(current: value, diff: TaskDifference.EDITED);
    return copyWith(fields: fieldsList);
  }

  dynamic isFieldEdited(int index) {
    return fields[index] != null;
  }

  TaskDataGroup copyWith(
      {List<TaskDataField> fields = const [],
      List<List> validValues = const [],
      List currentValues = const [],
      bool clear = false}) {
    return fields.isNotEmpty
        ? TaskDataGroup._(fields ?? this.fields)
        : TaskDataGroup(
            validValues: validValues,
            currentValues: currentValues,
            fields: this.fields,
            clear: clear);
  }

  static TaskDifference calculateDifference(
      bool state, AdventureSettings settings) {
    if (state) {
      return TaskDifference.DONE;
    }
    return settings.canEditAfterTest
        ? TaskDifference.MISTAKE
        : TaskDifference.FAILED;
  }

  Tuple2<TaskDataGroup, TaskDifference> validate(
      AdventureTask task, AdventureSettings settings) {
    List<bool> testValues = task.validate(this);
    List<TaskDataField> fieldsList = List.of(fields);
    for (int index = 0; index < fields.length; index++) {
      fieldsList[index] = fieldsList[index]
          .copyWith(diff: calculateDifference(testValues[index], settings));
    }
    TaskDifference taskDiff;
    if (testValues.any((element) => !element)) {
      taskDiff = settings.canEditAfterTest
          ? TaskDifference.MISTAKE
          : TaskDifference.FAILED;
    } else {
      taskDiff = TaskDifference.DONE;
    }
    return Tuple2(copyWith(fields: fieldsList), taskDiff);
  }

  bool hasError(int index) {
    return fields[index].diff == TaskDifference.MISTAKE;
  }

  bool isValid(int index) {
    return fields[index].diff == TaskDifference.DONE;
  }
}

class TaskState {
  final TaskDataGroup group;
  final TaskDifference diff;

  const TaskState._(this.group, this.diff);

  factory TaskState.task(AdventureTask task) {
    return TaskState(validValues: task.createData());
  }

  factory TaskState(
      {TaskDataGroup group,
      List<List> validValues = const [],
      List currentValues = const [],
      TaskDifference diff = TaskDifference.UNTOUCHED}) {
    return TaskState._(
        group ??
            TaskDataGroup(
                validValues: validValues, currentValues: currentValues),
        diff ?? diff);
  }

  TaskState copyWith(
      {TaskDataGroup group,
      List<List> validValues = const [],
      List currentValues = const [],
      TaskDifference diff,
      bool clear = false}) {
    return TaskState(
        group: group != null
            ? group
            : validValues.isNotEmpty
                ? group.copyWith(
                    validValues: validValues,
                    currentValues: currentValues,
                    clear: clear)
                : this.group,
        diff: diff ?? this.diff);
  }

  static TaskDifference calculateDifference(TaskDataGroup group) {
    return group.fields.where((element) => element.current != null).length ==
            group.fields.length
        ? TaskDifference.EDITED_DONE
        : TaskDifference.EDITED;
  }

  TaskState setField(int index, dynamic value) {
    TaskDataGroup group = this.group.setField(index, value);
    return copyWith(group: group, diff: calculateDifference(group));
  }

  TaskState validate(AdventureTask task, AdventureSettings settings) {
    Tuple2<TaskDataGroup, TaskDifference> data = group.validate(task, settings);
    return copyWith(group: data.item1, diff: data.item2);
  }

  bool validateSingle(AdventureTask task, int index, {Comparator comparator}) {
    return task.validateSingle(group, index, comparator: comparator);
  }

  bool hasError(int index) {
    return group.hasError(index);
  }

  bool isValid(int index) {
    return group.isValid(index);
  }

  dynamic getValue(int index) {
    return group.fields[index].current;
  }
}

enum BlankTextType{
  NONE,
  VERB,
  VOCABULARY
}

@JsonSerializable(createFactory: false)
abstract class BlankTextData {

  final BlankTextType type;

  const BlankTextData(this.type);

  Future<BlankText> create();

  factory BlankTextData.fromJson(Map<String, dynamic> json){
    BlankTextType type = json['type'];
    switch (type) {
      case BlankTextType.VERB:
        return VerbBlankTextData.fromJson(json);
      case BlankTextType.VOCABULARY:
      case BlankTextType.NONE:
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson();
}

abstract class BlankText {
  String getText();

  String getHintText();
}

@JsonSerializable(explicitToJson: true)
class TextSectionData {
  final String text;
  final List<BlankTextData> blanks;

  TextSectionData(this.text, this.blanks);

  factory TextSectionData.fromJson(Map<String, dynamic> json) => _$TextSectionDataFromJson(json);

  Map<String, dynamic> toJson() => _$TextSectionDataToJson(this);

  Future<TextSection> create() async{
    return TextSection(text, await Future.wait(blanks.map((e) => e.create())));
  }
}

class TextSection {
  final String text;
  final List<BlankText> blanks;

  TextSection(this.text, this.blanks);

  List<String> getTexts() {
    String last = text;
    List<String> texts = [];
    for(int i = 0;i < blanks.length;i++){
      List<String> splitTexts = last.split('{$i}');
      if(splitTexts.length == 1){
        break;
      }
      texts.add(splitTexts[0]);
      last = splitTexts[1];
    }
    texts.add(last);
    return texts;
  }

}

@JsonSerializable(explicitToJson: true)
class TextAreaTaskData extends AdventureTaskData {
  final List<TextSectionData> sections;

  TextAreaTaskData(String name, this.sections) : super(name, TaskType.GAP_SENTENCE);

  factory TextAreaTaskData.fromJson(Map<String, dynamic> json) => _$TextAreaTaskDataFromJson(json);

  Map<String, dynamic> toJson() => _$TextAreaTaskDataToJson(this);

  @override
  Future<AdventureTask> createTask() async {
    return TextAreaTask(
      name,
      await Future.wait(sections.map((e) => e.create()))
    );
  }

}

class TextAreaTask extends AdventureTask<String> {
  final List<TextSection> sections;

  const TextAreaTask(String name, this.sections)
      : super(TaskType.GAP_SENTENCE, name);

  @override
  List<List<String>> createData() {
    return sections
        .map((e) => e.blanks.map((e) => [e.getText()]))
        .reduce((value, element) => [...value, ...element])
        .toList();
  }

  @override
  Widget build(BuildContext context, TaskState taskState) {
    return VerbTextArea(task: this, taskState: taskState,);
  }

  @override
  String getDisplayName() {
    return '';
  }
}

enum VocabularyMode { RANDOM, FIRST, SECOND, DEFINED }

abstract class VocabularyDefinition {
  bool isExpected(int id, String langKey);
}
