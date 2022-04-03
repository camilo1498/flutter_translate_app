import 'package:flutter/cupertino.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_page.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/translate_page.dart';
import 'package:flutter_translator_app/src/presentation/providers/language_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/axis_page_transition.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/page_transitions/fade_page_route.dart';
import 'package:provider/provider.dart';

import '../../widgets/animations/panel.dart';

class HomePageController {
  /// build context
  final BuildContext context;
  /// providers
  late LanguageProvider _languageProvider;

  HomePageController({
    required this.context
  }){
    _languageProvider = Provider.of<LanguageProvider>(context, listen: false);
  }
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
  void goToSelectLanguage(languageType) {
    Navigator.of(context).push(AxisPageTransition(
        child: SelectLanguagePage(
            selectLanguagePage: languageType, onChange: () {}),
        direction: AxisDirection.left));
  }

  /// change select language order
  void changeLanguageOrder() {
    if(_languageProvider.fromLang.code! != 'auto'){
      var _from = _languageProvider.fromLang;
      var _to = _languageProvider.toLang;
      _languageProvider.fromLang = _to;
      _languageProvider.toLang = _from;
    }

  }

  Future<bool> willPopScope() async{
    if(panelController.isPanelOpen){
      closePanel();
      return false;
    } else{
      return true;
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
