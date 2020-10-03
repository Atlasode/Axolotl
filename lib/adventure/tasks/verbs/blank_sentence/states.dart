import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/adventure/tasks/verbs/blank_sentence/pages.dart';
import 'package:axolotl/constants.dart';
import 'package:axolotl/repositories/repositories.dart';
import 'package:axolotl/vocabulary/verb.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'states.g.dart';

@JsonSerializable(explicitToJson: true)
class VerbBlankTextData extends BlankTextData {

  final VerbDefinition verb;
  final Person person;
  final bool showPronoun;
  final bool showTense;

  const VerbBlankTextData(this.verb, this.person, {this.showPronoun = false, this.showTense = false}) : super(BlankTextType.VERB);

  factory VerbBlankTextData.fromJson(Map<String, dynamic> json) => _$VerbBlankTextDataFromJson(json);

  Map<String, dynamic> toJson() => _$VerbBlankTextDataToJson(this);

  Future<VerbBlankText> create() async {
    return VerbBlankText(
      await Repositories.verbs.getVerb(verb),
      person,
      showPronoun,
      showTense,
    );
  }
}

class VerbBlankText implements BlankText{

  final Verb verb;
  final Person person;
  final bool showPronoun;
  final bool showTense;

  const VerbBlankText(this.verb, this.person, this.showPronoun, this.showTense);

  @override
  String getText() {
    return verb.getForm(person);
  }

  @override
  String getHintText() {
    StringBuffer buffer = StringBuffer();
    buffer.write(verb.infinitive);
    if(showPronoun){
      buffer.write('/${conjugationPronounsShort[person.index]}');
    }
    if(showTense){
      buffer.write('/${verb.category.displayName.toLowerCase()}');
    }
    return buffer.toString();
  }
}