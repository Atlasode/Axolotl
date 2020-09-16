import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlutterUtils {

  static Future<T> pushPage<T>({BuildContext context, WidgetBuilder builder}) {
    return Navigator.push(context, MaterialPageRoute(builder: builder));
  }
}
