import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/data/models/api_response.dart';
import 'package:flutter_translator_app/src/data/models/translate.dart';

class TranslatePageProvider extends ChangeNotifier {
  /// endpoint
  final String url = 'https://translate-google-api.herokuapp.com/api/translate';

  /// loading
  bool _loading = false;

  /// Dio instance
  final Dio dio = Dio();

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

  bool _showKeyBoard = true;
  bool get showKeyBoard => _showKeyBoard;
  set showKeyBoard(bool show){
    _showKeyBoard = show;
    notifyListeners();
  }

  bool _clipBoardHasData = false;

  bool get clipBoardHasData => _clipBoardHasData;
  set clipBoardHasData (bool data){
    _clipBoardHasData = data;
    notifyListeners();
  }

  Translate? _translate;
  Translate? get translate => _translate;
  set translate(Translate? data){
    _translate = data;
    notifyListeners();
  }

  Future<Translate> getTranslation({required String from, required String to, required String text}) async{
    try{
      _loading = true;
      notifyListeners();
      if(text.trim() != ''){
        Response response = await dio.get(
            url,
            queryParameters: <String, dynamic>{
              'from': from,
              'to': to,
              "text": text
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
          print('========================');
          print(apiResponse.data!.toJson());
          print('========================');
          return Translate.fromJson(apiResponse.data!.toJson());
        } else{
          return Translate();
        }
      }
      return Translate();

    } on DioError catch(err){
      ApiResponse response = ApiResponse.fromJson(err.response!.data);
      print(response.message);
      return Translate();
    } finally{
      _loading = false;
      notifyListeners();
    }
  }

}