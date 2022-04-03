import 'package:flutter/cupertino.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/data/models/History.dart';
import 'package:flutter_translator_app/src/data/sources/local_db/translator_batabase.dart';
import 'package:flutter_translator_app/src/presentation/providers/history_provider.dart';
import 'package:provider/provider.dart';

class HistoryPageController {
  /// context
  final BuildContext context;
  /// providers
  late HistoryProvider historyProvider;
  HistoryPageController({
    required this.context
}){
    historyProvider = Provider.of<HistoryProvider>(context, listen: false);
  }
  /// app color instance
  final AppColors appColors = AppColors();

  /// to parse int to respective month
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Future getHistory() async{
    historyProvider.historyList = await TranslateDataBase.instance.readHistory();
  }

  Future deleteAllHistory() async{
    await TranslateDataBase.instance.deleteAllHistory().then((_) async{
      if(historyProvider.historyList.isNotEmpty){
        historyProvider.historyList = await TranslateDataBase.instance.readHistory();
      }
    });
  }

  Future deleteHistoryItem(int? id) async{
    await TranslateDataBase.instance.deleteHistoryField(id!).then((res) async{
      historyProvider.historyList = await TranslateDataBase.instance.readHistory();
    });
  }

  Future updateHistoryItem(History history) async {
    final _update = History(
      id: history.id,
      translationText: history.translationText,
      originalTextCode: history.originalTextCode,
      originalText: history.originalText,
      translationTextCode: history.translationTextCode,
      timestamp: history.timestamp,
      isFavorite: history.isFavorite == 'true' ? 'false' : 'true'
    );
    await TranslateDataBase.instance.updateHistory(_update).then((_) async{
      historyProvider.historyList = await TranslateDataBase.instance.readHistory();
    });
  }
}