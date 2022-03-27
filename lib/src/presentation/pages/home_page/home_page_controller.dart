
import 'package:flutter/cupertino.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/translate_page.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/fade_page_route.dart';

import '../../widgets/animations/panel.dart';

class HomePageController{
  /// panel controller
  PanelController panelController = PanelController();
  /// listview controller
  ScrollController listController = ScrollController();
  /// app color instance
  final AppColors appColors = AppColors();
  /// opacity
  final double blockedOpacity = 1.0;


  /// go to translation page
  void goToTranslationPage({required BuildContext context}){
    Navigator.push(context, FadePageRoute(
      builder: (context) => const TranslatePage(),
    ));
  }
  /// panel functions
  openPanel() async{
    await panelController.open();
  }
  Future closePanel() async{
    await panelController.close();
  }

}