import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qualification/controllers/image_controller.dart';
import 'package:qualification/models/recognition.dart';
import 'package:qualification/models/screen_params.dart';
import 'package:qualification/service/detector_service.dart';
import 'package:qualification/views/image_page_view.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  late List<CameraDescription> cameras;

  late CameraController cameraController;
  late CameraImage cameraImage;

  Detector? _detector;
  StreamSubscription? _subscription;

  List<Recognition>? results;
  Recognition? singleTappedObject;

  var isZoomed = false.obs;
  var imagePath = "".obs;
  var isCameraInitialized = false.obs;
  var frameCount = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await _initStateAsync();
    await initCamera();
  }

  void zoomOutButton() {
    cameraController.setZoomLevel(1.0);
    isZoomed.value = false;
  }

  void onDoubleTap() async {
    isZoomed.value = false;
    await cameraController.setZoomLevel(1.0);
  }

  Future<void> captureImage() async {
    try {
      final image = await cameraController.takePicture();
      await cameraController.setZoomLevel(1.0);
      isZoomed.value = false;
      imagePath.value = image.path;
      Get.put<ImageController>(ImageController());
      Get.to(const ImagePageView());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
      );

      await cameraController.initialize().then((value) async {
        await cameraController.startImageStream((image) => onLatestImageAvailable(image));
        ScreenParams.previewSize = cameraController.value.previewSize!;
        update();
      });
      isCameraInitialized.value = true;
      update();
    } else {
      debugPrint('Permission denied');
    }
  }

  Future<void> _initStateAsync() async {
    Detector.start().then((instance) {
      _detector = instance;
      _subscription = instance.resultsStream.stream.listen((values) {
        results = values['recognitions'];
        update();
      });
    });
  }

  Future<void> onSingleTapped(Recognition result) async {
    double objectWidth = result.location.width;
    double objectHeight = result.location.height;
    double maxObjectSize = 240.0;
    double zoomLevel = 1.0 + ((objectWidth + objectHeight) / (2 * maxObjectSize));

    isZoomed.value = true;
    await cameraController.setZoomLevel(zoomLevel);
    singleTappedObject = result;
    update();
  }

  Future<void> resetZoom() async {
    isZoomed.value = false;
    await cameraController.setZoomLevel(1.0);
  }

  Future<void> onLatestImageAvailable(CameraImage cameraImage) async {
    frameCount.value++;

    if (frameCount.value % 10 == 0) {
      frameCount.value = 0;

      _detector!.processFrame(cameraImage);

      if (results != null && results!.isNotEmpty && !isZoomed.value) {
        Recognition? firstObject;
        if (results!.length > 1) {
          firstObject = singleTappedObject;
        } else {
          firstObject = results!.first;
        }
        double objectWidth = firstObject!.location.width;
        double objectHeight = firstObject.location.height;

        double maxObjectSize = 240.0;
        double zoomLevel = 1.0 + ((objectWidth + objectHeight) / (2 * maxObjectSize));

        isZoomed.value = true;
        await cameraController.setZoomLevel(zoomLevel);
        singleTappedObject = firstObject;
        update();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController.stopImageStream();
        _detector?.stop();
        _subscription?.cancel();
        break;
      case AppLifecycleState.resumed:
        _initStateAsync();
        break;
      default:
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    _detector?.stop();
    _subscription?.cancel();
    super.onClose();
  }
}
