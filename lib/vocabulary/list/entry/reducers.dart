import 'package:axolotl/vocabulary/list/entry/actions.dart';
import 'package:axolotl/vocabulary/list/entry/states.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:redux/redux.dart';

final Reducer<InfoEntryState> infoReducer = combineReducers([
  new TypedReducer<InfoEntryState, VerbAction>((state, action)=>verbReducer(state as VerbEntryState, action)),
  new TypedReducer<InfoEntryState, VocabularyAction>((state, action)=>vocabularyReducer(state as VocabularyEntryState, action)),
]);

final Reducer<VocabularyEntryState> vocabularyReducer = combineReducers([]);

final Reducer<VerbEntryState> verbReducer = combineReducers([
  new TypedReducer<VerbEntryState, VerbUpdateCategory>(updateCategory),
  new TypedReducer<VerbEntryState, VerbAddCategory>(addCategory),
  new TypedReducer<VerbEntryState, VerbRemoveCategory>(removeCategory),
  new TypedReducer<VerbEntryState, VerbSetInfinitive>(changeInfinitive),
  new TypedReducer<VerbEntryState, VerbUpdatePerson>(updatePerson),
]);

VerbEntryState updateCategory(VerbEntryState state, VerbUpdateCategory action){
  List<VerbCategory> newList = List.of(state.categories);
  newList[action.index] = action.category;
  return state.copyWith(
      categories: newList.toList(growable: false)
  );
}

VerbEntryState addCategory(VerbEntryState state, VerbAddCategory action){
  List<VerbCategory> newList = List.of(state.categories);
  newList.add(action.category);
  return state.copyWith(
      categories: newList.toList(growable: false)
  );
}

VerbEntryState removeCategory(VerbEntryState state, VerbRemoveCategory action){
  List<VerbCategory> newList = List.of(state.categories);
  newList.removeAt(action.index);
  return state.copyWith(
      categories: newList.toList(growable: false)
  );
}

VerbEntryState changeInfinitive(VerbEntryState state, VerbSetInfinitive action){
  return state.copyWith(
      infinitive: action.infinitive
  );
}

VerbEntryState updatePerson(VerbEntryState state, VerbUpdatePerson action){
  List<bool> newList = List.of(state.persons);
  newList[action.index] = action.person;
  return state.copyWith(
      persons: newList
  );
}
