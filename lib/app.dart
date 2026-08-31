import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/routes/app_pages.dart';
import 'package:muslim_community/config/themes/app_theme.dart';
import 'package:muslim_community/core/bindings/initial_binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sumayyah Yasir Ammar',
          theme: AppTheme.theme,
          initialBinding: InitialBinding(),
          initialRoute: AppPages.initial,
          getPages: AppPages.pages,
          defaultTransition: Transition.cupertino,
        );
      },
    );
  }
}
