import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qualification/controllers/home_controller.dart';
import 'package:qualification/widgets/widgets.dart';

class HomePageStack extends StatelessWidget {
  final HomeController controller;
  const HomePageStack({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.results == null || controller.isZoomed.value) {
      if (kDebugMode) {
        print('SIZEDBOX SHRINK');
      }
      return const SizedBox.shrink();
    }
    return Stack(
      children: controller.results!
          .map(
            (box) => BoxWidget(
              result: box,
              onSingleTap: controller.onSingleTapped,
            ),
          )
          .toList(),
    );
  }
}
