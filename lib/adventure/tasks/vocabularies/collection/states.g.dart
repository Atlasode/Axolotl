// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'states.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyCollectionData _$VocabularyCollectionDataFromJson(
    Map<String, dynamic> json) {
  return VocabularyCollectionData(
    json['name'] as String,
    (json['vocabularyInfo'] as List)
        ?.map((e) => e == null
            ? null
            : VocabularyInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['firstLang'] as String,
    json['secondLang'] as String,
  );
}

Map<String, dynamic> _$VocabularyCollectionDataToJson(
        VocabularyCollectionData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'vocabularyInfo':
          instance.vocabularyInfo?.map((e) => e?.toJson())?.toList(),
      'firstLang': instance.firstLang,
      'secondLang': instance.secondLang,
    };
