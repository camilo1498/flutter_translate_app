import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate_app/src/core/constants/app_colors.dart';
import 'package:flutter_translate_app/src/presentation/widgets/animations/animated_onTap_button.dart';

class LanguageButton extends StatelessWidget {
  final String text;
  final AppColors appColors;
  final Function() onTap;
  const LanguageButton(
      {super.key,
      required this.text,
      required this.appColors,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedOnTapButton(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 125.h,
        width: 380.w,
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
        child: Text(
          text,
          style: TextStyle(
              color: appColors.colorText3,
              fontWeight: FontWeight.bold,
              fontSize: 38.sp),
        ),
      ),
    );
  }
}
