import 'package:dio/dio.dart' as dio;
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class LocationResult {
  LocationResult({this.name, this.region, this.country});
  final String? name;
  final String? region;
  final String? country;

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
        options: dio.Options(
          headers: <String, String>{'User-Agent': 'FreshLeaf/1.0'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        final address = data['address'] as Map<String, dynamic>?;

        if (address != null) {
          final primary = _firstNonEmpty([
            address['suburb']?.toString(),
            address['village']?.toString(),
            address['town']?.toString(),
            address['city']?.toString(),
            address['municipality']?.toString(),
            address['state_district']?.toString(),
          ]);
          final region = _firstNonEmpty([
            address['state']?.toString(),
            address['country']?.toString(),
          ]);

          return LocationResult(
            name: primary,
            region: region,
            country: address['country']?.toString(),
          );
        }
      }

      return LocationResult();
    } on Exception {
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
