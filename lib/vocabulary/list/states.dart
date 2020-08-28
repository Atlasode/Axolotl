import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/vocabulary/list/edit/states.dart';
import 'package:flutter/material.dart';

@immutable
class VocabularyListState {
  final List<VocabularyList> lists;
  final LoadingState loadingState;
  final VocabularyListEditState currentEdit;

  const VocabularyListState({this.lists = const [], this.currentEdit = const VocabularyListEditState(), this.loadingState = LoadingState.NONE});

  VocabularyListState copyWith({ List<VocabularyList> lists, VocabularyListEditState currentEdit, LoadingState loadingState})
  => VocabularyListState(lists: lists??this.lists, currentEdit: currentEdit??this.currentEdit, loadingState: loadingState??this.loadingState);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyListState &&
          runtimeType == other.runtimeType &&
          lists == other.lists &&
          loadingState == other.loadingState &&
          currentEdit == other.currentEdit;

  @override
  int get hashCode =>
      lists.hashCode ^ loadingState.hashCode ^ currentEdit.hashCode;
}