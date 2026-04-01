import 'package:fresh_leaf/app/modules/{{name.snakeCase()}}/controllers/{{name.snakeCase()}}_controller.dart';|
import 'package:get/get.dart';

class {{name.pascalCase()}}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<{{name.pascalCase()}}Controller>(
      {{name.pascalCase()}}Controller.new,
    );
  }
}