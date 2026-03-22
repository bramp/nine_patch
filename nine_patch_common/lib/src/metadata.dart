import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:nine_patch_common/src/point_converter.dart';
import 'package:nine_patch_common/src/rectangle_converter.dart';

part 'metadata.g.dart';

/// Metadata for a nine-patch image.
@immutable
@JsonSerializable(includeIfNull: false)
class NinePatchMetadata {
  /// Create metadata for a nine-patch image.
  const NinePatchMetadata({
    required this.stretch,
    required this.contents,
    this.dimensions,
    this.name,
    this.scale,
  });

  /// Create a [NinePatchMetadata] from a JSON map.
  factory NinePatchMetadata.fromJson(Map<String, dynamic> json) =>
      _$NinePatchMetadataFromJson(json);

  /// The stretch rectangle.
  @RectangleIntConverter()
  final Rectangle<int> stretch;

  /// The contents padding / fill rectangle.
  @RectangleIntConverter()
  final Rectangle<int> contents;

  // TODO(bramp): Add support for optical bounds
  // final Rectangle<int> optical;

  /// Optional dimensions of the image.
  @PointIntConverter()
  final Point<int>? dimensions;

  /// Optional name of the associated image file.
  final String? name;

  /// Optional scale of the image.
  ///
  /// Useful if for example the original image was not 1x scale, but the image
  /// has been resized, this allows us to normalise the rectangles.
  final double? scale;

  /// Convert the metadata to a JSON map.
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
      'NinePatchMetadata(stretch: $stretch, content: $contents, dimensions: $dimensions, name: $name, scale: $scale)';
}
