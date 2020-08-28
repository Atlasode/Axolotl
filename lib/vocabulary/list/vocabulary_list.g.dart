// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyList _$VocabularyListFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['name']);
  return VocabularyList(
    json['name'] as String,
    json['displayName'] as String,
    (json['entries'] as List)
            ?.map((e) => e == null
                ? null
                : EntryPair.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$VocabularyListToJson(VocabularyList instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'entries': instance.entries?.map((e) => e?.toJson())?.toList(),
    };

_DummyClass _$_DummyClassFromJson(Map<String, dynamic> json) {
  return _DummyClass()
    ..type = _$enumDecodeNullable(_$InfoTypeEnumMap, json['type']);
}

Map<String, dynamic> _$_DummyClassToJson(_DummyClass instance) =>
    <String, dynamic>{
      'type': _$InfoTypeEnumMap[instance.type],
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

const _$InfoTypeEnumMap = {
  InfoType.NONE: 'NONE',
  InfoType.VOCABULARY: 'VOCABULARY',
  InfoType.VERB_RANGE: 'VERB_RANGE',
};
