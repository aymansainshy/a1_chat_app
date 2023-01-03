import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constan/const.dart';
import '../../../core/utils/assets_utils.dart';
import '../../../core/utils/screenutil_helper.dart';
import '../widgets/login_form.dart';

const double _logoImageHeight1 = 150;

const double _logoImageWidth1 = 170;


class LoginView extends StatefulWidget {

  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    var isLandScape = DivceScreenSize.isLandScape(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.translate(
                offset: const Offset(0, 50),
                child: Hero(
                  tag: klogoAnimation,
                  child: SvgPicture.asset(
                    AssetsUtils.chatLogo,
                    fit: BoxFit.contain,
                    color: Colors.black,
                    height: ScreenUtil().setHeight(_logoImageHeight1),
                    width: ScreenUtil().setHeight(_logoImageWidth1),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(80),
              ),
              LoginForm(isLandScape, ScreenUtil()),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              // DropdownButtonHideUnderline(
              //   child: DropdownButton(
              //     // dropdownColor: AppColors.primaryColor,
              //     items: langugeProvider.languages
              //         .map(
              //           (lang) => DropdownMenuItem(
              //             value: lang.localName,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceAround,
              //               children: [
              //                 Text(
              //                   lang.localName,
              //                   style: TextStyle(
              //                     fontSize: Application.screenUtil.setSp(15),
              //                   ),
              //                 ),
              //                 const SizedBox(
              //                   height: 5,
              //                 ),
              //                 SizedBox(
              //                   height: Application.screenUtil.setHeight(15),
              //                   width: Application.screenUtil.setWidth(15),
              //                   child: Image.asset(
              //                     lang.flag,
              //                     fit: BoxFit.contain,
              //                   ),
              //                 )
              //               ],
              //             ),
              //             onTap: () {
              //               langugeProvider.changeLanguage(Locale(lang.code));
              //             },
              //           ),
              //         )
              //         .toList(),
              //     onChanged: (String? value) {
              //       setState(() {
              //         appLang = value;
              //       });
              //     },
              //     value: appLang,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
