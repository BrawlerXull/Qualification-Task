
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qualification/controllers/home_controller.dart';
import 'package:qualification/models/screen_params.dart';
import 'package:qualification/theme/custom_theme.dart';
import 'package:qualification/views/home_page_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(HomeController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return  GetMaterialApp(
      title: 'Qualification Task',
      home: const HomeView(),
        theme: lightTheme,
        darkTheme: darkTheme,
    );
  }
}
