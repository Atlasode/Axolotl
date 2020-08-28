import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String key;
  final String name;

  Group(this.key, this.name);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
