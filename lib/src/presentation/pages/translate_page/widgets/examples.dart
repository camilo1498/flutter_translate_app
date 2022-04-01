import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/widgets/source_container.dart';
import 'package:flutter_translator_app/src/presentation/providers/translate_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Examples extends StatelessWidget {
  final TranslateProvider translateProvider;
  const Examples({
    Key? key,
    required this.translateProvider
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = AppColors();
    return SourceContainer(
      children: [
        Text(
          'Examples',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: appColors .colorText1,
              fontSize: 50.sp,
              fontWeight: FontWeight.w500
          ),
        ),
        30.verticalSpace,
        ListView.builder(
          itemCount: translateProvider.translate!.source!.examples!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue[900]!,
                        shape: BoxShape.circle
                    ),
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: appColors.colorText1,
                          fontSize: 20.sp,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  30.horizontalSpace,
                  Expanded(
                    child: Text(
                      translateProvider.translate!.source!.examples![index].toString(),
                      style: TextStyle(
                          color: appColors.colorText1,
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
