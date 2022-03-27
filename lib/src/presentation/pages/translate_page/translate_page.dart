import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_page.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/translate_page_controller.dart';
import 'package:flutter_translator_app/src/presentation/providers/select_language_provider.dart';
import 'package:flutter_translator_app/src/presentation/providers/translate_page_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:flutter_translator_app/src/presentation/widgets/language_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key}) : super(key: key);

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  late StreamSubscription<bool> keyboardSubscription;
  final TranslatePageController translatePageController = TranslatePageController();

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      if(!visible){
        translatePageController.focusNode.unfocus();
        if(
        translatePageController.textEditingController.text.isEmpty
         && Provider.of<TranslatePageProvider>(context, listen: false).closePage){
          Navigator.pop(context);
        }
      } else{
        Provider.of<TranslatePageProvider>(context, listen: false).closePage = true;
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    /// mediaQuery
    final ScreenUtil screenUtil = ScreenUtil();
    return Consumer2<TranslatePageProvider, SelectLanguageProvider>(
      builder: (_, translatePageProvider, languageProvider, __){
        return WillPopScope(
          onWillPop: () async{
            setState(() {
              translatePageProvider.closePage = true;
              translatePageProvider.translatedText = '';
              translatePageProvider.originalText = '';
            });
            return true;
          },
          child: Scaffold(
            backgroundColor: translatePageController.appColors.backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size(screenUtil.screenWidth, 170.w),
              child: _appBar(
                  context: context,
                  translatePageProvider: translatePageProvider,
                  appColors: translatePageController.appColors,
                  translatePageController: translatePageController
              ),
            ),
            body: SizedBox(
              height: screenUtil.screenHeight,
              width: screenUtil.screenWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 60.w, right: 60.w, top: 38.h, bottom: 40.h),
                              child: TextField(
                                controller: translatePageController.textEditingController,
                                focusNode: translatePageController.focusNode,
                                autofocus: true,
                                maxLines: null,
                                minLines: 1,
                                onTap: (){
                                  setState(() {
                                    translatePageProvider.closePage = true;
                                  });
                                },
                                onChanged: (text){
                                  setState((){
                                    translatePageProvider.originalText = text;
                                  });
                                },
                                enableSuggestions: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Text',
                                  hintStyle: TextStyle(
                                      color: translatePageController.appColors.colorText1.withOpacity(0.7),
                                      fontSize: 80.sp
                                  ),
                                ),
                                style: TextStyle(
                                    color: translatePageController.appColors.colorText1,
                                    fontSize: 80.sp
                                ),
                              )
                          ),
                          if(translatePageProvider.originalText.trim().isNotEmpty)
                            Container(
                              height: 5.h,
                              width: 350.w,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(80)
                              ),
                            ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 60.w, right: 60.w, top: 38.h, bottom: 40.h),
                              child: Text(
                                translatePageProvider.originalText,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: translatePageController.appColors.colorText3,
                                    fontSize: 80.sp
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  25.verticalSpace,
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LanguageButton(
                            text: languageProvider.fromLang.name.toString().split(' ')[0],
                            appColors: translatePageController.appColors,
                            onTap: (){
                              translatePageProvider.closePage = false;
                              /// select translate "from"
                              translatePageController.goToSelectLanguage(
                                  context: context,
                                  languageType: SelectLanguageType.from
                              );
                            }
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: AnimatedOnTapButton(
                            onTap: () => translatePageController.changeLanguageOrder(selectLanguage: languageProvider),
                            child: SizedBox(
                              width: 100.w,
                              height: 100.w,
                              child: Icon(
                                Icons.compare_arrows,
                                color: translatePageController.appColors.iconColor2,
                                size: 70.w,
                              ),
                            ),
                          ),
                        ),
                        LanguageButton(
                            text: languageProvider.toLang.name.toString().split(' ')[0],
                            appColors: translatePageController.appColors,
                            onTap: (){
                              translatePageProvider.closePage = false;
                              /// select translate "to"
                              translatePageController.goToSelectLanguage(
                                  context: context,
                                  languageType: SelectLanguageType.to
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                  25.verticalSpace
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// appBar
  _appBar({
    required AppColors appColors,
    required TranslatePageController translatePageController,
    required BuildContext context,
    required TranslatePageProvider translatePageProvider
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      color: appColors.backgroundColor,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: AnimatedOnTapButton(
            onTap: () {
              if(translatePageProvider.closePage){
                translatePageController.closePage(context: context);
              } else{
                Navigator.pop(context);
              }
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 70.w,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 45.w),
            child: AnimatedOnTapButton(
              onTap: () {
                setState(() {
                  translatePageProvider.closePage = false;
                  translatePageController.goToHistoryPage(context: context);
                });
              },
              child: Icon(
                Icons.history,
                color: Colors.white,
                size: 70.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
