import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();

  return showDialog<T>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: options.keys
          .map((e) => TextButton(
                onPressed: () {
                  Navigator.of(context).pop(options[e]);
                },
                child: Text(e),
              ))
          .toList(),
    ),
  );
}
