import 'package:flutter/cupertino.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_page.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/translate_page.dart';
import 'package:flutter_translator_app/src/presentation/providers/select_language_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/axis_page_transition.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/fade_page_route.dart';

import '../../widgets/animations/panel.dart';

class HomePageController {
  /// panel controller
  PanelController panelController = PanelController();

  /// listview controller
  ScrollController listController = ScrollController();

  /// app color instance
  final AppColors appColors = AppColors();

  /// opacity
  final double blockedOpacity = 1.0;

  /// go to translation page
  void goToTranslationPage({required BuildContext context}) {
    Navigator.push(
        context,
        FadePageRoute(
          builder: (context) => const TranslatePage(),
        ));
  }

  /// go to translation page
  void goToSelectLanguage(
      {required BuildContext context,
      required SelectLanguageType languageType}) {
    Navigator.of(context).push(AxisPageTransition(
        child: SelectLanguagePage(
            selectLanguagePage: languageType, onChange: () {}),
        direction: AxisDirection.left));
  }

  /// change select language order
  void changeLanguageOrder({required SelectLanguageProvider languageProvider}) {
    if(languageProvider.fromLang.code! != 'auto'){
      var _from = languageProvider.fromLang;
      var _to = languageProvider.toLang;
      languageProvider.fromLang = _to;
      languageProvider.toLang = _from;
    }

  }

  /// panel functions
  openPanel() async {
    await panelController.open();
  }

  Future closePanel() async {
    await panelController.close();
  }
}
