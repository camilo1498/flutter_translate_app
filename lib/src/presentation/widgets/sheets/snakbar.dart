import 'package:flutter_translate_app/src/core/extensions/hex_color.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast({required message}) {
  Fluttertoast.showToast(
      msg: message ?? 'Error',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: HexColor.fromHex('#1C2938'),
      textColor: HexColor.fromHex('#EFEEEE'),
      fontSize: 16.0);
}
