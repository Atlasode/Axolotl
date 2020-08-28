import 'dart:collection';


import 'package:axolotl/cdm/caches/path.dart';
import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'vocabulary.g.dart';

@JsonSerializable(explicitToJson: true)
class VocabularyInfo implements AbstractInfo{
  VocabularyInfo();

  Map<String, dynamic> toJson() => _$VocabularyInfoToJson(this);

  @override
  String getId() {
    return "";
  }

  @override
  InfoType getType() {
    return InfoType.VOCABULARY;
  }
}

@JsonSerializable(explicitToJson: true)
class Vocabulary {
  Vocabulary();

  factory Vocabulary.fromJson(Map<String, dynamic> json) => _$VocabularyFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyToJson(this);
}
