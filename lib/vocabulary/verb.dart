import 'dart:collection';

import 'package:axolotl/vocabulary/list/vocabulary_list.dart';
import 'package:axolotl/utils/common_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verb.g.dart';

enum Person {
  FIRST_SINGULAR,
  SECOND_SINGULAR,
  THIRD_SINGULAR,
  FIRST_PLURAL,
  SECOND_PLURAL,
  THIRD_PLURAL
}

enum PersonType { NONE, ALL, SELECTED }



@JsonSerializable()
class PersonList {
  static const PersonList EMPTY = PersonList(const [], PersonType.NONE);
  static const PersonList ALL = PersonList(Person.values, PersonType.ALL);

  final List<Person> persons;
  final PersonType type;

  const PersonList(this.persons, this.type);

  factory PersonList.only(Iterable<Person> persons) {
    return PersonList(persons, PersonType.SELECTED);
  }

  factory PersonList.fromJson(Map<String, dynamic> json) {
    PersonType type = _$enumDecodeNullable(_$PersonTypeEnumMap, json['type']);
    switch (type) {
      case PersonType.ALL:
        return ALL;
      case PersonType.SELECTED:
        return _$PersonListFromJson(json);
      default:
        return EMPTY;
    }
  }

  Map<String, dynamic> toJson() {
    switch (type) {
      case PersonType.SELECTED:
        return _$PersonListToJson(this);
      default:
        return {
          'type': _$PersonTypeEnumMap[type],
        };
    }
  }

  bool hasIndex(int index) {
    assert(index < 6);
    return hasPerson(Person.values[index]);
  }

  bool hasPerson(Person person) {
    return persons.contains(person);
  }

