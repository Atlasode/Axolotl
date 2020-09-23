import 'dart:math';

import 'package:axolotl/adventure/actions.dart';
import 'package:axolotl/adventure/states.dart';
import 'package:moor/moor.dart';
import 'package:redux/redux.dart';

final Reducer<AdventureState> adventureReducer = combineReducers([
  new TypedReducer<AdventureState, AdventureUpdateInstance>(setInstance),
  new TypedReducer<AdventureState, AdventureUpdateIndex>(setIndex),
  new TypedReducer<AdventureState, AdventureUpdateSettings>(setSettings),
  new TypedReducer<AdventureState, AdventureRemoveTask>(removeTask),
  new TypedReducer<AdventureState, AdventureAddTask>(addTask),
  new TypedReducer<AdventureState, AdventureUpdateTask>(updateTask),
  new TypedReducer<AdventureState, AdventureOpen>(openAdventure),
  new TypedReducer<AdventureState, AdventureClose>(closeAdventure),
  new TypedReducer<AdventureState, AdventureUpdateField>(updateTaskField)
]);

AdventureState setInstance(AdventureState state, AdventureUpdateInstance action) {
  return state.copyWith(
      adventure: action.instance,
    taskStates: action.instance.tasks
        .map((task) => TaskState.task(task))
        .toList(growable: false)
  );
}

AdventureState setIndex(AdventureState state, AdventureUpdateIndex action) {
  return state.copyWith(
    taskIndex: action.index
  );
}

AdventureState setSettings(AdventureState state, AdventureUpdateSettings action) {
  return state.copyWith(
    settings: action.settings
  );
}

AdventureState setState(AdventureState state, AdventureUpdateTaskState action){
  List<TaskState> newList = List.of(state.taskStates);
  newList[action.index] = newList[action.index].copyWith(
    diff: action.diff,
    currentValues: action.values
  );
  return state.copyWith(
      taskStates: newList.toList(growable: false)
  );
}

AdventureState updateTaskField(AdventureState state, AdventureUpdateField action) {
  return state
      .setField(action.fieldIndex, action.value, taskIndex: action.taskIndex);
}

AdventureState removeTask(AdventureState state, AdventureRemoveTask action) {
  List<AdventureTask> newList = List.of(state.adventure.tasks);
  newList.removeAt(action.index);
  List<TaskState> newStates = List.of(state.taskStates);
  newStates.removeAt(action.index);
  return state.copyWith(
    adventure: state.adventure.copyWith(tasks: newList.toList(growable: false)),
      taskStates: newStates.toList(growable: false),
    listIndex: min(state.listIndex, newList.length - 1)
  );
}

AdventureState addTask(AdventureState state, AdventureAddTask action) {
  List<AdventureTask> newList = List.of(state.adventure.tasks);
  newList.add(action.task);
  List<TaskState> newStates = List.of(state.taskStates);
  newStates.add(TaskState.task(action.task));
  return state.copyWith(
      adventure: state.adventure.copyWith(tasks: newList.toList(growable: false)),
      taskStates: newStates.toList(growable: false)
  );
}

AdventureState updateTask(AdventureState state, AdventureUpdateTask action) {
  List<AdventureTask> newList = List.of(state.adventure.tasks);
  newList[action.index] = action.task;
  List<TaskState> newStates = List.of(state.taskStates);
  newStates[action.index] = TaskState.task(action.task);
  return state.copyWith(
      adventure: state.adventure.copyWith(tasks: newList.toList(growable: false))
  );
}

AdventureState openAdventure(AdventureState state, AdventureOpen action) {
  return AdventureState.open(action.adventure, action.index, settings: action.settings);
}

AdventureState closeAdventure(AdventureState state, AdventureClose action) {
  return state.close();
}