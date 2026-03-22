import 'package:image/image.dart' as img;
import 'package:nine_patch_common/nine_patch_common.dart';

import 'package:nine_patcher/src/image_decode.dart';

/// Class to hold a nine-patch image.
class NinePatchImage {
  /// Create a [NinePatchImage].
  NinePatchImage(this.image, this.metadata);

  /// Create a [NinePatchImage] from an [img.Image].
  factory NinePatchImage.fromImage(
    img.Image image, {
    String? name,
    double? scale,
  }) {
    final metadata = decodeNinePatchMetadata(image, name: name, scale: scale);

    // Strip the border
    final strippedImage = img.copyCrop(
      image,
      x: 1,
      y: 1,
      width: image.width - 2,
      height: image.height - 2,
    );
    return NinePatchImage(strippedImage, metadata);
  }

  /// The image without the nine-patch border.
  final img.Image image;

  /// The metadata for the nine-patch.
  final NinePatchMetadata metadata;

  /// Create a [NinePatchImage] from a file at the given [path].
  static Future<NinePatchImage> fromFile(String path) async {
    final image = await img.decodeImageFile(path);
    if (image == null) {
      // TODO(bramp): How do I get a real error out of decodeImageFile :/ ?
      throw InvalidNinePatchException('Unable to decode image.');
    }

    return NinePatchImage.fromImage(image);
  }

  @override
  String toString() => 'NinePatchImage($image, $metadata)';
}
