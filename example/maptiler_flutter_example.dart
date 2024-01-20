import 'package:maptiler_flutter/maptiler_flutter.dart';

void main() async {
  MapTilerConfig.setApiKey('YOUR_MAPTILER_API_KEY');

  try {
    var searchResults = await MapTiler.geocodingAPI.searchByName("Zurich");
    print(searchResults);
  } catch (e) {
    print(e);
  }
}
