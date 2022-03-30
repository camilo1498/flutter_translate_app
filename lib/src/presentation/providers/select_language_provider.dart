import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/core/constants/languages.dart';
import 'package:flutter_translator_app/src/data/models/language.dart';

class SelectLanguageProvider extends ChangeNotifier {
  /// parse language list to language model object
  Future<List<Language>> getLanguages() async{

    List<Language> _languages = [];

    for(var l in LanguagesList().languageList){
      _languages.add(Language.fromJson(l));
    }
    return _languages;
  }


  Language _fromLang = Language(name: 'Spanish (Mexico)', code: 'es-MX');
  Language get fromLang => _fromLang;
  set fromLang(Language lang){
    _fromLang = lang;
    notifyListeners();
  }

  Language _toLang = Language(name: 'English (United States)', code: 'en-US');
  Language get toLang => _toLang;
  set toLang(Language lang){
    _toLang = lang;
    notifyListeners();
  }

  Language _detectedLang = Language();
  Language get detectedLang => _detectedLang;
  set detectedLang(Language lang){
    _detectedLang= lang;
    notifyListeners();
  }
}