
import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/vocabulary/list/edit/actions.dart';
import 'package:axolotl/vocabulary/list/edit/reducers.dart';
import 'package:axolotl/vocabulary/list/edit/states.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/vocabulary/list/actions.dart';
import 'package:axolotl/vocabulary/list/states.dart';
import 'package:redux/redux.dart';

final Reducer<VocabularyListState> listReducer = combineReducers([
  new TypedReducer<VocabularyListState, VocabularyListLoaded>(loadList),
  new TypedReducer<VocabularyListState, VocabularyListLoading>(loadingState),
  new TypedReducer<VocabularyListState, VocabularyListOpen>(openList),
  new TypedReducer<VocabularyListState, VocabularyListAdd>(addList),
  new TypedReducer<VocabularyListState, VocabularyListUpdate>(updateList),
  new TypedReducer<VocabularyListState, VocabularyListRemove>(removeList),
  new TypedReducer<VocabularyListState, VocabularyListFinish>(finish),
  new TypedReducer<VocabularyListState, dynamic>(updateEdit),
]);

VocabularyListState updateEdit(VocabularyListState state, dynamic action) {
  return state.copyWith(
    currentEdit: listEditReducer(state.currentEdit, action)
  );
}

VocabularyListState loadingState(VocabularyListState state, VocabularyListLoading action) {
  return state.copyWith(
      loadingState: action.loadingState
  );
}

VocabularyListState loadList(VocabularyListState state, VocabularyListLoaded action) {
  return state.copyWith(
      lists: action.lists.toList(growable: false),
      loadingState: LoadingState.DONE
  );
}

//Merge with updateList ?
VocabularyListState finish(VocabularyListState state, VocabularyListFinish action) {
  VocabularyListEditState editState = state.currentEdit;
  List<VocabularyList> newList = List.of(state.lists);
  newList[editState.index] = editState.toList();
  return state.copyWith(
    lists: newList
  );
}

VocabularyListState addList(VocabularyListState state, VocabularyListAdd action) {
  List<VocabularyList> newList = List.of(state.lists);
  newList.add(action.list);
  return state.copyWith(
      lists: newList.toList(growable: false)
  );
}

VocabularyListState updateList(VocabularyListState state, VocabularyListUpdate action) {
  List<VocabularyList> newList = List.of(state.lists);
  newList[action.index] = action.list;
  return state.copyWith(
      lists: newList.toList(growable: false)
  );
}

VocabularyListState removeList(VocabularyListState state, VocabularyListRemove action) {
  List<VocabularyList> newList = List.of(state.lists);
  newList.removeAt(action.index);
  return state.copyWith(
      lists: newList.toList(growable: false)
  );
}

VocabularyListState openList(VocabularyListState state, VocabularyListOpen action) {
  return state.copyWith(
    currentEdit: VocabularyListEditState.fromList(action.list, action.index)
  );
}
