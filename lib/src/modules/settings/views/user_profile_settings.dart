import 'package:a1_chat_app/src/modules/online-users/user-update-bloc/user_update_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/app_config_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart' as dialog;

import '../../../app/theme/app_theme.dart';
import '../../../core/errors/custom_error_dialog.dart';
import '../../../core/utils/hellper_methods.dart';

class UserProfileSettingsView extends StatefulWidget {
  const UserProfileSettingsView({Key? key}) : super(key: key);

  @override
  State<UserProfileSettingsView> createState() => _UserProfileSettingsViewState();
}

class _UserProfileSettingsViewState extends State<UserProfileSettingsView> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _editedData = {'name': ''};

  @override
  void initState() {
    super.initState();
  }

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    // AppBlocs.updateUserBloc.add(UpdateUserInfo(
    //   name: _editedData['name'],
    // ));

    // _formKey.currentState.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Colors.white),
        title: const Text("User Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage('${Application.domain}/uploads/${Application.user?.imageUrl}'),
                      ),
                      Positioned(
                        bottom: 3,
                        right: -7,
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).primaryColor,
                            size: 33,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  BuilFormField(
                    fieldName: 'Name',
                    initialValue: Application.user?.name!,
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    contentPadding: 8.0,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedData['name'] = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<UserUpdateBloc, UserUpdateState>(
                    listener: (context, updateUserState) {
                      if (updateUserState is UserUpdateInFailure) {
                        customeAlertDialoge(
                          context: context,
                          title: "Error Occured",
                          sendOtptitle: 'Ok',
                          errorMessage: "Somthing went wrong, please try again later!",
                          fun: () {},
                        );
                      }

                      if (updateUserState is UserUpdateInSuccess) {
                        customeAlertDialoge(
                          context: context,
                          title: 'Done',
                          alertType: dialog.AlertType.success,
                          sendOtptitle: 'Ok',
                          errorMessage: 'Name Updated Successfully',
                          fun: () {},
                        );
                      }
                    },
                    builder: (context, updateUserState) {
                      return ElevatedButton(
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
                          ),
                          child: SizedBox(
                            height: 46,
                            width: MediaQuery.of(context).size.width,
                            child: updateUserState is UserUpdateInProgress
                                ? Center(
                                    child: sleekCircularSlider(
                                        context, ScreenUtil().setSp(30), AppColors.primaryColor, AppColors.accentColor),
                                  )
                                : Center(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(15),
                                        fontWeight: FontWeight.bold,
                                      ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuilFormField extends StatefulWidget {
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?) validator;
  final String fieldName;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final double contentPadding;
  final TextEditingController? controller;
  final bool obscureText;
  final String? initialValue;

  const BuilFormField({
    Key? key,
    required this.textInputAction,
    required this.contentPadding,
    required this.keyboardType,
    required this.validator,
    required this.fieldName,
    this.prefixIcon,
    this.initialValue,
    this.onFieldSubmitted,
    this.onSaved,
    this.focusNode,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<BuilFormField> createState() => _BuilFormFieldState();
}

class _BuilFormFieldState extends State<BuilFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.fieldName,
        suffixIcon: widget.suffixIcon,
        filled: true,
        contentPadding: EdgeInsets.all(widget.contentPadding),
        prefixIcon: widget.prefixIcon,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1,
          ),
        ),
      ),
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      cursorColor: Colors.grey,
      validator: widget.validator,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      controller: widget.controller,
      obscureText: widget.obscureText,
    );
  }
}
