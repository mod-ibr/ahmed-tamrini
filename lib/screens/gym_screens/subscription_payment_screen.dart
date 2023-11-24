import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/product_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/Upload%20Image.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../model/gym.dart';
import '../../utils/helper_functions.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  final Gym gym;

  const SubscriptionPaymentScreen({Key? key, required this.gym})
      : super(key: key);

  @override
  State<SubscriptionPaymentScreen> createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  int _selectedItem = 1;

  // int _selectedItem2 = 1;
  int _selectedItem3 = 1;
  PaymentMethod _paymentMethod = PaymentMethod.cashOnDelivery;

  var formatter = NumberFormat('###,###,000');

  String? address;

  String notes = "";

  @override
  void initState() {
    allPhotos = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(
          context.locale.languageCode == 'ar' ? "الاشتراك" : "subscription"),
      body: Consumer<ProductProvider>(builder: (context, _, child) {
        return (_.isLoading)
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Image.asset('assets/images/loading.gif',
                      height: 100.h, width: 100.w),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.gym.assets.isNotEmpty
                              ? Image(
                                  image:
                                      HelperFunctions.ourFirebaseImageProvider(
                                          url: widget.gym.assets[0]),
                                  height: 50,
                                  width: 50,
                                )
                              : const Icon(Icons.image),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(widget.gym.name),
                                Text(
                                  " ${formatter.format(widget.gym.price)}${context.locale.languageCode == 'ar' ? " د.ع" : ' IQD'} ",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          TextFormField(
                            maxLines: 3,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: tr('enter_address'),
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                address = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: context.locale.languageCode == 'ar'
                                  ? 'ملاحظات'
                                  : 'Notes',
                            ),
                            onChanged: (value) {
                              setState(() {
                                notes = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(tr('payment_method')),
                      Column(
                        children: [
                          RadioListTile<PaymentMethod>(
                            value: PaymentMethod.cashOnDelivery,
                            groupValue: _paymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _paymentMethod = value!;
                              });
                            },
                            title: Text(tr('payment_delivery')),
                          ),
                          RadioListTile<PaymentMethod>(
                            value: PaymentMethod.moneyTransfer,
                            groupValue: _paymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _paymentMethod = value!;
                              });
                            },
                            title: Text(tr('payment_wallet')),
                          ),
                          _paymentMethod != PaymentMethod.moneyTransfer
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 40),
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            _.digitalPaymentMethods.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (_.digitalPaymentMethods[index]
                                                  .isActive ==
                                              false) {
                                            return const SizedBox.shrink();
                                          }
                                          return RadioListTile(
                                            value: index,
                                            groupValue: _selectedItem3,
                                            onChanged: (int? value) {
                                              setState(() {
                                                _selectedItem3 = value!;
                                              });
                                            },
                                            title: Text(
                                                _.digitalPaymentMethods[index]
                                                        .title ??
                                                    ''),
                                            subtitle: Text(
                                                _.digitalPaymentMethods[index]
                                                        .phoneNumber ??
                                                    ''),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(tr('upload_receipt')),
                                    const ImageUploads(
                                      isOneImage: true,
                                      isVideo: false,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: kSecondaryColor,
                        onPressed: () async {
                          if (_paymentMethod == PaymentMethod.moneyTransfer &&
                              _selectedItem3 == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(tr('choose_payment'))));
                            return;
                          }
                          if (address == null || address!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(tr('enter_address'))));
                            return;
                          }
                          if (_paymentMethod == PaymentMethod.cashOnDelivery) {
                            await _.gymSubscription(
                              gym: widget.gym,
                              address: address ?? "",
                              notes: notes,
                              paymentMethod: _paymentMethod,
                            );

                            return;
                          } else {
                            var images = await Provider.of<UploadProvider>(
                                    context,
                                    listen: false)
                                .uploadFiles();
                            if (images.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(tr('upload_img'))));
                              return;
                            }
                            _.gymSubscription(
                                gym: widget.gym,
                                address: address ?? "",
                                notes: notes,
                                paymentMethod: _paymentMethod,
                                image: images[0]);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child:
                                    Icon(Icons.add_circle, color: Colors.white),
                              ),
                              Text(
                                context.locale.languageCode == "ar"
                                    ? "اتمام الاشتراك"
                                    : "Complete subscription",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
