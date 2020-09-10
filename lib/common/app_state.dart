import 'package:axolotl/adventure/list/reducers.dart';
import 'package:axolotl/adventure/list/states.dart';
import 'package:axolotl/adventure/reducers.dart';
import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/dictionary/states.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/vocabulary/list/actions.dart';
import 'package:axolotl/vocabulary/list/reducers.dart';
import 'package:axolotl/vocabulary/list/states.dart';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

enum LoadingState {
  // Data has not started to get loaded
  NONE,
  // Currently loading the data
  LOADING,
  // Finished loading the data
  DONE,
  // An error occurred during the loading
  ERROR
}

final Reducer<AppState> appReducer = combineReducers([
  new TypedReducer<AppState, dynamic>(vocabularyList)
]);

AppState vocabularyList(AppState appState, dynamic action){
  return appState.copyWith(
    vocabularyList: vocabularyListReducer(appState.vocabularyList, action),
    adventureState: adventureReducer(appState.adventureState, action),
    adventureListState: adventureListReducer(appState.adventureListState, action)
  );
}

@immutable
class AppState {
  final VocabularyListState vocabularyList;
  final DictionaryState dictionaryState;
  final AdventureListState adventureListState;
  final AdventureState adventureState;

  AppState({this.vocabularyList = const VocabularyListState(),
    this.dictionaryState = const DictionaryState(),
    this.adventureListState = const AdventureListState(),
    this.adventureState = const AdventureState()});

  AppState copyWith({VocabularyListState vocabularyList,
    DictionaryState dictionaryState,
    AdventureListState adventureListState,
    AdventureState adventureState}) =>
      AppState(vocabularyList: vocabularyList??this.vocabularyList,
      dictionaryState: dictionaryState??this.dictionaryState,
      adventureListState: adventureListState ??this.adventureListState,
      adventureState: adventureState??this.adventureState);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          vocabularyList == other.vocabularyList;

  @override
  int get hashCode => vocabularyList.hashCode;
}

class Redux {
  static Store<AppState> _store;

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static dynamic dispatch(dynamic action) {
    return store.dispatch(action);
  }

  static Future<void> init() async {
    _store = Store<AppState>(
      appReducer,
      initialState: AppState(),
    );
  }
}