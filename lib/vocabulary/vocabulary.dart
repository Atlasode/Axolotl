import 'dart:collection';


import 'package:axolotl/cdm/caches/path.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'vocabulary.g.dart';

@JsonSerializable(explicitToJson: true)
class VocabularyInfo implements AbstractInfo{
  final int vocabulary;
  final String fromLang;
  final String toLang;

  const VocabularyInfo(this.vocabulary, this.fromLang, this.toLang);

  VocabularyDefinition getFrom(){
    return VocabularyDefinition(vocabulary, fromLang);
  }

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
class VocabularyDefinition {
  @JsonKey(name: 'id')
  final int vocabulary;
  @JsonKey(name: 'lang_key')
  final String langKey;

  const VocabularyDefinition(this.vocabulary, this.langKey);

  factory VocabularyDefinition.fromJson(Map<String, dynamic> json) =>
      _$VocabularyDefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyDefinitionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VocabularyPair {
  @JsonKey(name: 'id')
  final int vocabulary;
  final VocabularyData first;
  final VocabularyData second;
  factory VocabularyPair.fromJson(Map<String, dynamic> json) =>
      _$VocabularyPairFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyPairToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VocabularyData {
  final int id;
  final String vocabulary;
  @JsonKey(name: 'lang_key')
  final String langKey;
  @JsonKey(defaultValue: [])
  final List<Description> descriptions;

  const VocabularyData(this.vocabulary, this.langKey, this.id, {this.descriptions = const []});

  factory VocabularyData.fromJson(Map<String, dynamic> json) => _$VocabularyDataFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyDataToJson(this);
}
