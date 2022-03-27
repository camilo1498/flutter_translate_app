import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/history_page/history_page.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_page.dart';
import 'package:flutter_translator_app/src/presentation/providers/select_language_provider.dart';
import 'package:flutter_translator_app/src/presentation/providers/translate_page_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/axis_page_transition.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/fade_page_route.dart';

class TranslatePageController {
  /// app color instance
  final AppColors appColors = AppColors();
  /// textField controller
  TextEditingController textEditingController = TextEditingController();
  /// scroll controller
  final ScrollController _listController = ScrollController();
  /// keyboard node
  final FocusNode focusNode = FocusNode();

  /// go to translation page
  void goToHistoryPage({required BuildContext context}){
    Navigator.push(context, FadePageRoute(
      builder: (context) => HistoryPage(listController: _listController),
    ));
  }

  /// go to translation page
  void goToSelectLanguage({required BuildContext context, required SelectLanguageType languageType}){
    Navigator.of(context).push(
        AxisPageTransition(
            child: SelectLanguagePage(selectLanguagePage: languageType),
            direction:
            AxisDirection
                .left));
  }

  /// change select language order
  void changeLanguageOrder({required SelectLanguageProvider selectLanguage}){
    var _from = selectLanguage.fromLang;
    var _to = selectLanguage.toLang;
    selectLanguage.fromLang = _to;
    selectLanguage.toLang = _from;
  }

  /// close page
  void closePage({required BuildContext context}){
    Navigator.pop(context);
  }

  /// get data from clipboard
  validateClipBoardData({required TranslatePageProvider translatePageProvider}) async{
    await Clipboard.getData(Clipboard.kTextPlain).then((value){
      if(value!.text!.isNotEmpty){
        translatePageProvider.clipBoardHasData = true;
      } else{
        translatePageProvider.clipBoardHasData = false;
      }
    });
  }

  pasteClipBoardData({required TranslatePageProvider translatePageProvider}) async{
    await Clipboard.getData(Clipboard.kTextPlain).then((value){
      translatePageProvider.originalText = value!.text.toString();
      textEditingController.text = value.text.toString();
      textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
    });
  }

  /// set data to clipboard
  setClipBoardData({required String text}) async{
     await Clipboard.setData(ClipboardData(text: text));
  }

  translateFrom(){

  }

}