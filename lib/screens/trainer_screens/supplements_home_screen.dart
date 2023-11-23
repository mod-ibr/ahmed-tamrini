import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/trainee_provider.dart';
import '../../screens/supplement_screens/supplements_screen.dart' as SupScreen;
import '../../utils/constants.dart';
import '../../utils/widgets/global Widgets.dart';
import '../supplement_screens/supplements_Article_details_screen.dart';

class SupplementsHomeScreen extends StatelessWidget {
  const SupplementsHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: globalAppBar(tr('nutritional_supplements')),
        // appBar: globalAppBar('المكملات الغذائية'),
        body: Consumer<TraineeProvider>(
          builder: (context, _, child) {
            return _.isLoading
                ? Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_.userProvider.user.role == 'captain')
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: kSecondaryColor!,
                                onPressed: () {
                                  To(const SupScreen.SupplementsHomeScreen(
                                    canAddSupplementToTrainee: true,
                                  ));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsetsDirectional.only(end: 8.0),
                                      child: Icon(Icons.add_circle,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      tr('add_supplement'),
                                      // "اضافة مكمل غذائي",
                                      style: TextStyle(
                                          fontSize: 18.sp, color: Colors.white),
                                    ),
                                  ],
                                )),
                          ),
                        // const Spacer(),
                        if (_.selectedTrainee!.supplements == null ||
                            _.selectedTrainee!.supplements!.isEmpty)
                          Center(child: Text(tr('no_supplements'))),
                        // child: Text('لا يوجد مكملات غذائية حاليا')),
                        if (_.selectedTrainee!.supplements != null &&
                            _.selectedTrainee!.supplements!.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          ListView.separated(
                            reverse: true,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 15.h,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    To(
                                      SupplementArticlesDetailsScreen(
                                        supplement: _.selectedTrainee!
                                            .supplements![index],
                                      ),
                                    );
                                  },
                                  title: Text(_.selectedTrainee!
                                          .supplements![index].title ??
                                      ''),
                                  subtitle: Text(
                                    _.selectedTrainee!.supplements![index]
                                            .description ??
                                        '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  // subtitle: Text(_.selectedTrainee!.exercises![index].!),
                                  // isThreeLine: true,
                                ),
                              );
                            },
                            itemCount: _.selectedTrainee!.supplements!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ]
                      ],
                    ),
                  );
          },
        ));
  }
}
