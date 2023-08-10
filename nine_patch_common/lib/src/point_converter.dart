import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

class PointConverter<T extends num>
    implements JsonConverter<Point<T>, Map<String, dynamic>> {
  const PointConverter();

  @override
  Point<T> fromJson(Map<String, dynamic> json) => _fromJson(json);

  @override
  Map<String, dynamic> toJson(Point<T> p) => _toJson(p);

  static Point<T> _fromJson<T extends num>(Map<String, dynamic> json) =>
      Point(json['x'], json['y']);

  static Map<String, dynamic> _toJson<T extends num>(Point<T> p) => {
        'x': p.x,
        'y': p.y,
      };
}

// Implementation of PointConverter for int, because json_serializable
// doesn't support generic JsonConverters.
class PointIntConverter extends PointConverter<int> {
  const PointIntConverter();
}
