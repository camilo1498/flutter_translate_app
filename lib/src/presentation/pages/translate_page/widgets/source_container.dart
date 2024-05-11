import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SourceContainer extends StatelessWidget {
  final List<Widget> children;
  SourceContainer({super.key, required this.children});

  final ScreenUtil screenUtil = ScreenUtil();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: screenUtil.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 3.w, color: Colors.blue[900]!)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
