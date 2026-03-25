import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/{{snakeCase name}}_controller.dart';

class {{pascalCase name}}View extends GetView<{{pascalCase name}}Controller> {
  const {{pascalCase name}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{pascalCase name}}'),
      ),
      body: const Center(
        child: Text('{{pascalCase name}} View'),
      ),
    );
  }
}