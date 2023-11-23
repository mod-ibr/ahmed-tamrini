import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/payment.dart';
import 'package:tamrini/provider/product_provider.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  bool isAdding = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(tr('payment_methods')),
      // appBar: globalAppBar('وسائل الدفع'),
      body: Consumer<ProductProvider>(builder: (context, _, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: _.isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: kSecondaryColor,
                          onPressed: () {
                            setState(() {
                              isAdding = !isAdding;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsetsDirectional.only(end: 8.0),
                                child:
                                    Icon(Icons.add_circle, color: Colors.white),
                              ),
                              Text(
                                tr('add_payment_method'),
                                // "اضافة وسيلة دفع جديدة",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          )),
                      isAdding
                          ? Column(
                              children: [
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    labelText:
                                        context.locale.languageCode == 'ar'
                                            ? 'اسم الوسيلة'
                                            : 'Method name',
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText:
                                        context.locale.languageCode == 'ar'
                                            ? 'رقم الوسيلة'
                                            : 'Method number',
                                    border: const OutlineInputBorder(),
                                  ),
                                  controller: numberController,
                                ),
                                const SizedBox(height: 20),
                                MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: kSecondaryColor,
                                    onPressed: () {
                                      Payment paymentMethod = Payment(
                                        title: titleController.text,
                                        phoneNumber: numberController.text,
                                        isActive: true,
                                        // isDigital: true,
                                      );

                                      _.addPaymentMethod(paymentMethod);
                                      titleController.clear();
                                      numberController.clear();
                                      setState(() {
                                        isAdding = false;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // const Padding(
                                        //   padding: EdgeInsetsDirectional.only(
                                        //       end: 8.0),
                                        //   child: Icon(Icons.add_circle,
                                        //       color: Colors.white),
                                        // ),
                                        Text(
                                          tr('add_payment_method'),
                                          // "اضافة وسيلة دفع جديدة",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20),
                      _.digitalPaymentMethods.isEmpty ||
                              _.digitalPaymentMethods == null
                          ? Center(
                              child: Text(tr('no_payment_methods')),
                              // child: Text('لا يوجد وسائل دفع'),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 20,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(_.digitalPaymentMethods[index]
                                                    .title ??
                                                ''),
                                            Text(_.digitalPaymentMethods[index]
                                                    .phoneNumber ??
                                                ''),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Text(tr('activate')),
                                                // Text('تفعيل'),
                                                Checkbox(
                                                  value: _
                                                          .digitalPaymentMethods[
                                                              index]
                                                          .isActive ??
                                                      false,
                                                  onChanged: (value) {
                                                    _
                                                        .digitalPaymentMethods[
                                                            index]
                                                        .isActive = value;
                                                    _.updatePaymentMethod(
                                                        _.digitalPaymentMethods[
                                                            index]);
                                                  },
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Widget cancelButton =
                                                    TextButton(
                                                  child: Text(tr('cancel')),
                                                  onPressed: () {
                                                    pop();
                                                  },
                                                );
                                                Widget continueButton =
                                                    TextButton(
                                                  child: Text(
                                                    tr('confirm_deletion'),
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    pop();

                                                    _.deletePaymentMethod(
                                                        _.digitalPaymentMethods[
                                                            index]);
                                                  },
                                                );

                                                showDialog(
                                                    context: navigationKey
                                                        .currentState!.context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                            tr('confirm_deletion'),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                          content: Text(
                                                            context.locale
                                                                        .languageCode ==
                                                                    'ar'
                                                                ? 'هل انت متأكد من حذف وسيلة الدفع هذه ؟'
                                                                : 'Are you sure you want to delete this payment method?',
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                          actions: [
                                                            continueButton,
                                                            cancelButton,
                                                          ],
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                        ));
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                // return Card(
                                //   child: ListTile(
                                //     title: Text(_.digitalPaymentMethods[index].title??''),
                                //     subtitle: Text(_.digitalPaymentMethods[index].phoneNumber??''),
                                //     // trailing: Row(
                                //     //   children: [
                                //     //     // Checkbox(
                                //     //     //   value: _.digitalPaymentMethods[index].isActive,
                                //     //     //   onChanged: (value){
                                //     //     //   _.digitalPaymentMethods[index].isActive = value;
                                //     //     //   _.updatePaymentMethod(_.digitalPaymentMethods[index]);
                                //     //     // }
                                //     //     // ,),
                                //     //     IconButton(
                                //     //       onPressed: (){
                                //     //         _.deletePaymentMethod(_.digitalPaymentMethods[index]);
                                //     //       },
                                //     //       icon: const Icon(Icons.delete),
                                //     //     ),
                                //     //   ],
                                //     // ),
                                //   ),
                                //
                                // );
                              },
                              itemCount: _.digitalPaymentMethods.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
