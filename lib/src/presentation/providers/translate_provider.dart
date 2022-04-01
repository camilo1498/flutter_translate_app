import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/core/constants/environment.dart';
import 'package:flutter_translator_app/src/data/models/api_response.dart';
import 'package:flutter_translator_app/src/data/models/translate.dart';

class TranslateProvider extends ChangeNotifier {

  /// Dio instance
  final Dio dio = Dio();


  /// original test
  String _originalText = '';
  String get originalText => _originalText;
  set originalText(String text) {
    _originalText = text;
    notifyListeners();
  }

  /// translation text
  String _translationText = '';
  String get translationText => _translationText;
  set translationText(String text) {
    _translationText = text;
    notifyListeners();
  }

  /// allow close translation page
  bool _closePage = true;
  bool get closePage => _closePage;
  set closePage(bool close) {
    _closePage = close;
    notifyListeners();
  }

  /// is the keyboard open
  bool _showKeyBoard = true;
  bool get showKeyBoard => _showKeyBoard;
  set showKeyBoard(bool show) {
    _showKeyBoard = show;
    notifyListeners();
  }

  /// validate if clipboard has data
  bool _clipBoardHasData = false;
  bool get clipBoardHasData => _clipBoardHasData;
  set clipBoardHasData(bool data) {
    _clipBoardHasData = data;
    notifyListeners();
  }

  /// save fetched data
  Translate? _translate;
  Translate? get translate => _translate;
  set translate(Translate? data) {
    _translate = data;
    notifyListeners();
  }

  /// translate data from api
  Future<Translate> getTranslation({required String from, required String to, required String text}) async{
    try{
      if(text.trim() != ''){
        /// send request to api
        Response response = await dio.get(
            Environment.url,
            queryParameters: <String, dynamic>{
              'from': from.trim(),
              'to': to.trim(),
              'text': text.trim()
            },
            options: Options(
                headers: {
                  'Connection': 'keep-alive',
                  'Content-Type': 'application/json'
                }
            )
        );
        ApiResponse apiResponse = ApiResponse.fromJson(response.data);
        if(apiResponse.success == true){
          _translate = Translate.fromJson(apiResponse.data!.toJson());
          return Translate.fromJson(apiResponse.data!.toJson());
        }
      }
      return Translate();
    } on DioError catch(err){
      ApiResponse apiResponse = ApiResponse.fromJson(err.response!.data);
      debugPrint(apiResponse.message);
      return Translate();
    } finally{
      notifyListeners();
    }
  }

}
