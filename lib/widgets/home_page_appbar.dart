import 'package:flutter/material.dart';
import 'package:qualification/controllers/home_controller.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController controller;
  const HomePageAppBar({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Zooming Cam'),
      leading: IconButton(
        onPressed: () {
          controller.zoomOutButton();
        },
        icon: const Icon(Icons.zoom_out),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
