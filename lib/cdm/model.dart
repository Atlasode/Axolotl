import 'package:axolotl/utils/flutter_utils.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as material;

abstract class ModelInstance {
  String get key;
  String get name;
}

abstract class NamedInstance implements ModelInstance {
  String get short;
}