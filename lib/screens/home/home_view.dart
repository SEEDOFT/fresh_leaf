import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'home_binding.dart';
part 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      body: const Center(
        child: Text('This is the Home view'),
      ),
    );
  }
}