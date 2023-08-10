import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

class RectangleConverter<T extends num>
    implements JsonConverter<Rectangle<T>, Map<String, dynamic>> {
  const RectangleConverter();

  @override
  Rectangle<T> fromJson(Map<String, dynamic> json) => _fromJson(json);

  @override
  Map<String, dynamic> toJson(Rectangle<T> rect) => _toJson(rect);

  static Rectangle<T> _fromJson<T extends num>(Map<String, dynamic> json) =>
      Rectangle(json['x'], json['y'], json['width'], json['height']);

  static Map<String, dynamic> _toJson<T extends num>(Rectangle<T> rect) => {
        'x': rect.left,
        'y': rect.top,
        'width': rect.width,
        'height': rect.height,
      };
}

// Implementation of RectangleConverter for int, because json_serializable
// doesn't support generic JsonConverters.
class RectangleIntConverter extends RectangleConverter<int> {
  const RectangleIntConverter();
}
