import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({Key? key}) : super(key: key);

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool enableButton = false;

  String? code;

  @override
  initState() {
    _phoneController.text =
        Provider.of<UserProvider>(navigationKey.currentContext!, listen: false)
            .user
            .phone
            .split('-')[1];
    enableButton =
        !Provider.of<UserProvider>(navigationKey.currentContext!, listen: false)
            .user
            .isVerifiedPhoneNumber;
    code =
        Provider.of<UserProvider>(navigationKey.currentContext!, listen: false)
            .user
            .phone
            .split('-')[0]
            .replaceFirst('+', '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: globalAppBar(
            !Provider.of<UserProvider>(context, listen: false)
                    .user
                    .isVerifiedPhoneNumber
                ? tr('verify_phone')
                : tr('change_phone'),
            // ? 'تأكيد رقم الهاتف'
            // : 'تغيير رقم الهاتف',
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15.h,
                    ),
                    Text(
                      '${tr('status')} :',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'cairo',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Provider.of<UserProvider>(context, listen: false)
                              .user
                              .isVerifiedPhoneNumber
                          ? tr('verified')
                          : tr('not_verified'),
                      // ? 'تم التحقق'
                      // : 'لم يتم التحقق',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'cairo',
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: SizedBox(
                  height: 50.h,
                  child: TextFormField(
                    enabled: enableButton,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.phone,
                      ),
                      suffix: StatefulBuilder(builder: (context, setState) {
                        return InkWell(
                          onTap: () {
                            showCountryPicker(
                              countryListTheme: CountryListThemeData(
                                searchTextStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'cairo',
                                  color: Colors.black,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'cairo',
                                  color: Colors.grey,
                                ),
                                inputDecoration: InputDecoration(
                                  counterStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'cairo',
                                    color: Colors.black,
                                  ),

                                  labelStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'cairo',
                                    color: Colors.black,
                                  ),
                                  prefixIcon: const Icon(
                                    Ionicons.search_outline,
                                    color: Colors.black38,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  // filled: true,
                                  // fillColor: Colors.white,

                                  hintText: context.locale.languageCode == 'ar'
                                      ? 'البلد'
                                      : 'Country',
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'cairo',
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                              context: context,
                              showPhoneCode: true,
                              // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                code = country.phoneCode;
                                debugPrint(
                                    'Select country: ${country.phoneCode}');
                                setState(() {});
                              },
                            );
                          },
                          child: Text(
                            '+$code',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'cairo',
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }),
                      hintText: context.locale.languageCode == 'ar'
                          ? 'رقم الهاتف'
                          : 'Phone number',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'cairo',
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
                width: 100.w,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('+$code-${_phoneController.text.trim()}');
                    if (enableButton) {
                      if (_phoneController.text.length < 9) {
                        Fluttertoast.showToast(
                          msg: context.locale.languageCode == 'ar'
                              ? "الرجاء التأكد من رقم الهاتف"
                              : 'Please recheck the phone number',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }
                      if (_phoneController.text.toString()[0] == '0') {
                        _phoneController.text = _phoneController.text
                            .toString()
                            .replaceFirst('0', '');
                      }

                      Provider.of<UserProvider>(context, listen: false)
                          .verifyPhone(
                              phoneNumber:
                                  '+$code-${_phoneController.text.trim()}');
                    } else {
                      setState(() {
                        enableButton = true;
                      });
                    }
                  },
                  child: Text(
                    enableButton ? tr('verify') : tr('change'),
                    // enableButton ? 'تأكيد' : 'تغيير',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'cairo',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  validatePhone() {
    if (_phoneController.text.length < 9) {
      Fluttertoast.showToast(
        msg: context.locale.languageCode == 'ar'
            ? "الرجاء التأكد من رقم الهاتف"
            : 'Please recheck the phone number',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
  }
}
