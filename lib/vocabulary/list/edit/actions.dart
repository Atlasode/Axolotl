import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';


class VocabularyListEditAction {
  const VocabularyListEditAction();
}

class VocabularyListEditSetInfo extends VocabularyListEditAction  {
  final int index;
  final AbstractInfo info;

  VocabularyListEditSetInfo(this.index, this.info);
}

class VocabularyListEditAddInfo extends VocabularyListEditAction  {
  final AbstractInfo info;

  VocabularyListEditAddInfo(this.info);
}

class VocabularyListEditFinish extends VocabularyListEditAction  {

  VocabularyListEditFinish();
}

class VocabularyListEditUpdateInfo extends VocabularyListEditAction  {
  final AbstractInfo info;
  final int index;

  VocabularyListEditUpdateInfo(this.info, this.index);
}

class VocabularyListEditRemoveInfo extends VocabularyListEditAction  {
  final int index;

  VocabularyListEditRemoveInfo(this.index);
}

class VocabularyListEditOpen extends VocabularyListEditAction  {
  final AbstractInfo info;
  final int index;

  VocabularyListEditOpen(this.info, this.index);
}

class VocabularyListEditChangeType extends VocabularyListEditAction  {
  final InfoType type;

  VocabularyListEditChangeType(this.type);
}

class VocabularyListEditSetName extends VocabularyListEditAction  {
  final String name;

  VocabularyListEditSetName(this.name);
}

class CategoryCacheAction {
  const CategoryCacheAction();
}

class CategoryCacheLoading extends CategoryCacheAction {
  final LoadingState loadingState;

  const CategoryCacheLoading(this.loadingState);
}

class CategoryCacheLoaded extends CategoryCacheAction {
  final List<String> tenses;
  final List<String> moods;

  const CategoryCacheLoaded(this.tenses, this.moods);
}

Future<void> fetchCategoryDataAction() async {
  Redux.store.dispatch(CategoryCacheLoading(LoadingState.LOADING));
  Future<List<String>> tenses = Repositories.verbs.getTenses();
  Future<List<String>> moods = Repositories.verbs.getMoods();
  return Future.wait([tenses, moods]).then((value) {
    List<String> tenses = value[0];
    List<String> moods = value[1];
    Redux.store.dispatch(CategoryCacheLoaded(tenses, moods),);
  }).catchError((error){
    Redux.store.dispatch(CategoryCacheLoading(LoadingState.ERROR));
  });
  /*try {
    Redux.store.dispatch(
      CategoryCacheLoaded(),
    );
  } catch (error) {
    //store.dispatch(SetPostsStateAction(PostsState(isLoading: false)));
  }*/
}