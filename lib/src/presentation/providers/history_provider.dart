import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/data/models/History.dart';

class HistoryProvider extends ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool loading){
    _isLoading = loading;
    notifyListeners();
  }

  List<History> _historyList = [];
  List<History> get historyList => _historyList;
  set historyList(List<History> history){
    _historyList = history;
    notifyListeners();
  }

}