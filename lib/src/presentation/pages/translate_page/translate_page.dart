import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_page.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/translate_page_controller.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/widgets/definitions.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/widgets/examples.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/widgets/translations.dart';
import 'package:flutter_translator_app/src/presentation/providers/language_provider.dart';
import 'package:flutter_translator_app/src/presentation/providers/translate_provider.dart';
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
  /// translate controller instance
  late TranslatePageController translateController;

  /// app colors instance
  final AppColors appColors = AppColors();

  /// mediaQuery
  final ScreenUtil screenUtil = ScreenUtil();

  @override
  void initState() {
    translateController = TranslatePageController(context: context);
    translateController.initState();
    super.initState();
  }

  @override
  void dispose() {
    translateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TranslateProvider, LanguageProvider>(
      builder: (_, translateProvider, languageProvider, __) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: WillPopScope(
            onWillPop: () => translateController.willPopScope(),
            child: Scaffold(
              backgroundColor: appColors.backgroundColor,
              appBar: PreferredSize(
                preferredSize: Size(screenUtil.screenWidth, 170.w),
                child: _appBar(
                    context: context,
                    translateProvider: translateProvider,
                    translatePageController: translateController),
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
                            if (translateController
                                .textEditingController.text.isNotEmpty)
                              _currentLanguageToolbar(
                                  color: appColors.colorText1,
                                  language: languageProvider.fromLang.code != 'auto' ? languageProvider.fromLang.name.toString().split(' ')[0] : 'Detect (${languageProvider.detectedLang.name.toString().split(' ')[0]})',
                                  onTapCopy: () =>
                                      translateController.setClipBoardData(translateProvider.originalText, 'Original text copied'),
                                  onTapSpeech: () {}
                              ),

                            /// text field
                            Padding(
                                padding: EdgeInsets.only(left: 60.w, right: 60.w, top: 38.h, bottom: 40.h),
                                child: TextField(
                                  controller: translateController.textEditingController,
                                  focusNode: translateController.focusNode,
                                  autofocus: true,
                                  maxLines: null,
                                  minLines: 1,
                                  textInputAction: TextInputAction.search,
                                  onTap: () => translateProvider.closePage = true,
                                  onChanged: translateController.translateText,
                                  enableSuggestions: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Text',
                                    hintStyle: TextStyle(
                                        color: appColors.colorText1.withOpacity(0.7),
                                        fontSize: 80.sp
                                    ),
                                  ),
                                  style: TextStyle(
                                      color: appColors.colorText1,
                                      fontSize: 60.sp
                                  ),
                                )),

                            /// clipboard button
                            if (translateProvider.clipBoardHasData
                                && translateController.textEditingController.text.isEmpty
                                || translateProvider.originalText.isEmpty)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  65.verticalSpace,
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 80.w),
                                      child: AnimatedOnTapButton(
                                        onTap: translateController.pasteClipBoardData,
                                        child: Container(
                                          width: 280.w,
                                          height: 95.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: appColors.buttonColor2,
                                              borderRadius: BorderRadius.circular(25)
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 10.h),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.paste,
                                                color: appColors.colorText3,
                                                size: 50.w,
                                              ),
                                              15.horizontalSpace,
                                              Text(
                                                'Paste',
                                                style: TextStyle(
                                                    fontSize: 40.sp,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.3,
                                                    color: appColors.colorText3),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                            /// translation data
                            if (translateProvider.originalText.trim().isNotEmpty)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// show detect language
                                  if (translateProvider.translate != null)
                                    if (translateProvider.translate!.sourceLanguage != languageProvider.fromLang.code!.split('-')[0]
                                        && translateProvider.translate!.sourceLanguage != '' && languageProvider.fromLang.code != 'auto')
                                      _correctionContainer(
                                        onTap: translateController.changeToDetectLanguage,
                                        title: 'Translate from',
                                        text: translateController.detectedLanguageName(),
                                      ),
                                  /// show correction text
                                  if (translateProvider.translate != null)
                                    if (!translateProvider.translate!.isCorrect!)
                                      _correctionContainer(
                                        onTap: translateController.textCorrection,
                                        title: 'Did do you mean',
                                        text: translateProvider.translate!.correctionSourceText!,
                                      ),

                                  /// separated line
                                  Container(
                                    height: 5.h,
                                    width: 350.w,
                                    decoration: BoxDecoration(
                                        color: Colors.blue[900],
                                        borderRadius:
                                        BorderRadius.circular(80)),
                                  ),
                                  60.verticalSpace,
                                  _currentLanguageToolbar(
                                      color: Colors.blue[200]!,
                                      language: languageProvider.toLang.name.toString().split(' ')[0],
                                      onTapCopy: () => translateController.setClipBoardData(translateProvider.translationText, 'Translation copied'),
                                      onTapSpeech: () {}),
                                  60.verticalSpace,
                                  /// result translation text
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 40.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 60.w),
                                            child: Text(
                                              translateProvider.translationText,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.blue[200]!,
                                                  fontSize: 60.sp
                                              ),
                                            ),
                                          ),
                                          20.verticalSpace,

                                          /// pronunciation container
                                          if (translateProvider.translate != null)
                                            if (translateProvider.translate!.source!.pronunciation!.isNotEmpty)
                                              Padding(padding: EdgeInsets.symmetric(horizontal: 60.w),
                                                child: _pronunciation(
                                                    translatePageProvider: translateProvider,
                                                    textColor: Colors.blue[200]!
                                                ),
                                              ),
                                          100.verticalSpace,

                                          /// other translations
                                          if (translateProvider.translate != null)
                                            if (translateProvider.translate!.translations != null
                                                && translateProvider.translate!.translations!.isNotEmpty
                                                && translateProvider.translate!.isCorrect == true
                                                && translateProvider.translate!.sourceLanguage != '')
                                              Translations(
                                                  translateProvider: translateProvider
                                              ),
                                          30.verticalSpace,

                                          /// main definitions container
                                          if (translateProvider.translate != null)
                                            if (translateProvider.translate!.source!.definitions != null
                                                && translateProvider.translate!.source!.definitions!.isNotEmpty
                                                && translateProvider.translate!.isCorrect == true
                                                && translateProvider.translate!.sourceLanguage != '')
                                              Definitions(
                                                  translateProvider: translateProvider,
                                              ),
                                          30.verticalSpace,

                                          /// example container
                                          if (translateProvider.translate != null)
                                            if (translateProvider.translate!.source!.examples != null
                                                && translateProvider.translate!.source!.examples!.isNotEmpty
                                                && translateProvider.translate!.isCorrect == true
                                                && translateProvider.translate!.sourceLanguage != '')
                                              Examples(
                                                  translateProvider: translateProvider
                                              )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                    25.verticalSpace,

                    /// change language buttons
                    if (translateProvider.showKeyBoard)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LanguageButton(
                                text: languageProvider.fromLang.name.toString().split(' ')[0],
                                appColors: appColors,
                                onTap: () => translateController.goToSelectLanguage(SelectLanguageType.from)
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: AnimatedOnTapButton(
                                onTap: translateController.changeLanguageOrder,
                                child: SizedBox(
                                  width: 100.w,
                                  height: 100.w,
                                  child: Icon(
                                    Icons.compare_arrows,
                                    color: appColors.iconColor2,
                                    size: 70.w,
                                  ),
                                ),
                              ),
                            ),
                            LanguageButton(
                                text: languageProvider.toLang.name.toString().split(' ')[0],
                                appColors: appColors,
                                onTap: () => translateController.goToSelectLanguage(SelectLanguageType.to)
                            ),
                          ],
                        ),
                      ),
                    25.verticalSpace
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// appBar
  _appBar({
    required TranslatePageController translatePageController,
    required BuildContext context,
    required TranslateProvider translateProvider}) {
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
            onTap: translateController.closePage,
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
              onTap: translatePageController.goToHistoryPage,
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

  Widget _currentLanguageToolbar(
      {required String language,
        required Function() onTapCopy,
        required Function() onTapSpeech,
        required Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        30.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language,
                textAlign: TextAlign.left,
                style: TextStyle(color: color, fontSize: 50.sp),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedOnTapButton(
                    onTap: onTapCopy,
                    child: Icon(
                      Icons.copy,
                      color: color,
                      size: 65.w,
                    ),
                  ),
                  60.horizontalSpace,
                  AnimatedOnTapButton(
                    onTap: onTapSpeech,
                    child: Icon(
                      Icons.volume_up_outlined,
                      color: color,
                      size: 65.w,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _correctionContainer({
    required String title,
    required String text,
    required Function() onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 50.w, left: 50.w, bottom: 60.h),
      child: AnimatedOnTapButton(
        onTap: onTap,
        child: Container(
          width: screenUtil.screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
          decoration: BoxDecoration(
              color: appColors.containerColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    blurStyle: BlurStyle.inner,
                    offset: const Offset(0, 1.5))
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: appColors.colorText2,
                          fontSize: 43.sp,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      text,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.blue[200]!,
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: Icon(
                  Icons.arrow_forward,
                  color: appColors.iconColor2,
                  size: 70.w,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _pronunciation({
    required TranslateProvider translatePageProvider,
    required Color textColor}) {
    return SizedBox(
      width: screenUtil.screenWidth,
      height: 60.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          translatePageProvider.translate!.source!.pronunciation![0],
          style: TextStyle(
              color: textColor,
              fontSize: 40.sp,
              wordSpacing: 0.1,
              letterSpacing: 0.5),
        ),
      ),
    );
  }
}