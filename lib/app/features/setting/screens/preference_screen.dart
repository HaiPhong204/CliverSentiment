import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/core.dart';
import '../../../routes/routes.dart';
import '../../features.dart';

class PreferencesSettingScreen extends StatefulWidget {
  const PreferencesSettingScreen({super.key});

  @override
  State<PreferencesSettingScreen> createState() => _PreferencesSettingScreenState();
}

class _PreferencesSettingScreenState extends State<PreferencesSettingScreen> {
  late final SharedPreferences pref;
  final SettingController _controller = Get.find();
  final _bottomBarController = Get.put(BottomBarController());

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Preferences".tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Obx(
                  () => SwitchListTile(
                    title: Text(
                      "Dark Mode".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryBlack,
                      ),
                    ),
                    value: _controller.isDarkMode.value,
                    onChanged: (value) =>
                        showDialog(context: context, builder: (_) => _alertDialog()),
                    secondary: Icon(
                      Icons.nightlight_sharp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.language_outlined,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    "Language".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                  onTap: () => showLanguageDialog(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void initData() async {
    pref = await SharedPreferences.getInstance();
  }

  changeTheme() {
    if (!_controller.isDarkMode.value) {
      AppColors().changeColor(true);
      Get.changeTheme(AppColors().darkTheme);
      pref.setBool("isDark", true);
      _controller.isDarkMode.value = true;
      _bottomBarController.currentIndex.value = 0;
      Get.offAllNamed(myBottomBarRoute);
    } else {
      AppColors().changeColor(false);
      Get.changeTheme(AppColors().lightTheme);
      pref.setBool("isDark", false);
      _controller.isDarkMode.value = false;
      _bottomBarController.currentIndex.value = 0;
      Get.offAllNamed(myBottomBarRoute);
    }
  }

  _alertDialog() {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder(
            curve: Curves.bounceOut,
            duration: const Duration(milliseconds: 1000),
            tween: Tween<Size>(begin: const Size(5, 5), end: MediaQuery.of(context).size),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Text(
                "Warning".tr,
                style: TextStyle(
                  color: Colors.orange.withOpacity(0.7),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          Text(
            "switch mode".tr,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            'Yes'.tr,
            style: TextStyle(
              color: Colors.orange.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => changeTheme(),
        ),
        TextButton(
          child: Text(
            'Cancel'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
