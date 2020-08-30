import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/vocabulary/list/entry/states.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:flutter/material.dart';


@immutable
class CategoryCacheState {
  final List<String> tenses;
  final List<String> moods;
  final LoadingState loadingState;

  const CategoryCacheState({this.tenses = const [], this.moods = const [], this.loadingState = LoadingState.NONE});

  CategoryCacheState copyWith({List<String> tenses, List<String> moods, LoadingState loadingState})
    => CategoryCacheState(
        tenses: tenses??this.tenses,
        moods: moods??this.moods,
        loadingState: loadingState??this.loadingState
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryCacheState &&
          runtimeType == other.runtimeType &&
          tenses == other.tenses &&
          moods == other.moods &&
          loadingState == other.loadingState;

  @override
  int get hashCode => tenses.hashCode ^ moods.hashCode ^ loadingState.hashCode;
}

@immutable
class VocabularyListEditState {
  final CategoryCacheState categoryCache;
  final List<AbstractInfo> infoEdits;
  final String name;
  final VocabularyList list;
  final InfoEntryState currentEdit;
  final int index;

  const VocabularyListEditState({
    this.name,
    this.infoEdits = const [],
    this.currentEdit = EmptyInfoEditState.INSTANCE,
    this.list = VocabularyList.EMPTY,
    this.categoryCache = const CategoryCacheState(),
    this.index,
  });

  factory VocabularyListEditState.fromList(VocabularyList list, int index){
    return VocabularyListEditState(infoEdits: list.createInfoList(), list:  list, index: index, name: list.displayName);
  }

  VocabularyList toList(){
    return list.copyWith(
      displayName: name,
      name: name.toLowerCase().replaceAll(' ', '_'),
      entries: infoEdits.map((info) => EntryPair(info.getType(), info)).toList()
    );
  }

  VocabularyListEditState copyWith({String name, List<AbstractInfo> infoEdits, InfoEntryState currentEdit, VocabularyList list, int index, CategoryCacheState categoryCache})
  => VocabularyListEditState(
      name: name??this.name,
      infoEdits: infoEdits??this.infoEdits,
      currentEdit:currentEdit??this.currentEdit,
      list: list??this.list,
      categoryCache: categoryCache??this.categoryCache,
    index: index??this.index
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyListEditState &&
          runtimeType == other.runtimeType &&
          infoEdits == other.infoEdits &&
          list == other.list &&
          index == other.index;

  @override
  int get hashCode => infoEdits.hashCode ^ list.hashCode ^ index.hashCode;
}