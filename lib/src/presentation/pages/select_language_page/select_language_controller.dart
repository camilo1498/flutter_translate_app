import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_translator_app/src/data/models/language.dart';
import 'package:flutter_translator_app/src/presentation/providers/language_provider.dart';

class SelectLanguageController {

  /// textField controller
  late TextEditingController searchController;

  /// focus node
  final FocusNode focusNode = FocusNode();

  /// stream
  late StreamSubscription<bool> keyboardSubscription;

  List<Language> languages = [];


  void _clearSearchList() {
    languages.clear();
  }

  /// on search language
  void searchBox(String langName, LanguageProvider languageProvider, setState) {
    final suggestions = languageProvider.languagesList.where((lang) {
      final name = lang.name!.toLowerCase();
      final input = langName.toLowerCase();
      return name.contains(input);
    }).toList();
    setState(() => languages = suggestions);
  }

  /// keyboard listener => works
  void keyBoardListener(LanguageProvider languageProvider, context) async{
    searchController = TextEditingController();

    await languageProvider.getLanguages();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
          if (!visible) {
            languageProvider.showKeyBoard = false;
            focusNode.unfocus();

          } else {
            languageProvider.showKeyBoard = true;
          }
        });
  }


  void dispose(){
    keyboardSubscription.cancel();
    searchController.dispose();

    _clearSearchList();
  }

}
