import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/widgets/source_container.dart';
import 'package:flutter_translator_app/src/presentation/providers/translate_provider.dart';

class Translations extends StatelessWidget {
  final TranslateProvider translateProvider;
  const Translations({
    Key? key,
    required this.translateProvider,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final AppColors appColors = AppColors();
    final ScreenUtil screenUtil = ScreenUtil();
    return SourceContainer(
      children: [
        /// translations
        Text(
          'Other translations of "${translateProvider.originalText}"',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: appColors.colorText1,
              fontSize: 50.sp,
              fontWeight: FontWeight.w500),
        ),
        30.verticalSpace,
        ...translateProvider.translate!.translations!.map((otherTranslation) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// adjective, adverb, noun title
                Text(
                  otherTranslation.type.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.lightBlueAccent[100],
                      fontSize: 38.sp,
                      fontWeight: FontWeight.w500),
                ),
                10.verticalSpace,
                if (otherTranslation.translations != null)
                  ...otherTranslation.translations!.map((translationsList) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical:  30.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment:CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// title
                          SizedBox(
                            width: (screenUtil.screenWidth / 2) - 90.w,
                            child: RichText(
                              text:TextSpan(style: TextStyle(color: appColors.colorText2, fontSize: 40.sp, fontWeight: FontWeight.w600), children: [
                                if (translationsList.article != null)
                                  TextSpan(text: '${translationsList.article.toString()} '),
                                TextSpan(text: translationsList.word.toString())
                              ]),
                            ),
                          ),
                          if (translationsList.translations !=null)

                          /// other translations sub list
                            SizedBox(
                              width:(screenUtil.screenWidth / 2) - 90.w,
                              child:Wrap(
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
    );
  }
}
