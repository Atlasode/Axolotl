import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:flutter/material.dart';

@immutable
abstract class InfoEntryState {
  const InfoEntryState();

  bool get isEmpty => this is EmptyInfoEditState;

  InfoEntryState changeType(InfoType type);
}

@immutable
class EmptyInfoEditState extends InfoEntryState {
  static const EmptyInfoEditState INSTANCE = EmptyInfoEditState();

  const EmptyInfoEditState();

  @override
  InfoEntryState changeType(InfoType type) {
    return this;
  }
}

@immutable
abstract class AbstractInfoEntryState<I extends AbstractInfo>
    extends InfoEntryState {
  final I info;
  final int index;

  const AbstractInfoEntryState(this.info, this.index);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbstractInfoEntryState &&
          runtimeType == other.runtimeType &&
          info == other.info &&
          index == other.index;

  @override
  int get hashCode => info.hashCode ^ index.hashCode;

  @override
  InfoEntryState changeType(InfoType type) {
    {
      switch(type){
        case InfoType.VERB_RANGE:
          return VerbEntryState(index: index, info: VerbInfoRange(""));
        case InfoType.VOCABULARY:
          return VocabularyEntryState(index: index, info: VocabularyInfo(-1, "", ""));
        default:
          return EmptyInfoEditState.INSTANCE;
      }
    }
  }

  AbstractInfo toInfo();
}

@immutable
class VocabularyEntryState extends AbstractInfoEntryState<VocabularyInfo> {
  final int vocabularyID;

  VocabularyEntryState({VocabularyInfo info, int index, this.vocabularyID}) : super(info, index);

  VocabularyEntryState copyWith(
          {VocabularyInfo info,
          int index,
          int vocabularyID}) =>
      VocabularyEntryState(info: info ?? this.info, index: index ?? this.index, vocabularyID: vocabularyID??this.vocabularyID);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is VocabularyEntryState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;

  @override
  AbstractInfo toInfo() {
    return info;
  }
}

@immutable
class VerbEntryState extends AbstractInfoEntryState<VerbInfoRange> {
  final String infinitive;
  final List<VerbCategory> categories;
  final List<bool> persons;

  const VerbEntryState(
      {VerbInfoRange info, int index, this.categories = const [], this.infinitive, this.persons = const [true, true, true, true, true, true]})
      : super(info, index);

  VerbEntryState copyWith(
          {VerbInfoRange info,
          int index,
          List<VerbCategory> categories,
          String infinitive,
            List<bool> persons}) =>
      VerbEntryState(
          info: info ?? this.info,
          index: index ?? this.index,
          categories: categories ?? this.categories,
          infinitive: infinitive ?? this.infinitive,
        persons: persons?? this.persons);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is VerbEntryState &&
          runtimeType == other.runtimeType &&
          infinitive == other.infinitive &&
          categories == other.categories;

  @override
  int get hashCode =>
      super.hashCode ^ infinitive.hashCode ^ categories.hashCode;

  @override
  AbstractInfo toInfo() {
    return VerbInfoRange(
      infinitive,
      categories.toList(growable: false)
    );
  }
}
