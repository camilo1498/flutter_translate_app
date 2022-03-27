import 'package:flutter/material.dart';
import 'package:flutter_translator_app/src/data/models/language.dart';
import 'package:flutter_translator_app/src/presentation/pages/select_language_page/select_language_controller.dart';
import 'package:flutter_translator_app/src/presentation/providers/select_language_provider.dart';
import 'package:flutter_translator_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SelectLanguageType {from, to}
class SelectLanguagePage extends StatefulWidget {
  SelectLanguageType selectLanguagePage = SelectLanguageType.from;
  SelectLanguagePage({
  Key? key,
    required this.selectLanguagePage
}) : super(key: key);

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  final SelectLanguageController _selectLanguageController = SelectLanguageController();

  final ScreenUtil screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll){
        overscroll.disallowIndicator();
        return false;
      },
      child: Consumer<SelectLanguageProvider>(
        builder: (_, selectLanguage, __){
          return Scaffold(
            backgroundColor: _selectLanguageController.appColors.backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size(screenUtil.screenWidth, 170.w),
              child: _appBar(onTap: (){
                Navigator.pop(context);
              }),
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
                    if(widget.selectLanguagePage == SelectLanguageType.from && selectLanguage.fromLang.code! != 'detect')
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                        onTap: (){
                          setState(() {
                            selectLanguage.fromLang = Language(
                              code: 'detect',
                              name: 'Detect language'
                            );
                          });
                        },
                        title: Text(
                          'Detect language',
                          style: TextStyle(
                              color: _selectLanguageController.appColors.colorText1,
                            fontSize: 45.sp
                          ),
                        ),
                        trailing: Icon(
                          Icons.auto_awesome,
                          size: 50.w,
                          color: _selectLanguageController.appColors.iconColor1,
                        ),
                      ),
                    30.verticalSpace,
                    Text(
                      'Selected language',
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 40.sp
                      ),
                    ),
                    30.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                          title: Text(
                            widget.selectLanguagePage == SelectLanguageType.from
                                ? selectLanguage.fromLang.name.toString().split(' ')[0]
                                : selectLanguage.toLang.name.toString().split(' ')[0],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: _selectLanguageController.appColors.colorText1
                            ),
                          ),
                          trailing: Icon(
                            Icons.check,
                            size: 50.w,
                            color: _selectLanguageController.appColors.iconColor1,
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
                        fontSize: 40.sp
                      ),
                    ),
                    30.verticalSpace,
                    FutureBuilder<List<Language>>(
                      future: selectLanguage.getLanguages(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index){
                              if(widget.selectLanguagePage == SelectLanguageType.from && selectLanguage.fromLang.code == snapshot.data![index].code){
                                return const SizedBox(
                                  width: 0,
                                  height: 0,
                                );
                              } else if(widget.selectLanguagePage == SelectLanguageType.to && selectLanguage.toLang.code == snapshot.data![index].code){
                                return const SizedBox(
                                  width: 0,
                                  height: 0,
                                );
                              } else{
                                return  ListTile(
                                  onTap: (){
                                    setState((){
                                      if(widget.selectLanguagePage == SelectLanguageType.from){
                                        if(selectLanguage.toLang.code! == snapshot.data![index].code!){
                                          var _from = selectLanguage.fromLang;
                                          var _to = selectLanguage.toLang;
                                          selectLanguage.fromLang = _to;
                                          selectLanguage.toLang = _from;
                                        } else{
                                          selectLanguage.fromLang = snapshot.data![index];
                                        }
                                      } else{
                                        if(selectLanguage.fromLang.code! == snapshot.data![index].code!){
                                          var _from = selectLanguage.fromLang;
                                          var _to = selectLanguage.toLang;
                                          selectLanguage.fromLang = _to;
                                          selectLanguage.toLang = _from;
                                        } else{
                                          selectLanguage.toLang = snapshot.data![index];
                                        }
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                                  contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                                  title: Text(
                                    snapshot.data![index].name.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: _selectLanguageController.appColors.colorText1
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        } else{
                          return Container();
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

  Widget _appBar({required Function() onTap}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
          widget.selectLanguagePage == SelectLanguageType.from ? 'Translate from' : 'Translate to',
          style: TextStyle(
              color: _selectLanguageController.appColors.colorText1,
              fontSize: 60.sp,
            fontWeight: FontWeight.w600
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
}
