# Repositories

## Overview

The repository pattern in FreshLeaf provides an abstraction layer between controllers and API services. This ensures clean separation of concerns, easier testing, and consistent data handling across the application.

## Architecture

```
lib/core/
├── repositories/           # Data access layer
│   ├── home_repository.dart
│   ├── product_repository.dart
│   └── location_repository.dart
├── services/              # Core services
│   └── api_client.dart
└── models/               # Data models
```

## Why Use Repositories?

1. **Separation of Concerns** - Controllers focus on UI logic, repositories handle data fetching
2. **Testability** - Easy to mock repositories for unit testing
3. **Consistency** - Centralized error handling and data transformation
4. **Reusability** - Same data operations can be used across multiple controllers
5. **Mock Data Support** - Fallback mock data for development without API

## Repository Structure

### Base Pattern

```dart
class SomeRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // API call with error handling
  Future<List<Model>> fetchData() async {
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.endpoint);
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        return data?.map((json) => Model.fromMap(json)).toList() ?? [];
      }
      return _fallbackData();
    } catch (e) {
      return _fallbackData();
    }
  }

  // Fallback data for development/offline
  List<Model> _fallbackData() { ... }
}
```

## Available Repositories

### HomeRepository

Handles home screen data fetching including categories and featured products.

```dart
// lib/core/repositories/home_repository.dart
class HomeRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<HomeCategory>> getCategories() async {
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.homeCategories);
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        if (data != null) {
          return data.map((json) => HomeCategory.fromMap(json)).toList();
        }
      }
      return getMockCategories();
    } catch (e) {
      return getMockCategories();
    }
  }

  Future<List<HomeProduct>> getFeaturedProducts() async {
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.homeProducts);
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        if (data != null) {
          return data.map((json) => HomeProduct.fromMap(json)).toList();
        }
      }
      return getMockProducts();
    } catch (e) {
      return getMockProducts();
    }
  }

  // Mock data for development
  List<HomeCategory> getMockCategories() => [...];
  List<HomeProduct> getMockProducts() => [...];
}
```

**Usage in Controller:**

```dart
class HomeController extends GetxController {
  final HomeRepository _homeRepository = HomeRepository();

  final RxList<HomeCategory> categories = <HomeCategory>[].obs;
  final RxList<HomeProduct> pickedThisMorning = <HomeProduct>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      final results = await Future.wait([
        _homeRepository.getCategories(),
        _homeRepository.getFeaturedProducts(),
      ]);

      categories.value = results[0] as List<HomeCategory>;
      pickedThisMorning.value = results[1] as List<HomeProduct>;
    } catch (e) {
      categories.value = _homeRepository.getMockCategories();
      pickedThisMorning.value = _homeRepository.getMockProducts();
    }
  }
}
```

### ProductRepository

Handles product-related operations including organic products, search, and wishlist.

```dart
// lib/core/repositories/product_repository.dart
class ProductRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<OrganicProduct>> getOrganicProducts({
    int page = 1,
    int limit = 20,
    int? categoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }

      final response = await _apiClient.getRequest(
        ApiEndpoints.organicProducts,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        return data?.map((json) => OrganicProduct.fromMap(json)).toList() ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<OrganicProduct?> getOrganicProductDetail(int productId) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.organicProductDetail.replaceAll('{id}', productId.toString()),
      );

      if (response.statusCode == 200 && response.data != null) {
        return OrganicProduct.fromMap(response.data!['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<ProductInfo>> searchProducts(String query, {int limit = 20}) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.search,
        queryParameters: {'q': query, 'limit': limit},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        return data?.map((json) => ProductInfo.fromMap(json)).toList() ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Wishlist operations
  Future<List<ProductInfo>> getWishlist() async { ... }
  Future<bool> addToWishlist(int productId) async { ... }
  Future<bool> removeFromWishlist(int productId) async { ... }
}
```

### LocationRepository

Handles geocoding and reverse geocoding for location services.

```dart
// lib/core/repositories/location_repository.dart
class LocationResult {
  final String? name;
  final String? region;
  final String? country;

  LocationResult({this.name, this.region, this.country});
  bool get hasLocation => name != null && name!.isNotEmpty;
}

class LocationRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<LocationResult> reverseGeocode(
    double latitude,
    double longitude, {
    String language = 'en',
  }) async {
    try {
      final response = await _apiClient.externalRequest<Map<String, dynamic>>(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: <String, dynamic>{
          'format': 'jsonv2',
          'lat': latitude,
          'lon': longitude,
          'zoom': 18,
          'addressdetails': 1,
          'accept-language': language == 'km' ? 'km' : 'en',
        },
        options: Options(
          headers: <String, String>{'User-Agent': 'FreshLeaf/1.0'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>?;

        if (address != null) {
          final primary = _firstNonEmpty([
            address['suburb']?.toString(),
            address['village']?.toString(),
            address['town']?.toString(),
            address['city']?.toString(),
            address['municipality']?.toString(),
          ]);
          final region = _firstNonEmpty([
            address['state']?.toString(),
            address['country']?.toString(),
          ]);

          return LocationResult(name: primary, region: region);
        }
      }
      return LocationResult();
    } catch (e) {
      return LocationResult();
    }
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}
```

## Creating New Repositories

When adding a new data source, create a repository following this pattern:

1. Create file in `lib/core/repositories/`
2. Name it `{feature}_repository.dart`
3. Inject `ApiClient` via GetX
4. Implement async methods returning Future data
5. Include mock/fallback data for development
6. Use in controllers via dependency injection

```dart
// lib/core/repositories/new_feature_repository.dart
class NewFeatureRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<DataType> fetchData() async {
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.newFeature);
      // Parse and return data
      return DataType.fromMap(response.data!['data']);
    } catch (e) {
      // Return fallback or rethrow
      return getMockData();
    }
  }

  DataType getMockData() => DataType(...);
}
```

## Best Practices

1. **Always use repositories** for API calls in controllers
2. **Handle errors gracefully** - return fallback data or empty lists
3. **Include mock data** for development without backend
4. **Keep repositories focused** - one repository per feature domain
5. **Use Future.wait** for parallel data fetching

---

## Related Files

- `lib/core/repositories/` - All repository implementations
- `lib/core/services/api_client.dart` - HTTP client
- `lib/core/constants/api_endpoints.dart` - API endpoints
- `lib/app/modules/home/controllers/home_controller.dart` - Usage example