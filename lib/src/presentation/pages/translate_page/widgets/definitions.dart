import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translator_app/src/core/constants/app_colors.dart';
import 'package:flutter_translator_app/src/data/models/synonym.dart';
import 'package:flutter_translator_app/src/presentation/pages/translate_page/widgets/source_container.dart';
import 'package:flutter_translator_app/src/presentation/providers/translate_provider.dart';

class Definitions extends StatelessWidget {
  final TranslateProvider translateProvider;
  const Definitions({
    Key? key,
    required this.translateProvider
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final AppColors appColors = AppColors();
    return SourceContainer(
      children: [
        Text(
          'Definitions',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: appColors .colorText1,
              fontSize: 50.sp,
              fontWeight: FontWeight.w500
          ),
        ),

        40.verticalSpace,

        ...translateProvider.translate!.source!.definitions!.map((definitions) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// adjective, noun, adverb title
              Text(
                definitions.type!,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.lightBlueAccent[100],
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w500),
              ),
              10.verticalSpace,
              if (definitions.definitions != null)
                ...definitions.definitions!.map((subDef) {
                  /// card body
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// counter widget
                        Container(
                          width: 60.w,
                          height: 60.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.blue[900]!,
                              shape: BoxShape.circle
                          ),
                          child: Text(
                            (definitions.definitions!.indexOf(subDef) + 1).toString(),
                            style: TextStyle(
                                color: appColors.colorText1,
                                fontSize: 20.sp,
                                overflow: TextOverflow.ellipsis,
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
                              /// synonym widget
                              if (translateProvider.translate!.source!.synonyms != null)
                                ... translateProvider.translate!.source!.synonyms!.map((synonym) {
                                  List<Synonym> listSynonym = [];
                                  int synIndex = translateProvider.translate!.source!.synonyms!.indexOf(synonym);
                                  if(translateProvider.translate!.source!.synonyms![translateProvider.translate!.source!.synonyms!.indexOf(synonym)].isNotEmpty){
                                    for(int i = 0; i < translateProvider.translate!.source!.synonyms![translateProvider.translate!.source!.synonyms!.indexOf(synonym)].length; i++){
                                      listSynonym.add(Synonym(id: translateProvider.translate!.source!.synonyms![synIndex][i].id, words: translateProvider.translate!.source!.synonyms![synIndex][i].words));
                                    }

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        40.verticalSpace,
                                        ListView.builder(
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
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })
            ],
          );
        }),
      ],
    );
  }
}
