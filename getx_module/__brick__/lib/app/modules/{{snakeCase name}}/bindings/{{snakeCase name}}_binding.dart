import 'package:get/get.dart';
import '../controllers/{{snakeCase name}}_controller.dart';

class {{pascalCase name}}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<{{pascalCase name}}Controller>(
      () => {{pascalCase name}}Controller(),
    );
  }
}