import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

/// [JsonConverter] for [Rectangle].
class RectangleConverter<T extends num>
    implements JsonConverter<Rectangle<T>, Map<String, dynamic>> {
  /// Create a [RectangleConverter].
  const RectangleConverter();

  @override
  Rectangle<T> fromJson(Map<String, dynamic> json) => _fromJson(json);

  @override
  Map<String, dynamic> toJson(Rectangle<T> rect) => _toJson(rect);

  static Rectangle<T> _fromJson<T extends num>(Map<String, dynamic> json) =>
      Rectangle(
        json['x'] as T,
        json['y'] as T,
        json['width'] as T,
        json['height'] as T,
      );

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
  /// Create a [RectangleIntConverter].
  const RectangleIntConverter();
}