  PersonList copyWith({int index = -1, bool state = false, List<Person> persons}){
    assert(index < 6 && state != null);
    Set<Person> personSet = Set.of(persons??this.persons);
    if(index >= 0){
      Person person = Person.values[index];
      if(state){
        personSet.add(Person.values[index]);
      }else{
        personSet.remove(person);
      }
    }
    return PersonList(
      personSet.toList(),
      personSet.length == 6 ? PersonType.ALL  : PersonType.SELECTED
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonList &&
          runtimeType == other.runtimeType &&
          persons == other.persons &&
          type == other.type;

  @override
  int get hashCode => persons.hashCode ^ type.hashCode;
}

@JsonSerializable(createFactory: false)
class Verb extends VerbDefinition {
  @JsonKey(name: 'verb_english')
  final String verbEnglish;
  @JsonKey(fromJson: parseForms)
  final List<String> forms;

  Verb(String infinitive, VerbCategory category, this.verbEnglish, this.forms)
      : super(infinitive, category);

  factory Verb.fromJson(Map<String, dynamic> json) {
    $checkKeys(json, requiredKeys: const ['mood', 'tense', 'infinitive']);
    return Verb(
      json['infinitive'] as String,
      parseCategory(json),
      json['verb_english'] as String,
      parseForms(json),
    );
  }

  Map<String, dynamic> toJson() => _$VerbToJson(this);

  static VerbCategory parseCategory(json) {
    if (json["category"] != null) {
      return VerbCategory.fromJson(json["category"]);
    }
    return VerbCategory(mood: json["mood"], tense: json["tense"]);
  }

  static List<String> parseForms(json) {
    if (json["forms"] == null) {
      if (json["form_1s"] == null) {
        return [];
      }
      return [
        json["form_1s"] as String,
        json["form_2s"] as String,
        json["form_3s"] as String,
        json["form_1p"] as String,
        json["form_2p"] as String,
        json["form_3p"] as String
      ];
    }
    return json["forms"] ?? [];
  }

  String getForm(Person person){
    return forms[person.index];
  }
}

@JsonSerializable(explicitToJson: true)
class VerbDefinition {
  @JsonKey(required: true)
  final String infinitive;
  @JsonKey(required: true)
  final VerbCategory category;

  VerbDefinition(this.infinitive, [this.category = const VerbCategory()]);

  factory VerbDefinition.fromJson(Map<String, dynamic> json) =>
      _$VerbDefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$VerbDefinitionToJson(this);

  String get displayInfinitive => infinitive.capitalize();
}



@JsonSerializable()
class VerbCategory {
  static const List<VerbCategory> validCategories = [
    const VerbCategory(mood: 'Indicativo', tense: 'Presente'),
    const VerbCategory(mood: 'Indicativo', tense: 'Futuro'),
    const VerbCategory(mood: 'Indicativo', tense: 'Imperfecto'),
    const VerbCategory(mood: 'Indicativo', tense: 'Pretérito'),
    const VerbCategory(mood: 'Indicativo', tense: 'Condicional'),
    const VerbCategory(mood: 'Indicativo', tense: 'Presente perfecto'),
    const VerbCategory(mood: 'Indicativo', tense: 'Futuro perfecto'),
    const VerbCategory(mood: 'Indicativo', tense: 'Pluscuamperfecto'),
    const VerbCategory(mood: 'Indicativo', tense: 'Pretérito anterior'),
    const VerbCategory(mood: 'Indicativo', tense: 'Condicional perfecto'),
    const VerbCategory(mood: 'Subjuntivo', tense: 'Presente'),
    const VerbCategory(mood: 'Subjuntivo', tense: 'Imperfecto'),
    const VerbCategory(mood: 'Subjuntivo', tense: 'Futuro'),
    const VerbCategory(mood: 'Subjuntivo', tense: 'Presente perfecto'),
    const VerbCategory(mood: 'Subjuntivo', tense: 'Futuro perfecto'),
    const VerbCategory(mood: 'Subjuntivo', tense: 'Pluscuamperfecto'),
    const VerbCategory(mood: 'Imperativo Afirmativo', tense: 'Presente'),
    const VerbCategory(mood: 'Imperativo Negativo',	tense: 'Presente'),
  ];

  static Map<String, Set<VerbCategory>> _categoriesByMood;

  @JsonKey(required: true, defaultValue: 'Indicativo')
  final String mood;
  @JsonKey(required: true, defaultValue: 'Presente')
  final String tense;
  @JsonKey()
  final PersonList personList;

  const VerbCategory(
      {this.mood = 'Indicativo',
      this.tense = 'Presente',
      PersonList personList})
      : this.personList = personList ?? PersonList.ALL;

  factory VerbCategory.fromJson(Map<String, dynamic> json) =>
      _$VerbCategoryFromJson(json);

  static Map<String, Set<VerbCategory>> get categoriesByMood {
    if(_categoriesByMood == null){
      _categoriesByMood = {};
      for(VerbCategory category in validCategories){
        _categoriesByMood.putIfAbsent(category.mood, ()=>{}).add(category);
      }
    }
    return _categoriesByMood;
  }

  String get displayName => '$mood $tense';

  VerbCategory copyWith({String mood, String tense, PersonList personList}) =>
      VerbCategory(
          mood: mood ?? this.mood,
          tense: tense ?? this.tense,
          personList: personList ?? this.personList);

  Map<String, dynamic> toJson() => _$VerbCategoryToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerbCategory &&
          runtimeType == other.runtimeType &&
          mood == other.mood &&
          tense == other.tense &&
          personList == other.personList;

  @override
  int get hashCode => mood.hashCode ^ tense.hashCode ^ personList.hashCode;

  @override
  String toString() {
    return '{mood: $mood, tense: $tense}';
  }
}

@JsonSerializable(explicitToJson: true)
class VerbInfoRange implements AbstractInfo {
  @JsonKey(required: true)
  final String infinitive;
  @JsonKey(defaultValue: [])
  final List<VerbCategory> categories;

  VerbInfoRange(this.infinitive,
      [this.categories = const [const VerbCategory()]]);

  Iterable<VerbDefinition> toPairs() =>
      categories.map((category) => VerbDefinition(infinitive, category));

  factory VerbInfoRange.fromJson(Map<String, dynamic> json) =>
      _$VerbInfoRangeFromJson(json);

  Map<String, dynamic> toJson() => _$VerbInfoRangeToJson(this);

  @override
  String getId() {
    return '$infinitive,[${categories.map((e) => e.toString()).join(', ')}]';
  }

  @override
  InfoType getType() {
    return InfoType.VERB_RANGE;
  }

  @override
  String toString() {
    return '{infinitive: $infinitive, categories: $categories}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerbInfoRange &&
          runtimeType == other.runtimeType &&
          infinitive == other.infinitive &&
          categories == other.categories;

  @override
  int get hashCode => infinitive.hashCode ^ categories.hashCode;
}
