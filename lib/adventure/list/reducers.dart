import 'package:axolotl/adventure/list/actions.dart';
import 'package:axolotl/adventure/list/states.dart';
import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/common/app_state.dart';
import 'package:redux/redux.dart';

final Reducer<AdventureListState> adventureListReducer = combineReducers([
  new TypedReducer<AdventureListState, AdventureListLoaded>(loadList),
  new TypedReducer<AdventureListState, AdventureListLoading>(loadingState),
  new TypedReducer<AdventureListState, AdventureListAdd>(addList),
  new TypedReducer<AdventureListState, AdventureListUpdate>(updateList),
  new TypedReducer<AdventureListState, AdventureListRemove>(removeList),
  //new TypedReducer<AdventureListState, AdventureListFinish>(finish),
  //new TypedReducer<AdventureListState, dynamic>(updateEdit),
]);

/*AdventureListState updateEdit(AdventureListState state, dynamic action) {
  return state.copyWith(
      currentEdit: listEditReducer(state.currentEdit, action)
  );
}*/

AdventureListState loadingState(AdventureListState state, AdventureListLoading action) {
  return state.copyWith(
      loadingState: action.loadingState
  );
}

AdventureListState loadList(AdventureListState state, AdventureListLoaded action) {
  return state.copyWith(
      adventures: action.adventures.toList(growable: false),
      loadingState: LoadingState.DONE
  );
}

//Merge with updateList ?
/*AdventureListState finish(AdventureListState state, AdventureListFinish action) {
  AdventureListEditState editState = state.currentEdit;
  List<Adventure> newList = List.of(state.adventures);
  Repositories.listRepository.addList(editState.toList());
  if(editState.index != null) {
    newList[editState.index] = editState.toList();
  }else{
    newList.add(editState.toList());
  }
  return state.copyWith(
      adventures: newList
  );
}*/

AdventureListState addList(AdventureListState state, AdventureListAdd action) {
  List<Adventure> newList = List.of(state.adventures);
  newList.add(action.adventure);
  return state.copyWith(
      adventures: newList.toList(growable: false)
  );
}

AdventureListState updateList(AdventureListState state, AdventureListUpdate action) {
  List<Adventure> newList = List.of(state.adventures);
  newList[action.index] = action.adventure;
  return state.copyWith(
      adventures: newList.toList(growable: false)
  );
}

AdventureListState removeList(AdventureListState state, AdventureListRemove action) {
  List<Adventure> newList = List.of(state.adventures);
  newList.removeAt(action.index);
  return state.copyWith(
      adventures: newList.toList(growable: false)
  );
}
