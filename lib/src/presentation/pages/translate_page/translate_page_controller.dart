import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/history_page/history_page.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_page.dart';
import 'package:flutter_translator_app/src/presentation/providers/select_language_provider.dart';
import 'package:flutter_translator_app/src/presentation/providers/translate_page_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/axis_page_transition.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/fade_page_route.dart';
import 'package:translator/translator.dart';

class TranslatePageController {
  /// translator instance
  final translator = GoogleTranslator();

  /// app color instance
  final AppColors appColors = AppColors();

  /// textField controller
  TextEditingController textEditingController = TextEditingController();

  /// scroll controller
  final ScrollController _listController = ScrollController();

  /// keyboard node
  final FocusNode focusNode = FocusNode();

  /// go to translation page
  void goToHistoryPage({required BuildContext context}) {
    Navigator.push(
        context,
        FadePageRoute(
          builder: (context) => HistoryPage(listController: _listController),
        ));
  }

  /// go to translation page
  void goToSelectLanguage(
      {required BuildContext context,
      required SelectLanguageType languageType,
      required SelectLanguageProvider selectLanguage,
      required TranslatePageProvider translateProvider,
      required StateSetter setState}) {
    Navigator.of(context).push(AxisPageTransition(
        child: SelectLanguagePage(
          selectLanguagePage: languageType,
          onChange: () {
            translateFrom(
                selectLanguageProvider: selectLanguage,
                translatePageProvider: translateProvider,
                setState: setState);
          },
        ),
        direction: AxisDirection.left));
  }

  /// change select language order
  void changeLanguageOrder({
    required SelectLanguageProvider selectLanguage,
    required TranslatePageProvider translateProvider,
  }) {
    var _from = selectLanguage.fromLang;
    var _to = selectLanguage.toLang;
    var _originalText = translateProvider.originalText;
    var _translatedText = translateProvider.translatedText;
    textEditingController.text = _translatedText;
    selectLanguage.fromLang = _to;
    selectLanguage.toLang = _from;
    translateProvider.originalText = _translatedText;
    translateProvider.translatedText = _originalText;
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
  }

  /// auto detect lang
  void changeToDetectLanguage(
      {required SelectLanguageProvider selectLanguage,
      required TranslatePageProvider translateProvider}) {
    var _from = selectLanguage.fromLang;
    var _to = selectLanguage.detectedLang;
    var _originalText = translateProvider.originalText;
    var _translatedText = translateProvider.translatedText;
    textEditingController.text = _translatedText;
    selectLanguage.fromLang = _to;
    selectLanguage.toLang = _from;
    translateProvider.originalText = _translatedText;
    translateProvider.translatedText = _originalText;
    translateProvider.getTranslation(
        from: _to.code!.split('-')[0],
        to: _from.code!.split('-')[0],
        text: _translatedText);
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
  }

  Future<void> textCorrection(
      {required SelectLanguageProvider selectLanguage,
      required TranslatePageProvider translateProvider}) async {
    var _from = selectLanguage.fromLang;
    var _to = selectLanguage.toLang;
    textEditingController.text = translateProvider.translate!.text!;
    translateProvider.originalText = translateProvider.translate!.text!;
    await translateProvider.getTranslation(
        from: _to.code!.split('-')[0],
        to: _from.code!.split('-')[0],
        text: translateProvider.translate!.text!);
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    return;
  }

  /// close page
  void closePage({required BuildContext context}) {
    focusNode.unfocus();
  }

  /// get data from clipboard
  validateClipBoardData(
      {required TranslatePageProvider translatePageProvider}) async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      if (value!.text!.isNotEmpty) {
        translatePageProvider.clipBoardHasData = true;
      } else {
        translatePageProvider.clipBoardHasData = false;
      }
    });
  }

  pasteClipBoardData(
      {required TranslatePageProvider translatePageProvider}) async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      translatePageProvider.originalText = value!.text.toString();
      textEditingController.text = value.text.toString();
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    });
  }

  /// set data to clipboard
  setClipBoardData({required String text}) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  translateFrom(
      {required TranslatePageProvider translatePageProvider,
      required StateSetter setState,
      required SelectLanguageProvider selectLanguageProvider}) async {
    if (textEditingController.text.isNotEmpty) {
      await translator
          .translate(translatePageProvider.originalText,
              to: selectLanguageProvider.toLang.code.toString().split('-')[0])
          .then((value) {
        setState(() {
          translatePageProvider.translatedText = value.text;
        });
      });
    }
  }
}
