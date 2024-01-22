<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# MapTiler Flutter

This Flutter package provides a convenient Dart wrapper around the MapTiler Cloud API, allowing easy access to various MapTiler services like Geocoding, Coordinates, and Geolocation.

# Motivation

I started this package since I wanted to build a location selector with autocomplete functionality for [Activilit](https://activilit.com). 
I didn't want to use the google maps API since it is quite expensive and so I researched for alternatives and found MapTiler.

## Features

- Geocoding API: Forward and reverse geocoding, including batch geocoding.
- Coordinates API: Search coordinate systems and transformations.
- Geolocation API: IP-based geolocation services.
- Maps API: todo
- Static Maps API: todo
- Tiles API: todo
- Data API: todo
- Other API: todo

## Getting Started

To get started with this package, add it as a dependency in your Flutter project.

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  maptiler_flutter: ^0.1.0
```

### Import the Package
```
import 'package:maptiler_flutter/maptiler.dart';
```

### Usage
Before using the APIs, you must initialize the package with your MapTiler API key.

### Setting up API Key
```
void main() {
  MapTilerConfig.setApiKey('YOUR_MAPTILER_API_KEY');
  runApp(MyApp());
}
```

### API Usage
```
// Forward Geocoding
MapTiler.geocodingAPI.searchByName("Zurich").then((result) {
  print(result.features);
});

// Reverse Geocoding
MapTiler.geocodingAPI.searchByCoordinates(8.55, 47.36667).then((result) {
  print(result.features);
});

// Search Coordinates
MapTiler.coordinatesAPI.searchCoordinates("query").then((result) {
  print(result.results);
});

// IP Geolocation
MapTiler.geolocationAPI.getIPGeolocation().then((result) {
  print(result.city);
});
```

### Models
This package provides several models to represent the data structures used by the MapTiler API, including SearchResults, Feature, GeolocationResult, and more.

### Error Handling
The API methods throw exceptions in case of failure. Make sure to handle these appropriately in your application.

### Contributing
Contributions to the package are welcome. Please follow the standard pull request process for your contributions.

### License
This package is licensed under the MIT License.

### Disclaimer
This package is not officially affiliated with MapTiler.