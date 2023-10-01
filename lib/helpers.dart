import 'package:flutter/material.dart';

dialogConfirmation({required BuildContext context, String? title, String? content, required Function() onConfirm}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return SizedBox(
        height: 100,
        child: AlertDialog(
          title: title == null ? Text('Are you sure?') : Text(title),
          content: content == null ? null : Text(content),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(ctx);
                onConfirm();
              },
            ),
            ElevatedButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      );
    },
  );
}
