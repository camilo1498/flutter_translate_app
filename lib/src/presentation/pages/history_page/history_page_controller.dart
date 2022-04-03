import 'package:flutter/cupertino.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/data/sources/local_db/translator_batabase.dart';
import 'package:flutter_translator_app/src/presentation/pages/home_page/home_page_controller.dart';
import 'package:flutter_translator_app/src/presentation/providers/history_provider.dart';
import 'package:provider/provider.dart';

class HistoryPageController {
  /// context
  final BuildContext context;
  /// providers
  late HistoryProvider _historyProvider;
  HistoryPageController({
    required this.context
}){
    _historyProvider = Provider.of<HistoryProvider>(context, listen: false);
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
    _historyProvider.historyList = await TranslateDataBase.instance.readHistory();
  }

  Future deleteAllHistory() async{
    await TranslateDataBase.instance.deleteAllHistory().then((_) async{
      _historyProvider.historyList = await TranslateDataBase.instance.readHistory();

    });
  }

  Future deleteHistoryItem(int? id) async{
    await TranslateDataBase.instance.deleteHistoryField(id!).then((res) async{
      _historyProvider.historyList = await TranslateDataBase.instance.readHistory();
    });
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
          (Map<K, List<E>> map, E element) =>
      map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
