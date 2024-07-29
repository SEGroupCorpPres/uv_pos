import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SessionEnding {
  Future onWillPop(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ilovadan chiqmoqchimisiz ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Yo\'q'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text('Ha'),
          ),
        ],
      ),
    );
  }
}
