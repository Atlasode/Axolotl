// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'states.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdventureSettings _$AdventureSettingsFromJson(Map<String, dynamic> json) {
  return AdventureSettings(
    editEnabled: json['editEnabled'] as bool,
    testSingle: json['testSingle'] as bool,
    canEditAfterTest: json['canEditAfterTest'] as bool,
    replaceWithValid: json['replaceWithValid'] as bool,
    testDirectly: json['testDirectly'] as bool,
    switchEnabled: json['switchEnabled'] as bool,
  );
}

Map<String, dynamic> _$AdventureSettingsToJson(AdventureSettings instance) =>
    <String, dynamic>{
      'editEnabled': instance.editEnabled,
      'testDirectly': instance.testDirectly,
      'testSingle': instance.testSingle,
      'canEditAfterTest': instance.canEditAfterTest,
      'switchEnabled': instance.switchEnabled,
      'replaceWithValid': instance.replaceWithValid,
    };

Adventure _$AdventureFromJson(Map<String, dynamic> json) {
  return Adventure(
    taskData: (json['taskData'] as List)
        ?.map((e) => e == null
            ? null
            : AdventureTaskData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    name: json['name'] as String,
    displayName: json['displayName'] as String,
  );
}

Map<String, dynamic> _$AdventureToJson(Adventure instance) => <String, dynamic>{
      'taskData': instance.taskData?.map((e) => e?.toJson())?.toList(),
      'name': instance.name,
      'displayName': instance.displayName,
    };

Map<String, dynamic> _$AdventureTaskDataToJson(AdventureTaskData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$TaskTypeEnumMap[instance.type],
    };

const _$TaskTypeEnumMap = {
  TaskType.NONE: 'NONE',
  TaskType.COLLECTION: 'COLLECTION',
  TaskType.SENTENCE: 'SENTENCE',
  TaskType.GAP_SENTENCE: 'GAP_SENTENCE',
  TaskType.VERB_INSTANCE: 'VERB_INSTANCE',
};

Map<String, dynamic> _$BlankTextDataToJson(BlankTextData instance) =>
    <String, dynamic>{
      'type': _$BlankTextTypeEnumMap[instance.type],
    };

const _$BlankTextTypeEnumMap = {
  BlankTextType.NONE: 'NONE',
  BlankTextType.VERB: 'VERB',
  BlankTextType.VOCABULARY: 'VOCABULARY',
};

TextSectionData _$TextSectionDataFromJson(Map<String, dynamic> json) {
  return TextSectionData(
    json['text'] as String,
    (json['blanks'] as List)
        ?.map((e) => e == null
            ? null
            : BlankTextData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TextSectionDataToJson(TextSectionData instance) =>
    <String, dynamic>{
      'text': instance.text,
      'blanks': instance.blanks?.map((e) => e?.toJson())?.toList(),
    };

TextAreaTaskData _$TextAreaTaskDataFromJson(Map<String, dynamic> json) {
  return TextAreaTaskData(
    json['name'] as String,
    (json['sections'] as List)
        ?.map((e) => e == null
            ? null
            : TextSectionData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TextAreaTaskDataToJson(TextAreaTaskData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sections': instance.sections?.map((e) => e?.toJson())?.toList(),
    };
