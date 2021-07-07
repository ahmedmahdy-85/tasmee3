import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/pages/splash_screen.dart';
import 'package:tasmee3/pages/teacher/my_group.dart';
import 'package:tasmee3/view_model/control_view_model.dart';
import 'helper/binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(LocalStorageData());
  Get.put(ControlViewModel());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          primaryColor: accentColor,
          colorScheme: ColorScheme.light(primary: accentColor),
          fontFamily: 'Tajawal',
        ),
        debugShowCheckedModeBanner: false,
        initialBinding: Binding(),
        home: Scaffold(body: SplashScreen()),
        builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget),
              maxWidth: 1200,
              minWidth: 480,
              defaultScale: true,
              breakpoints: [
                ResponsiveBreakpoint.resize(480, name: MOBILE),
                ResponsiveBreakpoint.resize(600, name: MOBILE),
                ResponsiveBreakpoint.resize(700, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ],
            ));
  }
}
