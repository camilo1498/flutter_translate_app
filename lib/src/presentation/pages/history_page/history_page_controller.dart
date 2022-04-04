import 'package:flutter/cupertino.dart';
import 'package:flutter_translator_app/src/data/models/History.dart';
import 'package:flutter_translator_app/src/data/models/favourite.dart';
import 'package:flutter_translator_app/src/data/sources/local_db/translator_batabase.dart';
import 'package:flutter_translator_app/src/presentation/providers/database_provider.dart';
import 'package:provider/provider.dart';

class HistoryPageController {
  /// context
  final BuildContext context;
  /// providers
  late DatabaseProvider databaseProvider;
  HistoryPageController({
    required this.context
}){
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  }


  Future getHistory() async{
    databaseProvider.historyList = await TranslateDataBase.instance.readHistory();
  }

  Future deleteAllHistory() async{
    await TranslateDataBase.instance.deleteAllHistory().then((_) async{
      if(databaseProvider.historyList.isNotEmpty){
        databaseProvider.historyList = await TranslateDataBase.instance.readHistory();
      }
    });
  }

  Future deleteHistoryItem(int? id) async{
    await TranslateDataBase.instance.deleteHistoryField(id!).then((res) async{
      databaseProvider.historyList = await TranslateDataBase.instance.readHistory();
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
      if(_update.isFavorite == 'false'){
        /// delete favourite
        await TranslateDataBase.instance.deleteFavouriteFieldHistoryId(_update.id).then((res) async{
          databaseProvider.historyList = await TranslateDataBase.instance.readHistory();
          databaseProvider.favouriteList = await TranslateDataBase.instance.readFavourite();
        });
      } else{
        /// insert favourite
        Favourite favourite = Favourite(
          timestamp: DateTime.now().millisecondsSinceEpoch,
          historyId: _update.id,
          translationTextCode: _update.translationTextCode,
          originalText: _update.originalText,
          originalTextCode: _update.originalTextCode,
          translationText: _update.translationText,
          isFavorite: 'true'
        );
        await TranslateDataBase.instance.insertFavourite(favourite).then((element) async{
          databaseProvider.favouriteList.add(element);
          databaseProvider.favouriteList = await TranslateDataBase.instance.readFavourite();
        });
        databaseProvider.historyList = await TranslateDataBase.instance.readHistory();
      }

    });
  }
}