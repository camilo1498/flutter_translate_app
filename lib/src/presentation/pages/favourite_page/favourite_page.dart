import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate_app/src/core/constants/app_colors.dart';
import 'package:flutter_translate_app/src/core/constants/month_list.dart';
import 'package:flutter_translate_app/src/data/models/favourite.dart';
import 'package:flutter_translate_app/src/presentation/pages/favourite_page/favourite_page_controller.dart';
import 'package:flutter_translate_app/src/presentation/providers/database_provider.dart';
import 'package:flutter_translate_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  /// favourite controller
  late FavouritePageController favouritePageController;

  /// parse date time
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  /// app colors instance
  final AppColors appColors = AppColors();

  /// screen util instance
  final ScreenUtil screenUtil = ScreenUtil();

  @override
  void initState() {
    favouritePageController = FavouritePageController(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: Consumer<DatabaseProvider>(builder: (_, databaseProvider, __) {
        return Scaffold(
          backgroundColor: appColors.backgroundColor,
          appBar: PreferredSize(
            preferredSize: Size(screenUtil.screenWidth, 170.w),
            child: _appBar(() => Navigator.pop(context)),
          ),
          body: _body(databaseProvider),
        );
      }),
    );
  }

  Widget _appBar(Function() onTap) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('Saved',
          style: TextStyle(color: appColors.colorText1, fontSize: 60.sp)),
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
            padding: EdgeInsets.only(right: 45.w),
            child: Icon(
              Icons.translate,
              color: Colors.white,
              size: 70.w,
            )),
      ],
    );
  }

  Widget _body(DatabaseProvider databaseProvider) {
    return Material(
      color: Colors.transparent,
      child: databaseProvider.favouriteList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GroupedListView<Favourite, String>(
                elements: databaseProvider.favouriteList,
                groupBy: (element) {
                  DateTime _parse =
                      DateTime.fromMillisecondsSinceEpoch(element.timestamp!);
                  DateTime _date = DateTime.parse(
                      dateFormat.parse(_parse.toString()).toString());
                  return '${MonthList.months[_date.month - 1]} ${_date.day} ${_date.year}';
                },
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) => item1.timestamp
                    .toString()
                    .compareTo(item2.timestamp.toString()),
                order: GroupedListOrder.ASC,
                groupSeparatorBuilder: (String value) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 5),
                    child: Text(
                      value,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.withOpacity(0.7),
                          fontWeight: FontWeight.bold),
                    ),
                  );
                },
                itemBuilder: (context, element) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: GestureDetector(
                        onTap: () {},
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                element.originalText.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: appColors.colorText1,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                element.translationText.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color:
                                        appColors.colorText2.withOpacity(0.7),
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          trailing: AnimatedOnTapButton(
                            onTap: () => favouritePageController
                                .deleteFavourite(element),
                            child: Icon(
                              Icons.star,
                              color: appColors.iconColor2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: SizedBox(
                  width: screenUtil.screenWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: appColors.iconColor2.withOpacity(0.7),
                        size: 200.w,
                      ),
                      40.verticalSpace,
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Save key phrases\n\n',
                              style: TextStyle(
                                  fontSize: 52.sp,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.colorText3)),
                          TextSpan(
                              text:
                                  'Tap the star icon to save translations you use most',
                              style: TextStyle(
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w500,
                                  color: appColors.colorText2))
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
