// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NinePatchMetadata _$NinePatchMetadataFromJson(Map<String, dynamic> json) =>
    NinePatchMetadata(
      stretch: const RectangleIntConverter()
          .fromJson(json['stretch'] as Map<String, dynamic>),
      contents: const RectangleIntConverter()
          .fromJson(json['contents'] as Map<String, dynamic>),
      dimensions: _$JsonConverterFromJson<Map<String, dynamic>, Point<int>>(
          json['dimensions'], const PointIntConverter().fromJson),
      name: json['name'] as String?,
      scale: (json['scale'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NinePatchMetadataToJson(NinePatchMetadata instance) {
  final val = <String, dynamic>{
    'stretch': const RectangleIntConverter().toJson(instance.stretch),
    'contents': const RectangleIntConverter().toJson(instance.contents),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'dimensions',
      _$JsonConverterToJson<Map<String, dynamic>, Point<int>>(
          instance.dimensions, const PointIntConverter().toJson));
  writeNotNull('name', instance.name);
  writeNotNull('scale', instance.scale);
  return val;
}

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
