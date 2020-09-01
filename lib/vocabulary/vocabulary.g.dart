// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyInfo _$VocabularyInfoFromJson(Map<String, dynamic> json) {
  return VocabularyInfo(
    json['vocabulary'] as String,
    json['fromLang'] as String,
    json['toLang'] as String,
  );
}

Map<String, dynamic> _$VocabularyInfoToJson(VocabularyInfo instance) =>
    <String, dynamic>{
      'vocabulary': instance.vocabulary,
      'fromLang': instance.fromLang,
      'toLang': instance.toLang,
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

VocabularyEntry _$VocabularyEntryFromJson(Map<String, dynamic> json) {
  return VocabularyEntry(
    json['vocabulary'] as String,
    json['fromLang'] as String,
    json['toLang'] as String,
  );
}

Map<String, dynamic> _$VocabularyEntryToJson(VocabularyEntry instance) =>
    <String, dynamic>{
      'vocabulary': instance.vocabulary,
      'fromLang': instance.fromLang,
      'toLang': instance.toLang,
    };

VocabularyData _$VocabularyDataFromJson(Map<String, dynamic> json) {
  return VocabularyData(
    json['vocabulary'] as String,
    json['lang_key'] as String,
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
      'vocabulary': instance.vocabulary,
      'lang_key': instance.langKey,
      'descriptions': instance.descriptions?.map((e) => e?.toJson())?.toList(),
    };
