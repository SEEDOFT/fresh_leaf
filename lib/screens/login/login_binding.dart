part of 'login_view.dart';

class LoginBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}