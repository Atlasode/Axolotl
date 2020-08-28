import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final String text;
  final double ratio;
  final double stroke;
  final double dividerHeight;

  const LoadingWidget({Key key, this.constraints, this.text = 'Loading...', this.ratio = 1 / 4, this.stroke = 6, this.dividerHeight = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return handleLayout(
        context: context,
        builder: (BuildContext context, BoxConstraints constraints) => Center(
            child: Container(
                height: constraints.maxHeight,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          width: constraints.maxWidth * ratio,
                          height: constraints.maxWidth * ratio,
                          child: CircularProgressIndicator(strokeWidth: stroke)),
                      SizedBox(
                        height: dividerHeight,
                      ),
                      Text(
                        text,
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ]))));
  }

  Widget handleLayout({BuildContext context, LayoutWidgetBuilder builder}) {
    if (constraints != null) {
      return builder(context, constraints);
    } else {
      return LayoutBuilder(builder: builder);
    }
  }
}
