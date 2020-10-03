// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'states.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerbInstanceTaskData _$VerbInstanceTaskDataFromJson(Map<String, dynamic> json) {
  return VerbInstanceTaskData(
    json['name'] as String,
    json['verb'] == null
        ? null
        : VerbDefinition.fromJson(json['verb'] as Map<String, dynamic>),
    (json['persons'] as List)
        ?.map((e) => _$enumDecodeNullable(_$PersonEnumMap, e))
        ?.toSet(),
  );
}

Map<String, dynamic> _$VerbInstanceTaskDataToJson(
        VerbInstanceTaskData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'verb': instance.verb?.toJson(),
      'persons': instance.persons?.map((e) => _$PersonEnumMap[e])?.toList(),
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
