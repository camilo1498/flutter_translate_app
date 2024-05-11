// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/data/models/language.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_controller.dart';
import 'package:flutter_translator_app/src/presentation/providers/language_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:provider/provider.dart';

enum SelectLanguageType { from, to }

class SelectLanguagePage extends StatefulWidget {
  SelectLanguageType selectLanguagePage = SelectLanguageType.from;
  Function() onChange;
  SelectLanguagePage(
      {super.key, required this.selectLanguagePage, required this.onChange});

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  /// language controller
  final SelectLanguageController languageController =
      SelectLanguageController();

  /// screen util instance
  final ScreenUtil screenUtil = ScreenUtil();

  /// app color instance
  final AppColors appColors = AppColors();

  @override
  void initState() {
    languageController.keyBoardListener(
        Provider.of<LanguageProvider>(context, listen: false), context);
    languageController.languages =
        Provider.of<LanguageProvider>(context, listen: false).languagesList;
    super.initState();
  }

  @override
  void dispose() {
    languageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: Consumer<LanguageProvider>(
        builder: (_, languageProvider, __) {
          return Scaffold(
            backgroundColor: appColors.backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size(screenUtil.screenWidth, 170.w),
              child: _appBar(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  languageProvider: languageProvider),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    30.verticalSpace,
                    if (widget.selectLanguagePage == SelectLanguageType.from &&
                        languageProvider.fromLang.code! != 'auto')
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                        onTap: () {
                          languageProvider.fromLang =
                              Language(code: 'auto', name: 'Detect language');
                          Navigator.pop(context);
                        },
                        title: Text(
                          'Detect language',
                          style: TextStyle(
                              color: appColors.colorText1, fontSize: 45.sp),
                        ),
                        trailing: Icon(
                          Icons.auto_awesome,
                          size: 50.w,
                          color: appColors.iconColor1,
                        ),
                      ),
                    30.verticalSpace,
                    Text(
                      'Selected language',
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 40.sp),
                    ),
                    30.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                          title: Text(
                            widget.selectLanguagePage == SelectLanguageType.from
                                ? languageProvider.fromLang.name.toString()
                                : languageProvider.toLang.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: appColors.colorText1),
                          ),
                          trailing: Icon(
                            Icons.check,
                            size: 50.w,
                            color: appColors.iconColor1,
                          ),
                        ),
                      ),
                    ),
                    30.verticalSpace,
                    Text(
                      'All languages',
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 40.sp),
                    ),
                    30.verticalSpace,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: languageController.languages.length,
                      itemBuilder: (context, index) {
                        if (widget.selectLanguagePage ==
                                SelectLanguageType.from &&
                            languageProvider.fromLang.code ==
                                languageController.languages[index].code) {
                          return const SizedBox(
                            width: 0,
                            height: 0,
                          );
                        } else if (widget.selectLanguagePage ==
                                SelectLanguageType.to &&
                            languageProvider.toLang.code ==
                                languageController.languages[index].code) {
                          return const SizedBox(
                            width: 0,
                            height: 0,
                          );
                        } else {
                          return ListTile(
                            onTap: () {
                              if (widget.selectLanguagePage ==
                                  SelectLanguageType.from) {
                                if (languageProvider.toLang.code! ==
                                    languageController.languages[index].code!) {
                                  var _from = languageProvider.fromLang;
                                  var _to = languageProvider.toLang;
                                  languageProvider.fromLang = _to;
                                  languageProvider.toLang = _from;
                                } else {
                                  languageProvider.fromLang =
                                      languageController.languages[index];
                                }
                              } else {
                                if (languageProvider.fromLang.code! ==
                                    languageController.languages[index].code!) {
                                  var _from = languageProvider.fromLang;
                                  var _to = languageProvider.toLang;
                                  languageProvider.fromLang = _to;
                                  languageProvider.toLang = _from;
                                } else {
                                  languageProvider.toLang =
                                      languageController.languages[index];
                                  widget.onChange();
                                }
                              }
                              Navigator.pop(context);
                            },
                            contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                            title: Text(
                              languageController.languages[index].name
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: appColors.colorText1),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(
      {required Function() onTap, required LanguageProvider languageProvider}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: languageProvider.showKeyBoard
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                controller: languageController.searchController,
                focusNode: languageController.focusNode,
                autofocus: true,
                enableSuggestions: true,
                maxLines: 1,
                onChanged: (text) => languageController.searchBox(
                    text, languageProvider, setState),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Language',
                  hintStyle: TextStyle(
                      color: appColors.colorText1.withOpacity(0.7),
                      fontSize: 50.sp),
                ),
                style: TextStyle(color: appColors.colorText1, fontSize: 50.sp),
              ),
            )
          : Text(
              widget.selectLanguagePage == SelectLanguageType.from
                  ? 'Translate from'
                  : 'Translate to',
              style: TextStyle(
                  color: appColors.colorText1,
                  fontSize: 60.sp,
                  fontWeight: FontWeight.w600)),
      leading: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: AnimatedOnTapButton(
          onTap: onTap,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 70.w,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 30.w),
          child: AnimatedOnTapButton(
            onTap: () {
              /// open setting page
              languageProvider.showKeyBoard = !languageProvider.showKeyBoard;
            },
            child: Icon(
              languageProvider.showKeyBoard
                  ? Icons.cancel_outlined
                  : Icons.search,
              color: Colors.white,
              size: 70.w,
            ),
          ),
        ),
      ],
    );
  }
}
