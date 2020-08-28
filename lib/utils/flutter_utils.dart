import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef GenericBuilder<T extends Widget> = T Function(BuildContext context);

class FlutterUtils {

  static Future<T> pushPage<T extends Widget>({BuildContext context, GenericBuilder<T> builder}) {
    return Navigator.push(context, MaterialPageRoute(builder: builder));
  }
}
