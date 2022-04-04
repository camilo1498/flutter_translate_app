import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/data/models/History.dart';
import 'package:flutter_translator_app/src/data/models/favourite.dart';

class DatabaseProvider extends ChangeNotifier {

  List<History> _historyList = [];
  List<History> get historyList => _historyList;
  set historyList(List<History> history){
    _historyList = history;
    notifyListeners();
  }

  List<Favourite> _favouriteList = [];
  List<Favourite> get favouriteList => _favouriteList;
  set favouriteList(List<Favourite> favourite){
    _favouriteList= favourite;
    notifyListeners();
  }


}