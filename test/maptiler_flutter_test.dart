import 'package:maptiler_flutter/maptiler_flutter.dart';
import 'package:test/test.dart';
import 'api_key.dart';

void main() {
  group('CoordinatesAPI', () {
    setUp(() {
      MapTilerConfig.setApiKey(apiKey);
    });

    test('searchCoordinates', () async {
      final res = await MapTiler.coordinatesAPI.searchCoordinates("new york");
      expect(res.results.isNotEmpty, isTrue);
    });
  });
  group('GeolocationAPI', () {
    setUp(() {
      MapTilerConfig.setApiKey(apiKey);
    });

    test('getIPGeolocation', () async {
      final res = await MapTiler.geolocationAPI.getIPGeolocation();
      expect(res.city.isNotEmpty, isTrue);
    });
  });
  group('GeocodingAPI', () {
    setUp(() {
      MapTilerConfig.setApiKey(apiKey);
    });

    test('searchByName', () async {
      final res = await MapTiler.geocodingAPI.searchByName("new york");
      expect(res.features.isNotEmpty, isTrue);
    });
  });
}
