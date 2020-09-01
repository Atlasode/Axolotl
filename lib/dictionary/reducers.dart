import 'package:axolotl/dictionary/actions.dart';
import 'package:axolotl/dictionary/states.dart';
import 'package:redux/redux.dart';

final Reducer<DictionaryState> listEditReducer = combineReducers([
  new TypedReducer<DictionaryState, DictionarySetFilter>(setFilter),
]);

DictionaryState setFilter(DictionaryState state, DictionarySetFilter action){
  return state.copyWith(
      infinitive: action.infinitive
  );
}