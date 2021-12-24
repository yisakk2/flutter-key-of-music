import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


alert(BuildContext context, String title, String content) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('확인'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      }
  );
}