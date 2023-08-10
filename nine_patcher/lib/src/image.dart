import 'package:image/image.dart' as img;
import 'package:nine_patch_common/nine_patch_common.dart';

import 'image_decode.dart';

/// Class to hold a nine-patch image.
class NinePatchImage {
  // The image without the nine-patch border.
  final img.Image image;

  // The metadata for the nine-patch.
  final NinePatchMetadata metadata;

  NinePatchImage(this.image, this.metadata);

  factory NinePatchImage.fromImage(img.Image image,
      {String? name, double? scale}) {
    final metadata = decodeNinePatchMetadata(image, name: name, scale: scale);

    // Strip the border
    image = img.copyCrop(
      image,
      x: 1,
      y: 1,
      width: image.width - 2,
      height: image.height - 2,
    );
    return NinePatchImage(image, metadata);
  }

  static fromFile(path) async {
    img.Image? image = await img.decodeImageFile(path);
    if (image == null) {
      // TODO How do I get a real error out of decodeImageFile :/ ?
      throw InvalidNinePatchException("Unable to decode image.");
    }

    return NinePatchImage.fromImage(image);
  }

  @override
  String toString() => "NinePatchImage($image, $metadata)";
}
