import 'dart:collection';


import 'package:axolotl/cdm/caches/path.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'vocabulary.g.dart';

@JsonSerializable(explicitToJson: true)
class VocabularyInfo implements AbstractInfo{
  final String id;
  final String givenLang;
  final String expectedLang;

  const VocabularyInfo(this.id, this.givenLang, this.expectedLang);

  VocabularyDefinition getGiven(){
    return VocabularyDefinition(id, givenLang);
  }

  VocabularyDefinition getExpected(){
    return VocabularyDefinition(id, expectedLang);
  }

  Map<String, dynamic> toJson() => _$VocabularyInfoToJson(this);

  @override
  String getId() {
    return "$id";
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
class VocabularyDefinition {
  final String id;
  @JsonKey(name: 'lang_key')
  final String langKey;

  const VocabularyDefinition(this.id, this.langKey);

  factory VocabularyDefinition.fromJson(Map<String, dynamic> json) =>
      _$VocabularyDefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyDefinitionToJson(this);

}

@JsonSerializable(explicitToJson: true)
class VocabularyPair {
  final String id;
  final VocabularyData given;
  final VocabularyData expected;

  const VocabularyPair(this.id, this.given, this.expected);

  factory VocabularyPair.fromJson(Map<String, dynamic> json) =>
      _$VocabularyPairFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyPairToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VocabularyData {
  final String id;
  final List<String> terms;
  @JsonKey(name: 'lang_key')
  final String langKey;
  @JsonKey(defaultValue: [])
  final List<Description> descriptions;

  const VocabularyData(this.terms, this.langKey, this.id, {this.descriptions = const []});

  factory VocabularyData.single(String term, String langKey, String id, {List<Description> descriptions = const []})  {
    return VocabularyData([term], langKey, id, descriptions: descriptions);
  }

  factory VocabularyData.multi(List<String> terms, String langKey, String id, {List<Description> descriptions = const []})  {
    return VocabularyData(terms, langKey, id, descriptions: descriptions);
  }

  factory VocabularyData.fromJson(Map<String, dynamic> json) => _$VocabularyDataFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyDataToJson(this);
}
