import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/trainee_provider.dart';
import '../../utils/widgets/global Widgets.dart';
import '../supplement_screens/supplements_Article_details_screen.dart';

class SupplementsScreen extends StatelessWidget {
  const SupplementsScreen({Key? key}) : super(key: key);

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
                        // const Spacer(),
                        if (_.traineeData == null ||
                            _.traineeData!.supplements == null ||
                            _.traineeData!.supplements!.isEmpty)
                          Center(child: Text(tr('no_supplements'))),
                        // child: Text('لا يوجد مكملات غذائية حاليا')),
                        if (_.traineeData != null &&
                            _.traineeData!.supplements != null &&
                            _.traineeData!.supplements!.isNotEmpty) ...[
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
                                        supplement:
                                            _.traineeData!.supplements![index],
                                      ),
                                    );
                                  },
                                  title: Text(_.traineeData!.supplements![index]
                                          .title ??
                                      ''),
                                  subtitle: Text(
                                    _.traineeData!.supplements![index]
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
                            itemCount: _.traineeData!.supplements!.length,
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
