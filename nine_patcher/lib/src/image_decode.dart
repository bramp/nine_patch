import 'dart:math';
import 'package:image/image.dart' hide Point;
import 'package:nine_patch_common/nine_patch_common.dart';

// TODO This currently depends on image/image. It would be useful to create
// a generic interface, and then we can have implementations based on different
// image/ui frameworks.

// Decodes a nine-patch image file at the given path.
Future<NinePatchMetadata> decodeNinePatchMetadataFile(String path) async {
  Image? image = await decodeImageFile(path);
  if (image == null) {
    throw InvalidNinePatchException("Unable to decode image.");
  }

  return decodeNinePatchMetadata(image);
}

// Decodes the given nine-patch image.
NinePatchMetadata decodeNinePatchMetadata(Image image,
    {String? name, double? scale}) {
  checkIsNinePatch(image);

  final stretch = findStretch(image);
  final content = findContentPadding(image);

  return NinePatchMetadata(
    stretch: stretch,
    contents: content,

    // Extra metadata
    dimensions: Point<int>(image.width, image.height),
    name: name,
    scale: scale,
  );
}

// Is fully black.
bool isBlack(Pixel p) => p.r == 0 && p.g == 0 && p.b == 0 && p.a == 255;

// Is fully white, or transparent.
bool isWhite(Pixel p) =>
    (p.r == 255 && p.g == 255 && p.b == 255 && p.a == 255) || p.a == 0;

// Is fully red. Used for the optical bounds.
bool isRed(Pixel p) => p.r == 255 && p.g == 0 && p.b == 0 && p.a == 255;

// Some simple helper functions
bool isNotBlack(Pixel p) => !isBlack(p);
bool isNotBlackOrWhite(Pixel p) => !(isBlack(p) || isWhite(p));
bool isNotBlackWhiteOrRed(Pixel p) => !(isBlack(p) || isWhite(p) || isRed(p));

// Return the x coord of the next pixel that matches f, or null if not found.
int? findNextX(Image image, int x, int y, bool Function(Pixel) f) {
  Pixel? p;

  for (; x < image.width; x++) {
    p = image.getPixel(x, y, p);
    if (f(p)) {
      return x;
    }
  }

  return null;
}

// Return the y coord of the next pixel that matches f, or null if not found.
int? findNextY(Image image, int x, int y, bool Function(Pixel) f) {
  Pixel? p;

  for (; y < image.height; y++) {
    p = image.getPixel(x, y, p);
    if (f(p)) {
      return y;
    }
  }

  return null;
}

void checkIsNinePatch(Image image) {
  // The image must be at least 3x3
  if (image.width < 3 || image.height < 3) {
    throw NotNinePatchException(
        "The image must be at least 3x3. Perhaps not a nine-patch image?");
  }

  // All boundary pixels should be either black, white, or red.
  if (findNextX(image, 0, 0, isNotBlackOrWhite) != null ||
      findNextY(image, 0, 0, isNotBlackOrWhite) != null ||
      findNextX(image, 0, image.height - 1, isNotBlackWhiteOrRed) != null ||
      findNextY(image, image.width - 1, 0, isNotBlackWhiteOrRed) != null) {
    throw NotNinePatchException(
        "All boundary pixels should be black, white, or red. Perhaps not a nine-patch image?");
  }

  // TODO Implement parsing the new "optical bounds", which are Red pixels made
  // up part of the content padding. The red can only be on the outside, so the
  // bottom row could look like:  RRRWWWWWWBBBBBBBRRRR

  // The four corners should be white
  if (!isWhite(image.getPixel(0, 0)) ||
      !isWhite(image.getPixel(image.width - 1, 0)) ||
      !isWhite(image.getPixel(0, image.height - 1)) ||
      !isWhite(image.getPixel(image.width - 1, image.height - 1))) {
    throw NotNinePatchException(
        "The four corners should be white. Perhaps not a nine-patch image?");
  }
}

Rectangle<int> findStretch(Image image) {
  // first row
  final stretchLeft = findNextX(image, 0, 0, isBlack);
  if (stretchLeft == null) {
    throw InvalidNinePatchException("No stretch area found along the top.");
  }

  final stretchRight =
      findNextX(image, stretchLeft + 1, 0, isNotBlack) ?? image.width - 1;
  if (findNextX(image, stretchRight + 1, 0, isBlack) != null) {
    throw UnsupportedNinePatchException(
        "Multiple stretch areas found along the top.");
  }

  // first col
  final stretchTop = findNextY(image, 0, 0, isBlack);
  if (stretchTop == null) {
    throw InvalidNinePatchException("No stretch area found along the left.");
  }

  final stretchBottom =
      findNextY(image, 0, stretchTop + 1, isNotBlack) ?? image.height - 1;

  if (findNextY(image, 0, stretchBottom + 1, isBlack) != null) {
    throw UnsupportedNinePatchException(
        "Multiple stretch areas found along the left.");
  }

  return Rectangle.fromPoints(
      Point(stretchLeft, stretchTop), Point(stretchRight, stretchBottom));
}

Rectangle<int> findContentPadding(Image image) {
  // last row
  final contentLeft = findNextX(image, 0, image.height - 1, isBlack);
  if (contentLeft == null) {
    throw InvalidNinePatchException(
        "No content padding found along the bottom.");
  }

  final contentRight =
      findNextX(image, contentLeft + 1, image.height - 1, isNotBlack) ??
          image.width - 1;
  if (findNextX(image, contentRight + 1, image.height - 1, isBlack) != null) {
    throw InvalidNinePatchException(
        "Multiple content paddings found along the bottom.");
  }

  // last col
  final contentTop = findNextY(image, image.width - 1, 0, isBlack);
  if (contentTop == null) {
    throw InvalidNinePatchException(
        "No content padding found along the right.");
  }

  final contentBottom =
      findNextY(image, image.width - 1, contentTop + 1, isNotBlack) ??
          image.height - 1;
  if (findNextY(image, image.width - 1, contentBottom + 1, isBlack) != null) {
    throw InvalidNinePatchException(
        "Multiple content paddings found along the right.");
  }

  return Rectangle.fromPoints(
      Point(contentLeft, contentTop), Point(contentRight, contentBottom));
}
