import 'package:flutter/material.dart';

/// Reusable Yes/No Dialog Component
Future<bool?> showYesNoDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String yesLabel,
  required String noLabel,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(noLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(yesLabel),
          ),
        ],
      );
    },
  );
}
