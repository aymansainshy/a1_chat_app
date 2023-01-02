import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constan/const.dart';
import '../../../core/errors/custom_error_dialog.dart';
import '../../../core/theme/app_theme.dart';
import '../auth-bloc/otp_bloc.dart';

class PinCodeVerificationView extends StatefulWidget {
  final String? phoneNumber;
  final String? name;

  const PinCodeVerificationView({
    Key? key,
    required this.phoneNumber,
    required this.name,
  }) : super(key: key);

  @override
  State<PinCodeVerificationView> createState() =>
      _PinCodeVerificationViewState();
}

class _PinCodeVerificationViewState extends State<PinCodeVerificationView> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: BlocConsumer<OtpBloc, OtpState>(
          // listenWhen: (pOtpState, otpState) {
          //   if (pOtpState != otpState) {
          //     return true;
          //   } else {
          //     return false;
          //   }
          // },
          listener: (context, otpState) {
            if (otpState is VarifyOtpSuccess) {
              snackBar("varify Done Successfully");

              // Navigator.of(context).pushReplacementNamed(TapScreen.routeName);
            }

            if (otpState is VarifyOtpFaliure) {
              String errorMassege = "Please enter avalid OTP";

              customeAlertDialoge(
                  context: context,
                  title: "An error occurred !",
                  errorMessage: errorMassege,
                  fun: () {});
            }

            /////////////////////////////////////////////////////////////////////////
            if (otpState is SendOtpInProgress) {
              snackBar("Otp will send soon");
            }

            if (otpState is SendOtpFaliure) {
              String errorMassege = "anErrorOccured";

              customeAlertDialoge(
                  context: context,
                  title: "errorOccurred",
                  errorMessage: errorMassege,
                  fun: () {});
            }
          },
          builder: (context, otpState) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15),
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 30),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset("AssetsUtils.otpVarifyImage"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "varify PhoneNumber",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8),
                    child: RichText(
                      text: TextSpan(
                        text: "enter Otp Sended To You",
                        children: [
                          TextSpan(
                            text: widget.phoneNumber,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: PinCodeTextField(
                            appContext: context,
                            pastedTextStyle: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 5,
                            // obscureText: true,
                            obscuringCharacter: '*',
                            // obscuringWidget: FlutterLogo(
                            //   size: 24,
                            // ),
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            validator: (v) {
                              if (v!.length < 4) {
                                return "pleaseEnterAvalidOtp";
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              // inactiveColor: Colors.black,
                              selectedFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              activeColor: Colors.blue,
                              fieldHeight: 50,
                              fieldWidth: 50,
                              activeFillColor:
                                  hasError ? Colors.blue[100] : Colors.white,
                            ),
                            cursorColor: Colors.black,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: textEditingController,
                            keyboardType: TextInputType.number,
                            boxShadows: [bozShadow()],
                            onCompleted: (v) {
                              // print("Completed");
                            },
                            // onTap: () {
                            //   print("Pressed");
                            // },
                            onChanged: (value) {
                              // print(value);

                              currentText = value;
                            },
                            beforeTextPaste: (text) {
                              // print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      hasError ? "pleaseEnterAvalidOtp" : "",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "otp Did Not Receive",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                      BlocBuilder<OtpBloc, OtpState>(
                        builder: (context, otpState) {
                          return TextButton(
                            onPressed: () {
                              // AppBlocs.otpBloc.add(
                              //     ReSendOtp(widget.phoneNumber, widget.name));
                            },
                            child: otpState is SendOtpInProgress
                                ? Center(
                                    child: sleekCircularSlider(
                                      context,
                                      20,
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).indicatorColor,
                                    ),
                                  )
                                : const Text(
                                    "Re Send Otp",
                                    style: TextStyle(
                                        color: Color(0xFF91D3B3),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        // Theme.of(context).colorScheme.secondary,
                        AppColors.primaryColor,
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
                        child: otpState is VarifyOtpInProgress
                            ? Center(
                                child: sleekCircularSlider(
                                  context,
                                  ScreenUtil().setSp(30),
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).indicatorColor,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    onPressed: () {
                      formKey.currentState!.validate();

                      // AppBlocs.otpBloc
                      //     .add(VarifyOtp(widget.phoneNumber, currentText));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  BoxShadow bozShadow() {
    return const BoxShadow(
      offset: Offset(0, 1),
      color: Colors.black12,
      blurRadius: 10,
    );
  }
}
