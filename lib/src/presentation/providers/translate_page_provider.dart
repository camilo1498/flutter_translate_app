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

  bool _closePage = true;
  bool get closePage => _closePage;
  set closePage(bool close){
    _closePage = close;
    notifyListeners();
  }

  bool _clipBoardHasData = false;

  bool get clipBoardHasData => _clipBoardHasData;
  set clipBoardHasData (bool data){
    _clipBoardHasData = data;
    notifyListeners();
  }
}