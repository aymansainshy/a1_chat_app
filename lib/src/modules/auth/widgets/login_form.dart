import 'package:a1_chat_app/src/modules/auth/widgets/shared_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/animations/fade_transition.dart';
import '../../../core/constan/const.dart';
import '../../../core/errors/custom_error_dialog.dart';
import '../../../core/theme/app_theme.dart';
import '../auth-bloc/auth_cubit.dart';
import '../auth-bloc/otp_bloc.dart';

const double _kbuttonHeight = 45.0;

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
    if (isPhoneValide && phoneNumber!.length >= 8) {
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
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: widget.screenUtil.setHeight(20),
            ),
            FadTransition(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kborderRaduios),
                  ),
                  border: Border.all(
                    color: !isPhoneValide
                        ? Theme.of(context).errorColor
                        : AppColors.borderColor,
                    width: 1,
                  ),
                  color: Colors.grey[100],
                ),
                child: Center(
                  child: InternationalPhoneNumberInput(
                    focusNode: _phoneNumberFocusNode,
                    spaceBetweenSelectorAndTextField: 0,
                    selectorTextStyle: Theme.of(context).textTheme.bodyText2!,
                    textStyle: Theme.of(context).textTheme.bodyText2!,
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
                      // prefixIcon: const Icon(
                      //   Icons.phone_android,
                      //   color: Colors.grey,
                      // ),
                      hintText: "Phone number",
                      fillColor: Colors.red,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kborderRaduios),
                        borderSide: BorderSide.none,
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kborderRaduios),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kborderRaduios),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kborderRaduios),
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
                    "Invalid phone number !",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            SizedBox(
              height: widget.screenUtil.setHeight(25),
            ),
            BlocConsumer<OtpBloc, OtpState>(
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
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => PinCodeVerificationView(
                  //       name: logInData['name'],
                  //       phoneNumber: logInData['phoneNumber'],
                  //     ),
                  //   ),
                  // );
                }
              },
              builder: (context, otpState) {
                return SharedElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).tryLogin();
                    context.go('/otp');
                  },
                  child: SizedBox(
                    height: _kbuttonHeight,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.button?.copyWith(
                              color: AppColors.textButtomColor,
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // const SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.only(right: 10),
            //   child: GestureDetector(
            //     onTap: () {},
            //     child: const Text(
            //       "Skip",
            //       style: TextStyle(
            //         color: Colors.black,
            //       ),
            //     ),
            //   ),
            // ),
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

