import 'dart:collection';


import 'package:axolotl/cdm/caches/path.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'vocabulary.g.dart';

@JsonSerializable(explicitToJson: true)
class VocabularyInfo implements AbstractInfo{
  final String vocabulary;
  final String fromLang;
  final String toLang;

  const VocabularyInfo(this.vocabulary, this.fromLang, this.toLang);

  Map<String, dynamic> toJson() => _$VocabularyInfoToJson(this);

  @override
  String getId() {
    return "$vocabulary";
  }

  @override
  InfoType getType() {
    return InfoType.VOCABULARY;
  }
}

enum DescriptionType {
  SENTENCE
}

@JsonSerializable()
class Description {
  final DescriptionType type;
  final Map<String, dynamic> data;

  const Description(this.type, this.data);

  factory Description.fromJson(Map<String, dynamic> json) => _$DescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$DescriptionToJson(this);

}

@JsonSerializable()
class VocabularyEntry {
  final String vocabulary;
  final String fromLang;
  final String toLang;

  const VocabularyEntry(this.vocabulary, this.fromLang, this.toLang);

  factory VocabularyEntry.fromJson(Map<String, dynamic> json) => _$VocabularyEntryFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyEntryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VocabularyData {
  final String vocabulary;
  @JsonKey(name: 'lang_key')
  final String langKey;
  @JsonKey(defaultValue: [])
  final List<Description> descriptions;

  const VocabularyData(this.vocabulary, this.langKey, {this.descriptions = const []});

  factory VocabularyData.fromJson(Map<String, dynamic> json) => _$VocabularyDataFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyDataToJson(this);
}
