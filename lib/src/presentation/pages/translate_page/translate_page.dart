import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/core/constants/languages.dart';
import 'package:flutter_translator_app/src/data/models/language.dart';
import 'package:flutter_translator_app/src/data/models/synonym.dart';
import 'package:flutter_translator_app/src/data/models/translate.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_page.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/translate_page_controller.dart';
import 'package:flutter_translator_app/src/presentation/providers/select_language_provider.dart';
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
  final TranslatePageController translateController = TranslatePageController();

  /// app colors instance
  final AppColors appColors = AppColors();

  /// mediaQuery
  final ScreenUtil screenUtil = ScreenUtil();

  @override
  void initState() {
    translateController
        .initState(Provider.of<TranslateProvider>(context, listen: false), context);
    super.initState();
  }

  @override
  void dispose() {
    translateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TranslateProvider, SelectLanguageProvider>(
      builder: (_, translateProvider, languageProvider, __) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: WillPopScope(
            onWillPop: () => translateController.willPopScope(translateProvider),
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
                                  language: languageProvider.fromLang.name.toString().split(' ')[0],
                                  onTapCopy: () =>
                                      translateController.setClipBoardData(translateProvider.originalText, 'Original text copied'),
                                  onTapSpeech: () {}),

                            /// text field
                            Padding(
                                padding: EdgeInsets.only(left: 60.w, right: 60.w, top: 38.h, bottom: 40.h),
                                child: TextField(
                                  controller: translateController.textEditingController,
                                  focusNode: translateController.focusNode,
                                  autofocus: true,
                                  maxLines: null,
                                  minLines: 1,
                                  onTap: () => translateProvider.closePage = true,
                                  onChanged: (text) => translateController.translateText(text, translateProvider, languageProvider),
                                  enableSuggestions: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Text',
                                    hintStyle: TextStyle(
                                        color: appColors.colorText1.withOpacity(0.7),
                                        fontSize: 80.sp),
                                  ),
                                  style: TextStyle(
                                      color: appColors.colorText1,
                                      fontSize: 60.sp),
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
                                        onTap: () => translateController
                                            .pasteClipBoardData(translateProvider),
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
                                        && translateProvider.translate!.sourceLanguage != '')
                                      _correctionContainer(
                                        onTap: () => translateController
                                            .changeToDetectLanguage(languageProvider,translateProvider),
                                        title: 'Translate from',
                                        text: translateController.detectedLanguageName(translateProvider),
                                      ),
                                  /// show correction text
                                  if (translateProvider.translate != null)
                                    if (!translateProvider.translate!.isCorrect!)
                                      _correctionContainer(
                                        onTap: () => translateController.textCorrection(languageProvider, translateProvider),
                                        title: 'Did do you mean',
                                        text: translateProvider.translate!.text!,
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
                                  _currentLanguageToolbar(
                                      color: Colors.blue[200]!,
                                      language: languageProvider.toLang.name.toString().split(' ')[0],
                                      onTapCopy: () => translateController.setClipBoardData(translateProvider.translationText, 'Translation copied'),
                                      onTapSpeech: () {}),

                                  /// result translation text
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 40.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 60.w),
                                            child: Text(
                                              translateProvider
                                                  .translationText,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.blue[200]!,
                                                  fontSize: 60.sp),
                                            ),
                                          ),
                                          20.verticalSpace,

                                          /// pronunciation container
                                          if (translateProvider.translate !=
                                              null)
                                            if (translateProvider
                                                .translate!
                                                .source!
                                                .pronunciation!
                                                .isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 60.w),
                                                child: _pronunciation(
                                                    translatePageProvider:
                                                        translateProvider,
                                                    textColor:
                                                        Colors.blue[200]!),
                                              ),
                                          100.verticalSpace,

                                          /// other translations
                                          if (translateProvider.translate !=
                                              null)
                                            if (translateProvider.translate!
                                                        .translations !=
                                                    null &&
                                                translateProvider.translate!
                                                    .translations!.isNotEmpty &&
                                                translateProvider
                                                        .translate!.isCorrect ==
                                                    true &&
                                                translateProvider.translate!
                                                        .sourceLanguage ==
                                                    languageProvider
                                                        .fromLang.code!
                                                        .split('-')[0] &&
                                                translateProvider.translate!
                                                        .sourceLanguage !=
                                                    '')
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 30.w,
                                                      vertical: 40.h),
                                                  width: screenUtil.screenWidth,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        width: 3.w,
                                                        color:
                                                            Colors.blue[900]!,
                                                      )),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      /// translations
                                                      Text(
                                                        'Other translations of "${translateProvider.originalText}"',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: appColors.colorText1,
                                                            fontSize: 50.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      30.verticalSpace,
                                                      ...translateProvider
                                                          .translate!
                                                          .translations!
                                                          .map(
                                                              (otherTranslation) {
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      40.h),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              /// adjective, adverb, noun title
                                                              Text(
                                                                otherTranslation
                                                                    .type
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .lightBlueAccent[
                                                                        100],
                                                                    fontSize:
                                                                        38.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              10.verticalSpace,
                                                              if (otherTranslation
                                                                      .translations !=
                                                                  null)
                                                                ...otherTranslation
                                                                    .translations!
                                                                    .map(
                                                                        (translationsList) {
                                                                  return Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            30.h),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        /// title
                                                                        SizedBox(
                                                                          width:
                                                                              (screenUtil.screenWidth / 2) - 90.w,
                                                                          child:
                                                                              RichText(
                                                                            text:
                                                                                TextSpan(style: TextStyle(color: appColors.colorText2, fontSize: 40.sp, fontWeight: FontWeight.w600), children: [
                                                                              if (translationsList.article != null)
                                                                                TextSpan(text: '${translationsList.article.toString()} '),
                                                                              TextSpan(text: translationsList.word.toString())
                                                                            ]),
                                                                          ),
                                                                        ),
                                                                        if (translationsList.translations !=
                                                                            null)

                                                                          /// other translations sub list
                                                                          SizedBox(
                                                                            width:
                                                                                (screenUtil.screenWidth / 2) - 90.w,
                                                                            child:
                                                                                Wrap(
                                                                              children: [
                                                                                ...translationsList.translations!.map((subTranslationList) {
                                                                                  return Padding(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                                                                                    child: Text(subTranslationList != translationsList.translations!.last ? '$subTranslationList,' : subTranslationList, style: TextStyle(color: appColors.colorText2, fontSize: 35.sp, fontWeight: FontWeight.w400)),
                                                                                  );
                                                                                })
                                                                              ],
                                                                            ),
                                                                          )
                                                                      ],
                                                                    ),
                                                                  );
                                                                })
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          30.verticalSpace,
                                          if (translateProvider.translate !=
                                              null)
                                            if (translateProvider.translate!
                                                        .source!.definitions !=
                                                    null &&
                                                translateProvider
                                                    .translate!
                                                    .source!
                                                    .definitions!
                                                    .isNotEmpty &&
                                                translateProvider
                                                        .translate!.isCorrect ==
                                                    true &&
                                                translateProvider.translate!
                                                        .sourceLanguage ==
                                                    languageProvider
                                                        .fromLang.code!
                                                        .split('-')[0] &&
                                                translateProvider.translate!
                                                        .sourceLanguage !=
                                                    '')

                                              /// main definitions container
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 30.w,
                                                      vertical: 40.h),
                                                  width: screenUtil.screenWidth,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          width: 3.w,
                                                          color: Colors
                                                              .blue[900]!)),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Definitions',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: appColors .colorText1,
                                                            fontSize: 50.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      ...translateProvider
                                                          .translate!
                                                          .source!
                                                          .definitions!
                                                          .map((definitions) {
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      40.h),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              /// adjective, noun, adverb title
                                                              Text(
                                                                definitions
                                                                    .type!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .lightBlueAccent[
                                                                        100],
                                                                    fontSize:
                                                                        38.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              10.verticalSpace,
                                                              if (definitions
                                                                      .definitions !=
                                                                  null)
                                                                ...definitions
                                                                    .definitions!
                                                                    .map(
                                                                        (subDef) {
                                                                  /// card body
                                                                  return Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            30.h),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        /// counter widget
                                                                        Container(
                                                                          width:
                                                                              60.w,
                                                                          height:
                                                                              60.w,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue[900]!,
                                                                              shape: BoxShape.circle),
                                                                          child:
                                                                              Text(
                                                                            (definitions.definitions!.indexOf(subDef) + 1).toString(),
                                                                            style: TextStyle(
                                                                                color: appColors.colorText1,
                                                                                fontSize: 25.sp,
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ),
                                                                        30.horizontalSpace,

                                                                        /// definition
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              /// title widget
                                                                              Text(
                                                                                subDef.definition!,
                                                                                style: TextStyle(color: appColors.colorText2, fontSize: 38.sp, fontWeight: FontWeight.w600),
                                                                              ),
                                                                              15.verticalSpace,

                                                                              /// subtitle widget
                                                                              Text(
                                                                                subDef.example != null ? '"${subDef.example!}"' : '',
                                                                                style: TextStyle(color: appColors.colorText2, fontSize: 37.sp, fontWeight: FontWeight.w500),
                                                                              ),
                                                                              40.verticalSpace,
                                                                              if (translateProvider.translate!.source!.synonyms != null)

                                                                                /// synonym widget
                                                                                ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: translateProvider.translate!.source!.synonyms!.length,
                                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                                  itemBuilder: (context, synIndex) {
                                                                                    List<Synonym> listSynonym = [];
                                                                                    if (translateProvider.translate!.source!.synonyms![synIndex].isNotEmpty) {
                                                                                      for (int i = 0; i < translateProvider.translate!.source!.synonyms![synIndex].length; i++) {
                                                                                        listSynonym.add(Synonym(id: translateProvider.translate!.source!.synonyms![synIndex][i].id, words: translateProvider.translate!.source!.synonyms![synIndex][i].words));
                                                                                      }
                                                                                      return ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        itemCount: translateProvider.translate!.source!.synonyms![synIndex].length,
                                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                                        itemBuilder: (context, subSymIndex) {
                                                                                          if (translateProvider.translate!.source!.synonyms![synIndex][subSymIndex].id == subDef.id) {
                                                                                            return Wrap(
                                                                                              children: [
                                                                                                ...translateProvider.translate!.source!.synonyms![synIndex][subSymIndex].words!.map((item) {
                                                                                                  return Padding(
                                                                                                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                                                                                                    child: Container(
                                                                                                      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 35.w),
                                                                                                      decoration: BoxDecoration(
                                                                                                          border: Border.all(
                                                                                                            color: appColors.iconColor2,
                                                                                                          ),
                                                                                                          borderRadius: BorderRadius.circular(20)),
                                                                                                      child: Text(
                                                                                                        item,
                                                                                                        style: TextStyle(color: Colors.lightBlueAccent[100], fontSize: 34.sp, fontWeight: FontWeight.w600),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                })
                                                                                              ],
                                                                                            );
                                                                                          } else {
                                                                                            return Container();
                                                                                          }
                                                                                        },
                                                                                      );
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                })
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
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
                                onTap: () {
                                  translateProvider.closePage = false;
                                  /// select translate "from"
                                  translateController.goToSelectLanguage(context, SelectLanguageType.from, languageProvider, translateProvider);
                                }),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: AnimatedOnTapButton(
                                onTap: () =>
                                    translateController.changeLanguageOrder(languageProvider, translateProvider),
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
                                onTap: () {
                                  translateProvider.closePage = false;
                                  /// select translate "to"
                                  translateController.goToSelectLanguage(context, SelectLanguageType.to, languageProvider, translateProvider);

                                }),
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
            onTap: () => translateController.closePage(context, translateProvider),
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
                  translateProvider.closePage = false;
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
          height: 160.h,
          width: screenUtil.screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 40.w),
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
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: appColors.colorText2,
                        fontSize: 40.sp),
                  ),
                  5.verticalSpace,
                  Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.blue[200]!,
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.blue[200]!,
                  size: 70.w,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _pronunciation(
      {required TranslateProvider translatePageProvider,
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
