// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/core/constants/month_list.dart';
import 'package:flutter_translator_app/src/data/models/History.dart';
import 'package:flutter_translator_app/src/presentation/pages/history_page/history_page_controller.dart';
import 'package:flutter_translator_app/src/presentation/providers/database_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  final ScrollController? listController;
  const HistoryPage({Key? key, this.listController}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  /// history controller
  late HistoryPageController _historyPageController;

  /// parse date time
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  /// app colors instance
  final AppColors appColors = AppColors();

  /// screen util instance
  final ScreenUtil screenUtil = ScreenUtil();

  @override
  void initState() {
    _historyPageController = HistoryPageController(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: Consumer<DatabaseProvider>(
        builder: (_, databaseProvider, __) {
          return Scaffold(
            backgroundColor: appColors.backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size(screenUtil.screenWidth, 170.w),
              child: HistoryAppBar(
                onTap: () => Navigator.pop(context),
                historyPageController: _historyPageController,
              ),
            ),
            body: HistoryBody(
                historyProvider: databaseProvider,
                historyPageController: _historyPageController),
          );
        },
      ),
    );
  }
}

class HistoryAppBar extends StatelessWidget {
  final Function() onTap;
  final HistoryPageController historyPageController;
  HistoryAppBar(
      {super.key, required this.onTap, required this.historyPageController});

  /// app colors instance
  final AppColors appColors = AppColors();

  /// screen util instance
  final ScreenUtil screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('History',
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
          child: AnimatedOnTapButton(
            onTap: historyPageController.deleteAllHistory,
            child: Icon(
              Provider.of<DatabaseProvider>(context).historyList.isNotEmpty
                  ? Icons.delete_outline
                  : Icons.translate,
              color: Colors.white,
              size: 70.w,
            ),
          ),
        ),
      ],
    );
  }
}

class HistoryBody extends StatelessWidget {
  /// providers
  final DatabaseProvider historyProvider;
  final HistoryPageController historyPageController;

  /// list controller
  final ScrollController? listController;

  HistoryBody(
      {Key? key,
      required this.historyProvider,
      required this.historyPageController,
      this.listController})
      : super(key: key);

  /// parse date time
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  /// app colors instance
  final AppColors appColors = AppColors();

  /// screen util instance
  final ScreenUtil screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, databaseProvider, __) {
        return Material(
          color: Colors.transparent,
          child: databaseProvider.historyList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GroupedListView<History, String>(
                    elements: databaseProvider.historyList,
                    reverse: listController != null ? true : false,
                    controller: listController ?? ScrollController(),
                    groupBy: (element) {
                      DateTime _parse = DateTime.fromMillisecondsSinceEpoch(
                          element.timestamp!);
                      DateTime _date = DateTime.parse(
                          dateFormat.parse(_parse.toString()).toString());
                      return '${MonthList.months[_date.month - 1]} ${_date.day} ${_date.year}';
                    },
                    groupComparator: (value1, value2) =>
                        value2.compareTo(value1),
                    itemComparator: (item1, item2) => item1.timestamp
                        .toString()
                        .compareTo(item2.timestamp.toString()),
                    order: listController != null
                        ? GroupedListOrder.DESC
                        : GroupedListOrder.ASC,
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
                        child: Slidable(
                          key: ValueKey(element.id),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(
                                onDismissed: () => historyPageController
                                    .deleteHistoryItem(element.id)),
                            children: [
                              SlidableAction(
                                onPressed: (_) => historyPageController
                                    .deleteHistoryItem(element.id),
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
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
                                          color: appColors.colorText2
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                trailing: AnimatedOnTapButton(
                                  onTap: () => historyPageController
                                      .updateHistoryItem(element),
                                  child: Icon(
                                    element.isFavorite == 'true'
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: appColors.iconColor2,
                                  ),
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
                  child: SingleChildScrollView(
                    controller: listController ?? ScrollController(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_toggle_off_outlined,
                          color: appColors.iconColor2.withOpacity(0.7),
                          size: 300.w,
                        ),
                        40.verticalSpace,
                        Text(
                          'Empty history',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blue[200]!,
                              fontSize: 45.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
