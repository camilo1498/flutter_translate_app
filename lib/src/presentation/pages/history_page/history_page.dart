import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translator_app/src/presentation/pages/history_page/history_page_controller.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  final ScrollController? listController;
  HistoryPage({
    Key? key,
    this.listController
  }) : super(key: key);
  final HistoryPageController _historyPageController = HistoryPageController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  final ScreenUtil screenUtil = ScreenUtil();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _historyPageController.appColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(screenUtil.screenWidth, 170.w),
        child: historyAppbar(onTap: (){
          Navigator.pop(context);
        }),
      ),
      body: historyBody(),
    );
  }

  Widget historyAppbar({required Function() onTap}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'History',
        style: TextStyle(
            color: _historyPageController.appColors.colorText1,
            fontSize: 60.sp
        )
      ),
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
            onTap: (){
              /// open setting page

            },
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 70.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget historyBody(){
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GroupedListView<dynamic, String>(
          elements: _historyPageController.elements,
          reverse: true,
          controller: listController,
          groupBy: (element) => element['date'],
          groupComparator: (value1,
              value2) => value2.compareTo(value1),
          itemComparator: (item1, item2) =>
              item1['date'].compareTo(item2['date']),
          order: GroupedListOrder.ASC,
          // useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) {
            DateTime _date = DateTime.parse(dateFormat.parse(value).toString());
            return Padding(
              padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 30,
                  bottom: 5
              ),
              child: Text(
                '${_historyPageController.months[_date.month -1]} ${_date.day} ${_date.year}',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.withOpacity(0.7),
                    fontWeight: FontWeight.bold
                ),
              ),
            );
          },
          itemBuilder: (c, element) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      element['originalText'],
                      textAlign: TextAlign.left,
                      style: TextStyle(

                          color: _historyPageController.appColors.colorText1,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      element['translatedText'],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: _historyPageController.appColors.colorText2.withOpacity(0.7),
                          fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
                trailing: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,),
                  child: Icon(
                    element['isFavorite'] ? Icons.star : Icons.star_border,
                    color: _historyPageController.appColors.iconColor2,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
