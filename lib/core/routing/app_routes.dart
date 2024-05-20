import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_translate_v2/features/history/pages/history_page.dart';
import 'package:g_translate_v2/features/home/pages/home_page.dart';
import 'package:g_translate_v2/features/language_selector/pages/language_selector_page.dart';
import 'package:g_translate_v2/features/saved_translations/pages/saved_translations_page.dart';
import 'package:g_translate_v2/features/translator_page/pages/translator_page.dart';

class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    HomePage.path: (_) => const HomePage(),
    HistoryPage.path: (_) => const HistoryPage(),
    TranslatorPage.path: (_) => const TranslatorPage(),
    LanguageSelectorPage.path: (_) => const LanguageSelectorPage(),
    SavedTranslationsPage.path: (_) => const SavedTranslationsPage(),
  };

  /// page not found (404)
  Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        settings: settings,
        builder: (BuildContext context) => const Scaffold(),
      );
    }

    return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => const Scaffold());
  }
}
