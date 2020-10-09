import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlusBarBuilder extends StatelessWidget {
  const FlusBarBuilder({
    Key key,
    @required this.context,
    @required this.msg,
  }) : super(key: key);

  final BuildContext context;
  final String msg;

  @override
  Widget build(BuildContext context) => Flushbar(
        message: msg,
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.all(8),
        leftBarIndicatorColor: Colors.blue[300],
        borderRadius: 8,
        // flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 1),
      )..show(context);
}
