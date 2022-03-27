import 'package:flutter/material.dart';

class TranslatePageProvider extends ChangeNotifier {

  String _originalText = '';
  String get originalText => _originalText;
  set originalText(String text){
    _originalText = text;
    notifyListeners();
  }

  String _translatedText = '';
  String get translatedText => _translatedText;
  set translatedText(String text){
    _translatedText = text;
    notifyListeners();
  }



}