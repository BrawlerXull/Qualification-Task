import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualification/controllers/home_controller.dart';
import 'package:qualification/widgets/widgets.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: HomePageAppBar(controller: controller),
        body: const HomePageBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.captureImage(),
          child: const Icon(Icons.camera),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
