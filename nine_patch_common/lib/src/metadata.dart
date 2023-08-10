import 'dart:math';
import 'package:json_annotation/json_annotation.dart';

import 'rectangle_converter.dart';
import 'point_converter.dart';

part 'metadata.g.dart';

@JsonSerializable(includeIfNull: false)
class NinePatchMetadata {
  // The stretch rectangle.
  @RectangleIntConverter()
  final Rectangle<int> stretch;

  // The contents padding / fill rectangle.
  @RectangleIntConverter()
  final Rectangle<int> contents;

  // TODO Add support for optical bounds
  // final Rectangle<int> optical;

  @PointIntConverter()
  // Optional dimensions of the image.
  final Point<int>? dimensions;

  // Optional name of the associated image file.
  final String? name;

  // Optional scale of the image.
  // Useful if for example the original image was not 1x scale, but the image
  // has been resized, this allows us to normalise the rectangles.
  final double? scale;

  NinePatchMetadata({
    required this.stretch,
    required this.contents,
    this.dimensions,
    this.name,
    this.scale,
  });

  factory NinePatchMetadata.fromJson(Map<String, dynamic> json) =>
      _$NinePatchMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$NinePatchMetadataToJson(this);

  @override
  bool operator ==(Object other) =>
      other is NinePatchMetadata &&
      stretch == other.stretch &&
      contents == other.contents &&
      dimensions == other.dimensions &&
      name == other.name &&
      scale == other.scale;

  @override
  int get hashCode => Object.hash(stretch, contents, dimensions, name, scale);

  @override
  String toString() =>
      "NinePatchMetadata(stretch: $stretch, content: $contents, dimensions: $dimensions, name: $name, scale: $scale)";
}
