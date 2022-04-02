import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:flutter_translator_app/src/core/constants/languages.dart';
import 'package:flutter_translator_app/src/data/models/language.dart';
import 'package:flutter_translator_app/src/presentation/pages/history_page/history_page.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_page.dart';
import 'package:flutter_translator_app/src/presentation/providers/select_language_provider.dart';
import 'package:flutter_translator_app/src/presentation/providers/translate_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/axis_page_transition.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/fade_page_route.dart';
import 'package:flutter_translator_app/src/presentation/widgets/sheets/snakbar.dart';

class TranslatePageController {

  /// textField controller
  late TextEditingController textEditingController;

  /// scroll controller
  final ScrollController _listController = ScrollController();

  /// keyboard node
  final FocusNode focusNode = FocusNode();

  /// stream
  late StreamSubscription<bool> keyboardSubscription;

  /// go to translation page
  void goToHistoryPage(BuildContext context, TranslateProvider translateProvider) {
    translateProvider.closePage = false;
    Navigator.push(
        context,
        FadePageRoute(
          builder: (context) => HistoryPage(listController: _listController),
        ));
  }

  /// translate text  => works
  void translateText(String text, translateProvider, languageProvider) async{
    translateProvider.originalText = text;
    translateProvider.getTranslation(
        from: languageProvider.fromLang.code!.split('-')[0],
        to: languageProvider.toLang.code!.split('-')[0],
        text: text
    ).then((value) {
      try{
        if(languageProvider.fromLang.code!.split('-')[0] != '' && languageProvider.toLang.code!.split('-')[0] != '' && textEditingController.text.isNotEmpty){
          translateProvider.translationText = value.text!;
          var _from = LanguagesList.languageList
              .where((lang) => lang['code'].toString().split('-').contains(translateProvider.translate!.sourceLanguage)
          );
          Language _detectedLang = Language();
          for(var t in _from){
            _detectedLang = Language.fromJson(t);
          }
          if(value.isCorrect!){
            languageProvider.detectedLang = _detectedLang;
          }
        } else{
          translateProvider.translationText = '';
          translateProvider.originalText = '';
        }
      } catch(err){
        debugPrint('Translate page error "check params":${err.toString()}');
      }
    });
  }

  /// willPop scope => works
  Future<bool> willPopScope(translateProvider) async{
    translateProvider.closePage = true;
    translateProvider.originalText = '';
    translateProvider.translationText = '';
    return true;
  }

  /// keyboard listener => works
  void _keyBoardListener(translateProvider, context) {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
          if (!visible) {
            translateProvider.showKeyBoard = false;
            focusNode.unfocus();
            if (textEditingController.text.isEmpty && translateProvider.closePage) {
              Navigator.pop(context);
            }
          } else {
            translateProvider.closePage = true;
            translateProvider.showKeyBoard = true;
          }
        });
  }

  /// close page => works
  void closePage(BuildContext context, TranslateProvider translateProvider) {
    focusNode.unfocus();
    if (translateProvider.closePage) {
      translateProvider.closePage = true;
      if (translateProvider.originalText.isNotEmpty) {
        translateProvider.closePage = true;
        translateProvider.translationText = '';
        translateProvider.originalText = '';
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  /// fetch detected language => works
  detectedLanguageName(TranslateProvider translateProvider) {
    var detected = LanguagesList.languageList.where((lang) => lang['code']
        .toString()
        .split('-')
        .contains(translateProvider.translate!.sourceLanguage))
        .map((e) => e['name']).toString();
    return detected;
  }

  /// go to language selection page and update
  void goToSelectLanguage(BuildContext context, SelectLanguageType languageType, SelectLanguageProvider languageProvider, TranslateProvider translateProvider,) {
    translateProvider.closePage = false;
    Navigator.of(context).push(AxisPageTransition(
        child: SelectLanguagePage(
          selectLanguagePage: languageType,
          onChange: () {
            /// fetch again
            translateText(translateProvider.originalText, translateProvider, languageProvider);
            /// position text selector to end
            textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: textEditingController.text.length));
          },
        ),
        direction: AxisDirection.left));
  }

  /// change select language order => works and update
  void changeLanguageOrder(SelectLanguageProvider languageProvider, TranslateProvider translateProvider,) {
    if(languageProvider.fromLang.code! != 'auto') {
      /// get current data
      var _from = languageProvider.fromLang;
      var _to = languageProvider.toLang;
      var _originalText = translateProvider.originalText;
      var _translatedText = translateProvider.translationText;

      /// replace data
      textEditingController.text = _translatedText;
      languageProvider.fromLang = _to;
      languageProvider.toLang = _from;
      translateProvider.originalText = _translatedText;
      translateProvider.translationText = _originalText;
      translateText(translateProvider.originalText, translateProvider, languageProvider);
      /// position text selector to end
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }
  }

  /// auto detect lang from api response => works (fix)
  void changeToDetectLanguage(SelectLanguageProvider languageProvider, TranslateProvider translateProvider) {

    if(translateProvider.translate!.sourceLanguage != languageProvider.toLang.code!.split('-')[0]) {
      var _detectedLang = languageProvider.detectedLang;
      var _originalText = translateProvider.originalText;
      textEditingController.text = _originalText;
      languageProvider.fromLang = _detectedLang;
      translateText(translateProvider.originalText, translateProvider, languageProvider);
      /// position text selector to end
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    } else{
      /// get current data
      var _from = languageProvider.fromLang;
      var _to = languageProvider.toLang;
      var _originalText = translateProvider.originalText;
      var _translatedText = translateProvider.translationText;

      /// replace data
      textEditingController.text = _translatedText;
      languageProvider.fromLang = _to;
      languageProvider.toLang = _from;
      translateProvider.originalText = _translatedText;
      translateProvider.translationText = _originalText;
      translateText(translateProvider.originalText, translateProvider, languageProvider);
      /// position text selector to end
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }
  }

  /// text correction from api response => works
  Future<void> textCorrection(SelectLanguageProvider languageProvider, TranslateProvider translateProvider) async {
    /// change translation text
    textEditingController.text = translateProvider.translate!.correctionSourceText!;
    translateProvider.originalText = translateProvider.translate!.correctionSourceText!;
    /// fetch again
    translateText(translateProvider.originalText, translateProvider, languageProvider);
    /// position text selector to end
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    return;
  }

  /// get data from clipboard => works
  _validateClipBoardData(TranslateProvider translateProvider) async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      if (value!.text!.isNotEmpty) {
        translateProvider.clipBoardHasData = true;
      } else {
        translateProvider.clipBoardHasData = false;
      }
    });
  }

  /// set text from clipboard => works
  pasteClipBoardData(TranslateProvider translateProvider, SelectLanguageProvider languageProvider) async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      translateProvider.originalText = value!.text.toString();
      textEditingController.text = value.text.toString();
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }).then((_) {
      translateText(translateProvider.originalText, translateProvider, languageProvider);
    });
  }

  /// set data to clipboard => works
  setClipBoardData(String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text)).then((value) {
      showToast(message: message);
    });
  }


  /// init view => works
  void initState(translateProvider, context){
    textEditingController = TextEditingController();
    _keyBoardListener(translateProvider, context);
    _validateClipBoardData(translateProvider);
  }

  /// dispose view callback => works
  void dispose(TranslateProvider translateProvider){
    translateProvider.originalText = '';
    translateProvider.translationText = '';
    textEditingController.dispose();
    keyboardSubscription.cancel();
  }
}
