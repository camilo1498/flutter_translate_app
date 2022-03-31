import 'package:flutter_translator_app/src/core/constants/app_colors.dart';

class HistoryPageController {
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

  /// schema history model
  List elements = [
    {
      'date': '2019-07-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': true
    },
    {
      'date': '2019-09-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': false
    },
    {
      'date': '2019-09-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': false
    },
    {
      'date': '2019-09-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': false
    },
    {
      'date': '2020-01-14 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': false
    },
    {
      'date': '2021-02-115 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': true
    },
    {
      'date': '2021-07-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': true
    },
    {
      'date': '2021-08-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': false
    },
    {
      'date': '2021-08-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': false
    },
    {
      'date': '2022-02-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': false
    },
    {
      'date': '2022-02-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': true
    },
    {
      'date': '2022-02-19 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': false
    },
    {
      'date': '2022-02-20 8:40:23',
      'originalText': 'example',
      'translatedText': 'ejemplo',
      'isFavorite': true
    },
  ];
}
