import 'package:bloc_firebase_photo_gallery/auth/auth.dart';
import 'package:bloc_firebase_photo_gallery/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAuthError(
  BuildContext context, {
  required AuthError authError,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.title,
    content: authError.message,
    optionBuilder: () => {
      'Ok': false,
    },
  );
}
