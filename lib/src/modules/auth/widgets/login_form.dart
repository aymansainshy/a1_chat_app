import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../core/animations/fade_transition.dart';
import '../../../core/animations/slide_transition.dart';
import '../../../core/errors/custom_error_dialog.dart';
import '../auth-bloc/otp_bloc.dart';
import '../views/confirm_otp.dart';

class LoginForm extends StatefulWidget {
  final bool isLandScape;
  final ScreenUtil screenUtil;

  const LoginForm(
    this.isLandScape,
    this.screenUtil, {
    Key? key,
  }) : super(key: key);
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberFocusNode = FocusNode();

  late bool isPhoneValide = true;

  final TextEditingController _phoneNumberController = TextEditingController();
  String initialCountry = 'SD';
  PhoneNumber number = PhoneNumber(isoCode: 'SD');
  late String? phoneNumber = '';

  @override
  void initState() {
    super.initState();
  }

  var logInData = {
    'name': '',
    'phoneNumber': '',
  };

  @override
  void dispose() {
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (isPhoneValide && phoneNumber!.length > 8) {
      setState(() {
        logInData['phoneNumber'] = phoneNumber!;
      });
    }

    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    // AppBlocs.otpBloc.add(SendOtp(logInData['phoneNumber'], logInData['name']));

    // _formKey.currentState.reset();
  }

  @override
  Widget build(BuildContext context) {
    // final isArabic = Application.isEnglish(langugeProvider.appLocal);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: widget.screenUtil.setHeight(20),
            ),
            SlidTransition(
              animationDir: AnimationDir.rtl,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(
                    color: !isPhoneValide ? Colors.red : Colors.green,
                    width: 1,
                  ),
                  color: Colors.grey[100],
                ),
                child: Center(
                  child: InternationalPhoneNumberInput(
                    focusNode: _phoneNumberFocusNode,
                    spaceBetweenSelectorAndTextField: 0,
                    selectorTextStyle:
                        Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 17,
                            ),
                    textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 17,
                        ),
                    textAlign: TextAlign.start,
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      leadingPadding: 4,
                      trailingSpace: false,
                    ),
                    // focusNode: _phoneFocusNode,
                    textAlignVertical: TextAlignVertical.center,
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    initialValue: number,
                    textFieldController: _phoneNumberController,
                    formatInput: false,
                    inputDecoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.only(top: 5),
                      suffixIcon: const Icon(
                        Icons.phone_android,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.phone_android,
                        color: Colors.grey,
                      ),
                      hintText: "Phone",
                      fillColor: Colors.red,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          isPhoneValide = false;
                        });
                      }

                      return null;
                    },
                    onInputChanged: (PhoneNumber number) {
                      phoneNumber = number.toString();
                    },
                    onInputValidated: (bool value) {
                      if (value) {
                        setState(() {
                          isPhoneValide = value;
                        });
                      } else {
                        setState(() {
                          isPhoneValide = false;
                        });
                      }

                      // print(value);
                    },
                    // onSaved: (value) {
                    //   print("is phone valide ....." + isPhoneValide.toString());
                    //   if (isPhoneValide) {
                    //     signUpData['phoneNumber'] = value.toString();
                    //   }
                    // },
                  ),
                ),
              ),
            ),
            if (!isPhoneValide)
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Phone number invalid!",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            SizedBox(
              height: widget.screenUtil.setHeight(25),
            ),
            FadTransition(
              child: BlocConsumer<OtpBloc, OtpState>(
                listener: (context, otpState) {
                  if (otpState is SendOtpFaliure) {
                    customeAlertDialoge(
                      context: context,
                      title: "errorOccurred",
                      sendOtptitle: "ok",
                      errorMessage: "anErrorOccured",
                      fun: () {},
                    );
                  }

                  if (otpState is SendOtpSuccess) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PinCodeVerificationView(
                          name: logInData['name'],
                          phoneNumber: logInData['phoneNumber'],
                        ),
                      ),
                    );
                  }
                },
                builder: (context, otpState) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // side: BorderSide(color: Colors.red)
                        ),
                      ),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // gradient: LinearGradient(
                        //   begin: Alignment.centerLeft,
                        //   end: Alignment.centerRight,
                        //   colors: [
                        //     Color.fromRGBO(96, 120, 234, 1),
                        //     Color.fromRGBO(55, 183, 224, 1),
                        //   ],
                        // ),
                      ),
                      child: SizedBox(
                        height: 46,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: widget.isLandScape
                                ? widget.screenUtil.setSp(12)
                                : widget.screenUtil.setSp(15),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _saveForm();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Center(
//                                 child: sleekCircularSlider(
//                                     context,
//                                     widget.screenUtil.setSp(30),
//                                     AppColors.greenColor,
//                                     AppColors.scondryColor),
//                               )