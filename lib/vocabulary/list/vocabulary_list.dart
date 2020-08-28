import 'dart:collection';

import 'package:axolotl/repositories/verb_repository.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:axolotl/vocabulary/vocabulary.dart';
import 'package:axolotl/vocabulary/vocabulary_page.dart';
import 'package:empty_collections/empty_collections.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vocabulary_list.g.dart';

@JsonSerializable(explicitToJson: true)
class VocabularyList {
  // ignore: non_constant_identifier_names
  static const EMPTY = VocabularyList("empty", "Empty", const []);
  // ignore: non_constant_identifier_names
  static final DUMMY = VocabularyList(
      "dummy",
      "Dummy",
      VocabularyStorage.defaultVocabularies
          .map((verb) => EntryPair(InfoType.VERB_RANGE, VerbInfoRange(verb)))
          .toList(growable: false));

  @JsonKey(required: true)
  final String name;
  final String displayName;
  @JsonKey(defaultValue: [])
  final List<EntryPair> entries;

  const VocabularyList(this.name, this.displayName, [this.entries = const []]);

  factory VocabularyList.fromJson(Map<String, dynamic> json) =>
      _$VocabularyListFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyListToJson(this);

  List<AbstractInfo> createInfoList() {
    return entries.map((e) => e.provider).toList();
  }

  VocabularyList copyWith({String name, String displayName, List<EntryPair> entries}){
    return VocabularyList(
      name??this.name,
      displayName??this.displayName,
      entries??this.entries
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyList &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          displayName == other.displayName;

  @override
  int get hashCode => name.hashCode ^ displayName.hashCode;
}

//Needed so the build_runner generates the enum decoder for the 'InfoType' enum
@JsonSerializable()
class _DummyClass {
  InfoType type;
}

class EntryPair {
  final InfoType type;
  final AbstractInfo provider;

  EntryPair(this.type, this.provider);

  factory EntryPair.fromJson(Map<String, dynamic> json) {
    InfoType type = _$enumDecodeNullable(_$InfoTypeEnumMap, json['type']);
    return EntryPair(type, AbstractInfo.fromJson(type, json['data']));
  }

  Map<String, dynamic> toJson() => {
        'type': _$InfoTypeEnumMap[type],
        'data': AbstractInfo._toJson(type, provider)
      };
}

enum InfoType { NONE, VOCABULARY, VERB_RANGE }

class EmptyInfo implements AbstractInfo {
  static const EmptyInfo INSTANCE = EmptyInfo();

  const EmptyInfo();

  @override
  String getId() {
    return "";
  }

  @override
  InfoType getType() {
    return InfoType.NONE;
  }

  @override
  Map<String, dynamic> toJson() {
    return EmptyMap();
  }
}

abstract class AbstractInfo {
  InfoType getType();

  String getId();

  factory AbstractInfo.fromJson(InfoType type, Map<String, dynamic> json) {
    switch (type) {
      case InfoType.VERB_RANGE:
        return VerbInfoRange.fromJson(json);
      case InfoType.VOCABULARY:
        return null;
      case InfoType.NONE:
      default:
        return EmptyInfo.INSTANCE;
    }
  }

  static Map<String, dynamic> _toJson(InfoType type, AbstractInfo provider) {
    return provider.toJson();
  }

  Map<String, dynamic> toJson();
}
