import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'login_binding.dart';
part 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login View'),
      ),
      body: const Center(
        child: Text('This is the Login view'),
      ),
    );
  }
}