class SearchResults {
  final String type;
  final List<Feature> features;
  final List<String> query;
  final String attribution;

  SearchResults(
      {required this.type,
      required this.features,
      required this.query,
      required this.attribution});

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
        type: json['type'],
        features: List<Feature>.from(
            json['features'].map((x) => Feature.fromJson(x))),
        query: List<String>.from(json['query'].map((x) => x as String)),
        attribution: json['attribution'],
      );
}

class Feature {
  final String id;
  final String text;
  final String type;
  final FeatureProperties properties;
  final dynamic geometry; // This could be PointObject, LineStringObject, etc.
  final BoundingBox bbox;
  final Coordinates center;
  final String? placeName;
  final List<String> placeType;
  final double relevance;
  final List<ContextObject>? context;
  final String? address;

  Feature({
    required this.id,
    required this.text,
    required this.type,
    required this.properties,
    required this.geometry,
    required this.bbox,
    required this.center,
    required this.placeName,
    required this.placeType,
    required this.relevance,
    required this.context,
    required this.address,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json['id'],
        text: json['text'],
        type: json['type'],
        properties: FeatureProperties.fromJson(json['properties']),
        geometry: json[
            'geometry'], // You need to handle different geometry types here
        bbox: BoundingBox.fromJson(json['bbox']),
        center: Coordinates.fromJson(json['center']),
        placeName: json['place_name'],
        placeType:
            List<String>.from(json['place_type'].map((x) => x as String)),
        relevance: json['relevance'].toDouble(),
        context: json['context'] != null
            ? List<ContextObject>.from(
                json['context'].map((x) => ContextObject.fromJson(x)))
            : null,
        address: json['address'],
      );
}

class FeatureProperties {
  final String ref;
  final String country_code;
  final String? kind;
  final List<String>? categories;
  final OSMTagsObject? osmTags;
  final String? osmPlaceType;
  final String? name;

  FeatureProperties({
    required this.ref,
    required this.country_code,
    required this.kind,
    required this.categories,
    required this.osmTags,
    required this.osmPlaceType,
    this.name,
  });

  factory FeatureProperties.fromJson(Map<String, dynamic> json) =>
      FeatureProperties(
        ref: json['ref'],
        country_code: json['country_code'],
        kind: json['kind'],
        categories: json['categories'] != null
            ? List<String>.from(json['categories'].map((x) => x as String))
            : [],
        osmTags: json['osm:tags'] != null
            ? OSMTagsObject.fromJson(json['osm:tags'])
            : null,
        osmPlaceType: json['osm:place_type'],
        name: json['name'],
      );
}

class BoundingBox {
  final double west;
  final double south;
  final double east;
  final double north;

  BoundingBox(
      {required this.west,
      required this.south,
      required this.east,
      required this.north});

  factory BoundingBox.fromJson(List<dynamic> json) => BoundingBox(
        west: json[0].toDouble(),
        south: json[1].toDouble(),
        east: json[2].toDouble(),
        north: json[3].toDouble(),
      );
}

class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates({required this.longitude, required this.latitude});

  factory Coordinates.fromJson(List<dynamic> json) => Coordinates(
        longitude: json[0].toDouble(),
        latitude: json[1].toDouble(),
      );

  List<double> toJson() => [longitude, latitude];
}

class ContextObject {
  final String id;
  final String text;
  final String? language;
  final String? type;
  final Map<String, String> languageTexts; // Assuming multiple language texts

  ContextObject({
    required this.id,
    required this.text,
    required this.language,
    required this.type,
    required this.languageTexts,
  });

  factory ContextObject.fromJson(Map<String, dynamic> json) {
    // Parsing language-specific texts
    Map<String, String> languageTexts = {};
    json.forEach((key, value) {
      if (key.startsWith('^text_')) {
        languageTexts[key] = value;
      }
    });

    return ContextObject(
      id: json['id'],
      text: json['text'],
      language: json['language'],
      type: json['type'],
      languageTexts: languageTexts,
    );
  }
}

class OSMTagsObject {
  // (experimental) Feature tags from OpenStreetMap. Only available for poi type.
  final String name;
  // final String amenity;
  // final String highway;

  OSMTagsObject({
    required this.name,
    // required this.amenity,
    // required this.highway,
  });

  factory OSMTagsObject.fromJson(Map<String, dynamic> json) => OSMTagsObject(
        name: json['name'] ?? '',
        // amenity: json['amenity'] ?? '',
        // highway: json['highway'] ?? '',
      );
}


// Define other geometrical types like PointObject, LineStringObject, etc.

