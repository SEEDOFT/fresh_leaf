# Module Structure

## Standard Module Template

Each feature module in `lib/app/modules/` should follow this structure:

```
module_name/
├── bindings/
│   └── module_name_binding.dart
├── controllers/
│   └── module_name_controller.dart
├── views/
│   ├── module_name_view.dart
│   └── module_name_view2.dart (if needed)
└── widgets/
    ├── module_widget_1.dart
    └── module_widget_2.dart (if module has specific widgets)
```

## File Structure Details

### Binding
```dart
// bindings/module_name_binding.dart
class ModuleNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleNameController>(() => ModuleNameController());
  }
}
```

### Controller
```dart
// controllers/module_name_controller.dart
class ModuleNameController extends GetxController {
  // Observables
  final Rx<Type> data = Type().obs;
  
  // Lifecycle
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
  
  // Methods
  Future<void> fetchData() async { ... }
}
```

### View
```dart
// views/module_name_view.dart
class ModuleNameView extends GetView<ModuleNameController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.data.value),
    );
  }
}
```

### Module-Specific Widgets
```dart
// widgets/module_specific_widget.dart
class ModuleSpecificWidget extends StatelessWidget {
  const ModuleSpecificWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## Module Naming Conventions

| Type | Naming | Example |
|------|--------|---------|
| Feature module | snake_case | `product_detail`, `wallet_top_up` |
| Controller | PascalCase | `ProductDetailController` |
| Binding | PascalCase | `ProductDetailBinding` |
| View | snake_case_view | `product_detail_view.dart` |
| Widget | snake_case_*.dart | `product_price_widget.dart` |

## Common Modules Structure

All existing modules follow the same pattern:
- `ai_assistant/`
- `cart/`
- `checkout/`
- `dashboard/`
- `home/`
- `login/`
- `notifications/`
- `onboarding/`
- `order_detail/`
- `orders/`
- `product_detail/`
- `product_list/`
- `profile/`
- `register/`
- `search/`
- `splash/`
- `support_chat/`
- `wallet/`
- `wallet_top_up/`
- `wallet_top_up_payment/`
- `wallet_top_up_saved_cards/`

## Best Practices

1. **Always use bindings** for dependency injection
2. **Keep controllers focused** - one controller per feature
3. **Extract widgets** - reusable UI goes in `shared/widgets/`
4. **Module-specific widgets** - only if used exclusively in that module
5. **Follow naming conventions** consistently