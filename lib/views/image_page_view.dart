import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualification/controllers/image_controller.dart';

class ImagePageView extends GetView<ImageController> {
  const ImagePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Zooming Cam'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.saveImage(),
          child: const Icon(Icons.save),
        ),
        body: Image.file(
          File(controller.imagePath.value),
        ),
      ),
    );
  }
}
