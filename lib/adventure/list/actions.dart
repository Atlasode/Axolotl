import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/common/app_state.dart';

class AdventureListAction {
  const AdventureListAction();
}

class AdventureListLoaded extends AdventureListAction{
  final Iterable<Adventure> adventures;

  const AdventureListLoaded(this.adventures);

}

class AdventureListAdd extends AdventureListAction{
  final Adventure adventure;

  AdventureListAdd(this.adventure);

}

class AdventureListUpdate extends AdventureListAction{
  final Adventure adventure;
  final int index;

  AdventureListUpdate(this.adventure, this.index);

}

/// Called to finish the editing of the list. Pushes the changes from the edit state to the AdventureListState
class AdventureListFinish extends AdventureListAction{

}

class AdventureListRemove extends AdventureListAction{
  final int index;

  AdventureListRemove(this.index);

}

class AdventureListLoading extends AdventureListAction {
  final LoadingState loadingState;

  const AdventureListLoading(this.loadingState);
}

class AdventureListOpen extends AdventureListAction{
  final Adventure adventure;
  final int index;
  final AdventureSettings settings;

  AdventureListOpen(this.adventure, this.index, {this.settings=AdventureSettings.EASY });
}

Future<void> fetchAdventureListsAction(bool dummyList) async{
  Redux.store.dispatch(AdventureListLoading(LoadingState.LOADING));
  /*List<EntryPair> entries = VocabularyStorage.defaultVocabularies.map((e) => EntryPair(InfoType.VERB_RANGE, VerbInfoRange(e))).toList();
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
  ];*/
  Iterable<Adventure> lists;
  if(dummyList){
    lists = [await DummyAdventure.get()];
  }else {
    lists = List.empty();
    //lists = await Repositories.listRepository.getAllLists();
  }
  Redux.store.dispatch(AdventureListLoaded(lists));
}