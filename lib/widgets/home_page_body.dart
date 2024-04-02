import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualification/controllers/home_controller.dart';
import 'package:qualification/widgets/widgets.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return controller.isCameraInitialized.value
            ? Stack(
                children: [
                  GestureDetector(
                    onDoubleTap: () async {
                      controller.onDoubleTap();
                    },
                    child: CameraPreview(controller.cameraController),
                  ),
                  HomePageStack(controller: controller),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
