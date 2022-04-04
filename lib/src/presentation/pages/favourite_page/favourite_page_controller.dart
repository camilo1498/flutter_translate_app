import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/data/models/History.dart';

import 'package:flutter_translator_app/src/data/models/favourite.dart';
import 'package:flutter_translator_app/src/data/sources/local_db/translator_batabase.dart';
import 'package:flutter_translator_app/src/presentation/providers/database_provider.dart';
import 'package:provider/provider.dart';

class FavouritePageController {

  /// context
  final BuildContext context;

  /// providers
  late DatabaseProvider databaseProvider;
  FavouritePageController({
    required this.context
  }) {
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  }

  Future getFavourites() async {
    databaseProvider.favouriteList = await TranslateDataBase.instance.readFavourite();
  }

  Future deleteFavourite(Favourite favourite) async {
    bool existHistory = await TranslateDataBase.instance.getSingleHistory(favourite.historyId!);
    print(existHistory);
    if(existHistory) {
      print('update');
      /// delete favourite and update history element
      final _update = History(
          id: favourite.historyId,
          translationText: favourite.translationText,
          originalTextCode: favourite.originalTextCode,
          originalText: favourite.originalText,
          translationTextCode: favourite.translationTextCode,
          timestamp: favourite.timestamp,
          isFavorite: 'false'
      );
      await TranslateDataBase.instance.deleteFavouriteField(favourite.id).then((res) async {
        await TranslateDataBase.instance.updateHistory(_update).then((value) async{
          databaseProvider.historyList = await TranslateDataBase.instance.readHistory();
          databaseProvider.favouriteList = await TranslateDataBase.instance.readFavourite();
        });
      });

    } else{
      print('delete');
      /// only delete favourite
      await TranslateDataBase.instance.deleteFavouriteFieldHistoryId(favourite.historyId).then((res) async {
        databaseProvider.favouriteList = await TranslateDataBase.instance.readFavourite();
      });
    }
  }

}