import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fresh_leaf/app/routes/app_pages.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/env/.env.local");
  await GetStorage.init();
  await _initServices();
  runApp(const MainApp());
}

// Initialize services
Future<void> _initServices() async {
  Get.put<StorageService>(StorageService(), permanent: true);
  Get.put<ApiClient>(
    ApiClient(storageService: Get.find<StorageService>()),
    permanent: true,
  );
  Get.put<AiChatStorageService>(AiChatStorageService(), permanent: true);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.onboarding,
      getPages: AppPages.pages,
    );
  }
}
