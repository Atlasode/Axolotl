import 'package:axolotl/adventure/actions.dart';
import 'package:axolotl/adventure/states.dart';
import 'package:redux/redux.dart';

final Reducer<AdventureState> adventureReducer = combineReducers([
  new TypedReducer<AdventureState, AdventureUpdateInstance>(setInstance),
  new TypedReducer<AdventureState, AdventureUpdateIndex>(setIndex),
  new TypedReducer<AdventureState, AdventureUpdateSettings>(setSettings),
  new TypedReducer<AdventureState, AdventureRemoveTask>(removeTask),
  new TypedReducer<AdventureState, AdventureAddTask>(addTask),
  new TypedReducer<AdventureState, AdventureUpdateTask>(updateTask),
  new TypedReducer<AdventureState, AdventureOpen>(openAdventure),
]);

AdventureState setInstance(AdventureState state, AdventureUpdateInstance action) {
  List<TaskState> newStates = List.of(state.taskStates);
  if(newStates.length > action.instance.tasks.length){
    newStates.removeRange(action.instance.tasks.length, newStates.length);
  }else if(newStates.length < action.instance.tasks.length){
    while(newStates.length < action.instance.tasks.length) {
      newStates.add(TaskState.UNTOUCHED);
    }
  }
  return state.copyWith(
      adventure: action.instance,
    taskStates: newStates.toList(growable: false)
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
  newList[action.index] = action.state;
  return state.copyWith(
      taskStates: newList.toList(growable: false)
  );

}

AdventureState removeTask(AdventureState state, AdventureRemoveTask action) {
  List<AdventureTask> newList = List.of(state.adventure.tasks);
  newList.removeAt(action.index);
  List<TaskState> newStates = List.of(state.taskStates);
  newStates.removeAt(action.index);
  return state.copyWith(
    adventure: state.adventure.copyWith(tasks: newList.toList(growable: false)),
      taskStates: newStates.toList(growable: false)
  );
}

AdventureState addTask(AdventureState state, AdventureAddTask action) {
  List<AdventureTask> newList = List.of(state.adventure.tasks);
  newList.add(action.task);
  List<TaskState> newStates = List.of(state.taskStates);
  newStates.add(TaskState.UNTOUCHED);
  return state.copyWith(
      adventure: state.adventure.copyWith(tasks: newList.toList(growable: false)),
      taskStates: newStates.toList(growable: false)
  );
}

AdventureState updateTask(AdventureState state, AdventureUpdateTask action) {
  List<AdventureTask> newList = List.of(state.adventure.tasks);
  newList[action.index] = action.task;
  List<TaskState> newStates = List.of(state.taskStates);
  newStates[action.index] = TaskState.EDITED;
  return state.copyWith(
      adventure: state.adventure.copyWith(tasks: newList.toList(growable: false))
  );
}

AdventureState openAdventure(AdventureState state, AdventureOpen action) {
  return AdventureState.open(action.adventure, action.index);
}