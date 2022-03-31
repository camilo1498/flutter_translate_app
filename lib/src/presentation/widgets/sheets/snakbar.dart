import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/core/extensions/hex_color.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// show message in a snackBar
snackBar(
    {required scaffoldGlobalKey,
      required String message,
      required Color color,
      required String labelText,
      required Color textColor}) {
  scaffoldGlobalKey.currentState.removeCurrentSnackBar();
  SnackBar _snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(
          color: textColor, fontWeight: FontWeight.w600, fontSize: 13),
    ),
    elevation: 5,
    duration: const Duration(seconds: 5),
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
    action: SnackBarAction(
      onPressed: () {},
      label: labelText,
    ),
  );
  return scaffoldGlobalKey.currentState.showSnackBar(_snackBar);
}

showToast({required message}){
  Fluttertoast.showToast(
      msg: message ?? 'Error',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: HexColor.fromHex('#1C2938'),
      textColor: HexColor.fromHex('#EFEEEE'),
      fontSize: 16.0
  );
}