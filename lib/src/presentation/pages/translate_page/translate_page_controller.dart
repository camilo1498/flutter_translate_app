import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_translate_app/src/core/constants/languages.dart';
import 'package:flutter_translate_app/src/data/models/History.dart';
import 'package:flutter_translate_app/src/data/models/language.dart';
import 'package:flutter_translate_app/src/data/sources/local_db/translator_batabase.dart';
import 'package:flutter_translate_app/src/presentation/pages/history_page/history_page.dart';
import 'package:flutter_translate_app/src/presentation/pages/select_language_page/select_language_page.dart';
import 'package:flutter_translate_app/src/presentation/providers/database_provider.dart';
import 'package:flutter_translate_app/src/presentation/providers/language_provider.dart';
import 'package:flutter_translate_app/src/presentation/providers/translate_provider.dart';
import 'package:flutter_translate_app/src/presentation/widgets/animations/page_transitions/axis_page_transition.dart';
import 'package:flutter_translate_app/src/presentation/widgets/animations/page_transitions/fade_page_route.dart';
import 'package:flutter_translate_app/src/presentation/widgets/sheets/snakbar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class TranslatePageController {
  /// build context
  final BuildContext context;
  final StateSetter setState;

  /// providers
  late TranslateProvider _translateProvider;
  late LanguageProvider _languageProvider;
  late DatabaseProvider _historyProvider;

  TranslatePageController({required this.context, required this.setState}) {
    _translateProvider = Provider.of<TranslateProvider>(context, listen: false);
    _languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    _historyProvider = Provider.of<DatabaseProvider>(context, listen: false);
  }

  /// tts reproduce
  bool isFromLangPlaying = false;
  bool isToLangPlaying = false;
  bool fromLangSupport = true;
  bool toLangSupport = true;

  /// textField controller
  late TextEditingController textEditingController;

  /// scroll controller
  final ScrollController _listController = ScrollController();

  /// keyboard node
  final FocusNode focusNode = FocusNode();

  /// stream
  late StreamSubscription<bool> keyboardSubscription;

  /// tts
  FlutterTts flutterTts = FlutterTts();

  /// go to translation page
  void goToHistoryPage() {
    _translateProvider.closePage = false;
    Navigator.push(
        context,
        FadePageRoute(
          builder: (context) => HistoryPage(listController: _listController),
        ));
  }

  /// translate text  => works
  void translateText(String text) async {
    _translateProvider.originalText = text;
    _translateProvider
        .getTranslation(
            from: _languageProvider.fromLang.code!,
            to: _languageProvider.toLang.code!,
            text: text)
        .then((value) {
      try {
        if (_languageProvider.fromLang.code! != '' &&
            _languageProvider.toLang.code! != '' &&
            textEditingController.text.isNotEmpty) {
          _translateProvider.translationText = value.text!;
          var from = LanguagesList.languageList.where((lang) => lang['code']
              .toString()
              .contains(_translateProvider.translate!.sourceLanguage!));
          Language detectedLang = Language();
          for (var t in from) {
            detectedLang = Language.fromJson(t);
          }
          if (value.isCorrect!) {
            _languageProvider.detectedLang = detectedLang;
          }
        } else {
          _translateProvider.translationText = '';
          _translateProvider.originalText = '';
        }
      } catch (err) {
        debugPrint('Translate page error "check params":${err.toString()}');
      }
    });
  }

  /// willPop scope => works
  Future<bool> willPopScope() async {
    _translateProvider.closePage = true;
    _translateProvider.originalText = '';
    _translateProvider.translationText = '';

    return true;
  }

  /// keyboard listener => works
  void _keyBoardListener() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        addToHistory();
        _translateProvider.showKeyBoard = false;
        focusNode.unfocus();
        if (textEditingController.text.isEmpty &&
            _translateProvider.closePage) {
          Navigator.pop(context);
        }
      } else {
        _translateProvider.closePage = true;
        _translateProvider.showKeyBoard = true;
      }
    });
  }

  /// close page => works
  void closePage() {
    focusNode.unfocus();
    if (_translateProvider.closePage) {
      _translateProvider.closePage = true;
      if (_translateProvider.originalText.isNotEmpty) {
        _translateProvider.closePage = true;
        _translateProvider.translationText = '';
        _translateProvider.originalText = '';
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  /// fetch detected language => works
  detectedLanguageName() {
    var detected = LanguagesList.languageList
        .where((lang) => lang['code']
            .toString()
            .split('-')
            .contains(_translateProvider.translate!.sourceLanguage))
        .map((e) => e['name'])
        .toString();
    return detected;
  }

  /// go to language selection page and update
  void goToSelectLanguage(SelectLanguageType languageType) {
    _translateProvider.closePage = false;
    Navigator.of(context).push(AxisPageTransition(
        child: SelectLanguagePage(
          selectLanguagePage: languageType,
          onChange: () {
            /// fetch again
            translateText(_translateProvider.originalText);

            /// position text selector to end
            textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: textEditingController.text.length));
          },
        ),
        direction: AxisDirection.left));
  }

  /// change select language order => works and update
  void changeLanguageOrder() {
    if (_languageProvider.fromLang.code! != 'auto') {
      /// get current data
      var _from = _languageProvider.fromLang;
      var _to = _languageProvider.toLang;
      var _originalText = _translateProvider.originalText;
      var _translatedText = _translateProvider.translationText;

      /// replace data
      textEditingController.text = _translatedText;
      _languageProvider.fromLang = _to;
      _languageProvider.toLang = _from;
      _translateProvider.originalText = _translatedText;
      _translateProvider.translationText = _originalText;

      /// fetch again
      translateText(_translateProvider.originalText);

      /// position text selector to end
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }
  }

  /// auto detect lang from api response => works (fix)
  void changeToDetectLanguage() {
    if (_translateProvider.translate!.sourceLanguage !=
        _languageProvider.toLang.code!) {
      /// get current data
      var _detectedLang = _languageProvider.detectedLang;
      var _originalText = _translateProvider.originalText;

      /// replace data
      textEditingController.text = _originalText;
      _languageProvider.fromLang = _detectedLang;

      /// fetch again
      translateText(_translateProvider.originalText);

      /// position text selector to end
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    } else {
      /// get current data
      var _from = _languageProvider.fromLang;
      var _to = _languageProvider.toLang;
      var _originalText = _translateProvider.originalText;
      var _translatedText = _translateProvider.translationText;

      /// replace data
      textEditingController.text = _translatedText;
      _languageProvider.fromLang = _to;
      _languageProvider.toLang = _from;
      _translateProvider.originalText = _translatedText;
      _translateProvider.translationText = _originalText;
      translateText(_translateProvider.originalText);

      /// position text selector to end
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }
  }

  /// text correction from api response => works
  Future<void> textCorrection() async {
    /// change translation text
    textEditingController.text =
        _translateProvider.translate!.correctionSourceText!;
    _translateProvider.originalText =
        _translateProvider.translate!.correctionSourceText!;

    /// fetch again
    translateText(_translateProvider.originalText);

    /// position text selector to end
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    return;
  }

  /// get data from clipboard => works
  _validateClipBoardData() async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      if (value!.text!.isNotEmpty) {
        _translateProvider.clipBoardHasData = true;
      } else {
        _translateProvider.clipBoardHasData = false;
      }
    });
  }

  /// set text from clipboard => works
  pasteClipBoardData() async {
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      _translateProvider.originalText = value!.text.toString();
      textEditingController.text = value.text.toString();
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }).then((_) {
      translateText(_translateProvider.originalText);
    });
  }

  /// set data to clipboard => works
  setClipBoardData(String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text)).then((value) {
      showToast(message: message);
    });
  }

  /// add element to history => works
  addToHistory() {
    if (textEditingController.text.trim().isNotEmpty &&
        _translateProvider.originalText.isNotEmpty &&
        _translateProvider.translationText.isNotEmpty) {
      final historyElement = History(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        originalText: _translateProvider.originalText,
        translationText: _translateProvider.translationText,
        translationTextCode: _languageProvider.toLang.code!,
        originalTextCode: _languageProvider.fromLang.code!,
        isFavorite: 'false',
      );
      createHistoryElement(historyElement);
    }
  }

  /// add element to history
  Future createHistoryElement(History history) async {
    await TranslateDataBase.instance.insertHistory(history).then((element) {
      _historyProvider.historyList.add(element);
    });
  }

  /// reproduce "fromLang" audio
  Future ttsFrom() async {
    await flutterTts
        .isLanguageAvailable(_languageProvider.fromLang.tts!)
        .then((available) async {
      if (available) {
        setState(() {
          isToLangPlaying = false;
          isFromLangPlaying = true;
        });
        await flutterTts
            .setLanguage(_languageProvider.fromLang.tts!)
            .then((value) async {
          await flutterTts.speak(_translateProvider.originalText);
        });
      } else {
        setState(() => fromLangSupport = false);
        Timer.periodic(const Duration(seconds: 2), (timer) {
          setState(() => fromLangSupport = true);
          timer.cancel();
        });
      }
    });
  }

  /// reproduce "ttsTo" audio
  Future ttsTo() async {
    await flutterTts
        .isLanguageAvailable(_languageProvider.toLang.tts!)
        .then((available) async {
      if (available) {
        setState(() {
          isFromLangPlaying = false;
          isToLangPlaying = true;
        });
        await flutterTts
            .setLanguage(_languageProvider.toLang.tts!)
            .then((value) async {
          await flutterTts.speak(_translateProvider.translationText);
        });
      } else {
        setState(() => toLangSupport = false);
        Timer.periodic(const Duration(seconds: 2), (timer) {
          setState(() => toLangSupport = true);
          timer.cancel();
        });
      }
    });
  }

  /// stop tts
  Future ttsStop() async {
    var res = await flutterTts.stop();
    if (res == 1) {
      setState(() {
        isFromLangPlaying = false;
        isToLangPlaying = false;
      });
    }
  }

  /// init view => works
  void initState() {
    flutterTts.setCompletionHandler(() {
      setState(() {
        isFromLangPlaying = false;
        isToLangPlaying = false;
      });
    });

    textEditingController = TextEditingController();
    _keyBoardListener();
    _validateClipBoardData();
  }

  /// dispose view callback => works
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _translateProvider.originalText = '';
      _translateProvider.translationText = '';
      _translateProvider.translate = null;
    });

    textEditingController.dispose();
    keyboardSubscription.cancel();
  }
}
