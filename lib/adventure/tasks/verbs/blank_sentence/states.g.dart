// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'states.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerbBlankTextData _$VerbBlankTextDataFromJson(Map<String, dynamic> json) {
  return VerbBlankTextData(
    json['verb'] == null
        ? null
        : VerbDefinition.fromJson(json['verb'] as Map<String, dynamic>),
    _$enumDecodeNullable(_$PersonEnumMap, json['person']),
    showPronoun: json['showPronoun'] as bool,
    showTense: json['showTense'] as bool,
  );
}

Map<String, dynamic> _$VerbBlankTextDataToJson(VerbBlankTextData instance) =>
    <String, dynamic>{
      'verb': instance.verb?.toJson(),
      'person': _$PersonEnumMap[instance.person],
      'showPronoun': instance.showPronoun,
      'showTense': instance.showTense,
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
