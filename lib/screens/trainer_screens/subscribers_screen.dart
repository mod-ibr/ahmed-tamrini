import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class SubscribersScreen extends StatelessWidget {
  const SubscribersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('subscribers')),
      // appBar: globalAppBar("المشتركين"),
      body: Consumer<GymProvider>(builder: (context, _, child) {
        return _.isLoading
            ? Center(
                child: Image.asset('assets/images/loading.gif',
                    height: 100.h, width: 100.w),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _.subscribers.isEmpty
                      ? [
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Center(child: Text(tr('no_subscribers'))),
                            // child: Center(child: Text("لا يوجد لديك مشتركين")),
                          ),
                        ]
                      : [
                          const SizedBox(height: 10),
                          searchBar(
                            searchController,
                            (value) {
                              _.searchSubscribers(value);
                            },
                          ),
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Dismissible(
                                  key: UniqueKey(),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  secondaryBackground: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  direction: DismissDirection.horizontal,
                                  confirmDismiss: (direction) async {
                                    AwesomeDialog(
                                            context:
                                                navigationKey.currentContext!,
                                            dialogType: DialogType.warning,
                                            animType: AnimType.BOTTOMSLIDE,
                                            title:
                                                context.locale.languageCode ==
                                                        'ar'
                                                    ? 'حذف المشترك'
                                                    : 'Delete Subscriber',
                                            desc: tr('sure_of_deletion'),
                                            btnOkOnPress: () {
                                              _.deleteSubscriber(
                                                  _.subscribers[index]);
                                            },
                                            btnCancelOnPress: () {})
                                        .show();
                                    return null;
                                  },
                                  onDismissed: (direction) async {},
                                  child: ListTile(
                                    onTap: () {},
                                    title: Text(_.subscribers[index].name),
                                    subtitle: Text(
                                      '${tr('subscription_date')} : ${_.timestampToString(_.subscribers[index].dateOfGymSubscription!)}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: _.subscribers.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                          const SizedBox(height: 10),
                        ],
                ),
              );
      }),
    );
  }
}
