import 'package:axolotl/common/app_state.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';


class VocabularyListAction {
  const VocabularyListAction();
}

class VocabularyListLoaded extends VocabularyListAction{
  final Iterable<VocabularyList> lists;

  const VocabularyListLoaded(this.lists);

}

class VocabularyListAdd extends VocabularyListAction{
  final VocabularyList list;

  VocabularyListAdd(this.list);

}

class VocabularyListUpdate extends VocabularyListAction{
  final VocabularyList list;
  final int index;

  VocabularyListUpdate(this.list, this.index);

}

/// Called to finish the editing of the list. Pushes the changes from the edit state to the VocabularyListState
class VocabularyListFinish extends VocabularyListAction{

}

class VocabularyListRemove extends VocabularyListAction{
  final int index;

  VocabularyListRemove(this.index);

}

class VocabularyListLoading extends VocabularyListAction {
  final LoadingState loadingState;

  const VocabularyListLoading(this.loadingState);
}

class VocabularyListOpen extends VocabularyListAction{
  final VocabularyList list;
  final int index;

  VocabularyListOpen(this.list, this.index);
}

Future<void> fetchListsAction(bool dummyList) async{
  List<EntryPair> entries = VocabularyStorage.defaultVocabularies.map((e) => EntryPair(InfoType.VERB_RANGE, VerbInfoRange(e))).toList();
  entries.add(EntryPair(
      InfoType.VERB_RANGE,
      VerbInfoRange('comer', [
        VerbCategory(mood: 'Indicativo', tense: 'Presente'),
        VerbCategory(mood: 'Indicativo', tense: 'Futuro'),
        VerbCategory(mood: 'Indicativo', tense: 'Imperfecto')
      ])));
  List<VocabularyList> dummyLists = [
    VocabularyList(
      "Default",
      "Default List",
        entries.toList()
    ),
    VocabularyList(
      "Default 2",
      "Default 2 List",
        entries.toList()
    ),
    VocabularyList(
      "Default 3",
      "Default 3 List",
        entries.toList()
    ),
    VocabularyList(
      "Default 4",
      "Default 4 List",
        entries.toList()
    ),
    VocabularyList(
      "Default 5",
      "Default 5 List",
        entries.toList()
    )
  ];
  Redux.store.dispatch(VocabularyListLoading(LoadingState.LOADING));
  Iterable<VocabularyList> lists;
  if(dummyList){
    lists = dummyLists;
  }else {
    lists = await Repositories.listRepository.getAllLists();
  }
  Redux.store.dispatch(VocabularyListLoaded(lists));
}