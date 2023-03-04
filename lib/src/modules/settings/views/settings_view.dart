import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_config_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Colors.white),
        title: const Text("Settings"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Setting",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                ),
                Card(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).accentColor,
                          backgroundImage: Application.user?.imageUrl != null
                              ? NetworkImage('${Application.domain}/uploads/${Application.user?.imageUrl}')
                              : null,
                          child: Application.user?.imageUrl != null
                              ? null
                              : Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Theme.of(context).primaryColor,
                                ),
                        ),
                        title: Text("${Application.user != null ? Application.user?.name : "User Name"}"),
                        subtitle:
                            Text(Application.user != null ? Application.user?.phoneNumber ?? "+2499xxxxxxxx" : "+2499xxxxxxxx"),
                        trailing: Icon(
                          CupertinoIcons.forward,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          if (Application.user == null) {
                            return;
                          }
                          context.go('/settings/user-settings');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "General Setting",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                ),
                Card(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Transform.translate(
                            offset: const Offset(0, 5),
                            child: Icon(
                              Icons.language,
                              color: Theme.of(context).primaryColor,
                            )),
                        title: const Text("language"),
                        trailing: Icon(
                          CupertinoIcons.forward,
                          color: Theme.of(context).primaryColor,
                        ),
                        subtitle: Text(Application.isEnglish ? "English" : "العربية"),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return LanguageDialog();
                              });
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: Transform.translate(
                          offset: const Offset(0, 5),
                          child: Icon(
                            Icons.phone_android,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        title: const Text("Dart Theme"),
                        subtitle: Text(Application.isDarktheme ? 'On' : "Off"),
                        trailing: Switch.adaptive(
                          activeColor: Theme.of(context).primaryColor,
                          value: Application.isDarktheme,
                          onChanged: (value) {
                            // context.read<ThemeBloc>().add(ChangeTheme(isDark: value));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: 400,
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: RadioListTile(
                  activeColor: Theme.of(context).primaryColor,
                  title: Transform.translate(
                    offset: const Offset(0, 2),
                    child: const Text("English"),
                  ),
                  value: 1,
                  groupValue: 1,
                  onChanged: (int? value) {
                    print("value : $value  ");
                    // context.read<LangBloc>().add(
                    //   ChangeLanguage(
                    //     selectedVal: value,
                    //     locale: Locale("en"),
                    //   ),
                    // );
                  },
                ),
              ),
              const Divider(),
              Expanded(
                child: RadioListTile(
                  activeColor: Theme.of(context).primaryColor,
                  title: Transform.translate(
                    offset: const Offset(0, 2),
                    child: const Text("العربية"),
                  ),
                  value: 2,
                  groupValue: 2,
                  onChanged: (int? value) {
                    print("value : $value  ");
                    // context.read<LangBloc>().add(
                    //   ChangeLanguage(
                    //     selectedVal: value,
                    //     locale: Locale("ar"),
                    //   ),
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
