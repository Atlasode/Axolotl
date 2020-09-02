// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyInfo _$VocabularyInfoFromJson(Map<String, dynamic> json) {
  return VocabularyInfo(
    json['vocabulary'] as int,
    json['firstLang'] as String,
    json['secondLang'] as String,
  );
}

Map<String, dynamic> _$VocabularyInfoToJson(VocabularyInfo instance) =>
    <String, dynamic>{
      'vocabulary': instance.vocabulary,
      'firstLang': instance.firstLang,
      'secondLang': instance.secondLang,
    };

Description _$DescriptionFromJson(Map<String, dynamic> json) {
  return Description(
    _$enumDecodeNullable(_$DescriptionTypeEnumMap, json['type']),
    json['data'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$DescriptionToJson(Description instance) =>
    <String, dynamic>{
      'type': _$DescriptionTypeEnumMap[instance.type],
      'data': instance.data,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$DescriptionTypeEnumMap = {
  DescriptionType.SENTENCE: 'SENTENCE',
};

VocabularyDefinition _$VocabularyDefinitionFromJson(Map<String, dynamic> json) {
  return VocabularyDefinition(
    json['id'] as int,
    json['lang_key'] as String,
  );
}

Map<String, dynamic> _$VocabularyDefinitionToJson(
        VocabularyDefinition instance) =>
    <String, dynamic>{
      'id': instance.vocabulary,
      'lang_key': instance.langKey,
    };

VocabularyPair _$VocabularyPairFromJson(Map<String, dynamic> json) {
  return VocabularyPair(
    json['id'] as int,
    json['first'] == null
        ? null
        : VocabularyData.fromJson(json['first'] as Map<String, dynamic>),
    json['second'] == null
        ? null
        : VocabularyData.fromJson(json['second'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VocabularyPairToJson(VocabularyPair instance) =>
    <String, dynamic>{
      'id': instance.vocabulary,
      'first': instance.first?.toJson(),
      'second': instance.second?.toJson(),
    };

VocabularyData _$VocabularyDataFromJson(Map<String, dynamic> json) {
  return VocabularyData(
    json['vocabulary'] as String,
    json['lang_key'] as String,
    json['id'] as int,
    descriptions: (json['descriptions'] as List)
            ?.map((e) => e == null
                ? null
                : Description.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$VocabularyDataToJson(VocabularyData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vocabulary': instance.vocabulary,
      'lang_key': instance.langKey,
      'descriptions': instance.descriptions?.map((e) => e?.toJson())?.toList(),
    };
