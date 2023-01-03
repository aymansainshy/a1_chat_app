import 'dart:async';
import 'package:a1_chat_app/src/core/utils/assets_utils.dart';
import 'package:a1_chat_app/src/modules/auth/widgets/shared_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/errors/custom_error_dialog.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/hellper_methods.dart';
import '../auth-bloc/otp_bloc.dart';

const double _kbuttonHeight = 45.0;

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
              String errorMassege = "An error occurred";

              customeAlertDialoge(
                context: context,
                title: "error occurred",
                errorMessage: errorMassege,
                fun: () {},
              );
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
                    height: MediaQuery.of(context).size.height / 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SvgPicture.asset(AssetsUtils.chatLogo),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Varify Phone number",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Enter Otp Sended To You"),
                      const SizedBox(width: 5),
                      Text(
                        widget.phoneNumber!,
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                              return "Please enter avalid otp";
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
                          animationDuration: const Duration(milliseconds: 300),
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
                      ),
                    ),
                  ),
                  // if (hasError)
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 30.0, vertical: 10.0),
                  //   child: Text(
                  //     hasError ? "Please enter avalid otp" : " ",
                  //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //           color: Theme.of(context).errorColor,
                  //         ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "OTP didn't received",
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
                                : Text(
                                    "Resend OTP",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  SharedElevatedButton(
                    onPressed: () {
                      formKey.currentState?.save();
                    },
                    child: SizedBox(
                      height: _kbuttonHeight,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "Varify",
                          style: Theme.of(context).textTheme.button?.copyWith(
                                color: AppColors.textButtomColor,
                              ),
                        ),
                      ),
                    ),
                  )
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
