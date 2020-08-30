import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/vocabulary/list/edit/actions.dart';
import 'package:axolotl/vocabulary/list/edit/states.dart';
import 'package:axolotl/vocabulary/list/entry/reducers.dart';
import 'package:axolotl/vocabulary/list/entry/states.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/vocabulary/list/actions.dart';
import 'package:axolotl/vocabulary/list/states.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:redux/redux.dart';

final Reducer<VocabularyListEditState> listEditReducer = combineReducers([
  new TypedReducer<VocabularyListEditState, VocabularyListEditSetInfo>(setInfo),
  new TypedReducer<VocabularyListEditState, VocabularyListEditAddInfo>(addInfo),
  new TypedReducer<VocabularyListEditState, VocabularyListEditUpdateInfo>(updateInfo),
  new TypedReducer<VocabularyListEditState, VocabularyListEditFinish>(finish),
  new TypedReducer<VocabularyListEditState, VocabularyListEditRemoveInfo>(removeInfo),
  new TypedReducer<VocabularyListEditState, VocabularyListEditOpen>(openEdit),
  new TypedReducer<VocabularyListEditState, VocabularyListEditSetName>(setName),
  new TypedReducer<VocabularyListEditState, CategoryCacheAction>(cacheReduce),
  new TypedReducer<VocabularyListEditState, VocabularyListEditChangeType>(changeType),
  new TypedReducer<VocabularyListEditState, dynamic>(updateEdit)
]);

VocabularyListEditState updateEdit(VocabularyListEditState state, dynamic action){
  return state.copyWith(
    currentEdit: infoReducer(state.currentEdit, action)
  );
}

VocabularyListEditState setName(VocabularyListEditState state, VocabularyListEditSetName action){
  return state.copyWith(
    name: action.name
  );
}

VocabularyListEditState setInfo(VocabularyListEditState state, VocabularyListEditSetInfo action){
  List<AbstractInfo> newList = List.of(state.infoEdits);
  newList[action.index] = action.info;
  return state.copyWith(
      infoEdits: newList.toList(growable: false)
  );
}

VocabularyListEditState finish(VocabularyListEditState state, VocabularyListEditFinish action){
  if(!(state.currentEdit is AbstractInfoEntryState)){
    return state;
  }
  AbstractInfoEntryState editState = state.currentEdit;
  List<AbstractInfo> newList = List.of(state.infoEdits);
  if(editState.index != null) {
    newList[editState.index] = editState.toInfo();
  }else{
    newList.add(editState.toInfo());
  }
  return state.copyWith(
      infoEdits: newList.toList(growable: false)
  );
}

VocabularyListEditState addInfo(VocabularyListEditState state, VocabularyListEditAddInfo action){
  List<AbstractInfo> newList = List.of(state.infoEdits);
  newList.add(action.info);
  return state.copyWith(
      infoEdits: newList.toList(growable: false)
  );
}

VocabularyListEditState updateInfo(VocabularyListEditState state, VocabularyListEditUpdateInfo action){
  List<AbstractInfo> newList = List.of(state.infoEdits);
  newList[action.index] = action.info;
  return state.copyWith(
      infoEdits: newList.toList(growable: false)
  );
}

VocabularyListEditState removeInfo(VocabularyListEditState state, VocabularyListEditRemoveInfo action){
  List<AbstractInfo> newList = List.of(state.infoEdits);
  newList.removeAt(action.index);
  return state.copyWith(
      infoEdits: newList.toList(growable: false)
  );
}

VocabularyListEditState openEdit(VocabularyListEditState state, VocabularyListEditOpen action) {
  AbstractInfo info = action.info;
  switch(info.getType()) {
    case InfoType.VERB_RANGE:
      VerbInfoRange verbInfo = info as VerbInfoRange;
      return state.copyWith(currentEdit: VerbEntryState(
          info: verbInfo,
          index: action.index,
          categories: verbInfo.categories,
          infinitive: verbInfo.infinitive
      ));
    case InfoType.VOCABULARY:
      VocabularyInfo vocabularyInfo = info as VocabularyInfo;
      return state.copyWith(currentEdit: VocabularyEntryState(
          info: vocabularyInfo,
          index: action.index));
    default:
      return state;
  }
}

VocabularyListEditState changeType(VocabularyListEditState state, VocabularyListEditChangeType action){
  return state.copyWith(
    currentEdit: state.currentEdit.changeType(action.type)
  );
}


VocabularyListEditState cacheReduce(VocabularyListEditState state, CategoryCacheAction action){
  return state.copyWith(
    categoryCache: categoryReducer(state.categoryCache, action)
  );
}

final Reducer<CategoryCacheState> categoryReducer = combineReducers([
  new TypedReducer<CategoryCacheState, CategoryCacheLoaded>(loadCache),
  new TypedReducer<CategoryCacheState, CategoryCacheLoading>(loadingState)
]);

CategoryCacheState loadingState(CategoryCacheState state, CategoryCacheLoading action) {
  return state.copyWith(
    loadingState: action.loadingState
  );
}

CategoryCacheState loadCache(CategoryCacheState state, CategoryCacheLoaded action) {
  return state.copyWith(
    tenses: action.tenses,
    moods: action.moods,
    loadingState: LoadingState.DONE
  );
}
