import 'package:flutter/material.dart';

import 'package:flutter_translator_app/src/core/constants/app_colors.dart';

class TranslatePageController {
  /// app color instance
  final AppColors appColors = AppColors();
  /// textField controller
  TextEditingController textEditingController = TextEditingController();


  void closePage({required BuildContext context}){
    Navigator.pop(context);
  }
}