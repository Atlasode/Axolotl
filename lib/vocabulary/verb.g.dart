// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonList _$PersonListFromJson(Map<String, dynamic> json) {
  return PersonList(
    (json['persons'] as List)
        ?.map((e) => _$enumDecodeNullable(_$PersonEnumMap, e))
        ?.toList(),
    _$enumDecodeNullable(_$PersonTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$PersonListToJson(PersonList instance) =>
    <String, dynamic>{
      'persons': instance.persons?.map((e) => _$PersonEnumMap[e])?.toList(),
      'type': _$PersonTypeEnumMap[instance.type],
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

const _$PersonEnumMap = {
  Person.FIRST_SINGULAR: 'FIRST_SINGULAR',
  Person.SECOND_SINGULAR: 'SECOND_SINGULAR',
  Person.THIRD_SINGULAR: 'THIRD_SINGULAR',
  Person.FIRST_PLURAL: 'FIRST_PLURAL',
  Person.SECOND_PLURAL: 'SECOND_PLURAL',
  Person.THIRD_PLURAL: 'THIRD_PLURAL',
};

const _$PersonTypeEnumMap = {
  PersonType.NONE: 'NONE',
  PersonType.ALL: 'ALL',
  PersonType.SELECTED: 'SELECTED',
};

Map<String, dynamic> _$VerbToJson(Verb instance) => <String, dynamic>{
      'infinitive': instance.infinitive,
      'category': instance.category,
      'verb_english': instance.verbEnglish,
      'forms': instance.forms,
    };

VerbDefinition _$VerbDefinitionFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['infinitive', 'category']);
  return VerbDefinition(
    json['infinitive'] as String,
    json['category'] == null
        ? null
        : VerbCategory.fromJson(json['category'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VerbDefinitionToJson(VerbDefinition instance) =>
    <String, dynamic>{
      'infinitive': instance.infinitive,
      'category': instance.category?.toJson(),
    };

VerbCategory _$VerbCategoryFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['mood', 'tense']);
  return VerbCategory(
    mood: json['mood'] as String ?? 'Indicativo',
    tense: json['tense'] as String ?? 'Presente',
    personList: json['personList'] == null
        ? null
        : PersonList.fromJson(json['personList'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VerbCategoryToJson(VerbCategory instance) =>
    <String, dynamic>{
      'mood': instance.mood,
      'tense': instance.tense,
      'personList': instance.personList,
    };

VerbInfoRange _$VerbInfoRangeFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['infinitive']);
  return VerbInfoRange(
    json['infinitive'] as String,
    (json['categories'] as List)
            ?.map((e) => e == null
                ? null
                : VerbCategory.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$VerbInfoRangeToJson(VerbInfoRange instance) =>
    <String, dynamic>{
      'infinitive': instance.infinitive,
      'categories': instance.categories?.map((e) => e?.toJson())?.toList(),
    };
