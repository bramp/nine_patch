import 'dart:convert';

import 'package:image/image.dart';
import 'package:nine_patcher/nine_patcher.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

// Parses the scale from a path like '/blah/Nx/image.9.png'.
// Returns null if the scale is not present.
double? scaleFromPath(String path) {
  RegExp exp = RegExp(r'/([\d\.]+)x/[^/]*$');
  RegExpMatch? match = exp.firstMatch(path);

  return match != null ? double.tryParse(match[1]!) : null;
}

// Turns a name like '/blah/image.9.png' into 'image.png'.
// If the name does not end in '.9.png', the basename is returned unchanged.
String baseNameWithNewExtension(input) {
  return path
      .basename(input)
      .replaceFirstMapped(RegExp(r'\.9(\.[^\.]+)$'), (m) => m[1]!);
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: nine_patcher <path to 9-patch image> [output directory]');
    return;
  }

  final input = path.absolute(args[0]);
  final output = args.length == 2 ? args[1] : path.dirname(input);

  if (!await Directory(output).exists()) {
    print('Output directory "$output" does not exist.');
    return;
  }

  final outputImage = path.join(output, baseNameWithNewExtension(input));

  if (path.equals(input, outputImage)) {
    print('Input and output filenames are the same.');
    return;
  }

  // Decode the image file at the given path
  final image = await decodeImageFile(input);
  if (image == null) {
    print('Unable to decode image "$input".');
    return;
  }

  // Now extract the 9-patch metadata from the image
  final np = NinePatchImage.fromImage(
    image,

    // Optional metadata
    name: path.basename(outputImage),
    scale: scaleFromPath(input),
  );

  // Now save the naked image, and metadata
  print('Writing image to "$outputImage".');
  final success = await encodeImageFile(outputImage, np.image);
  if (!success) {
    // TODO Get better errors :/
    print('Unable to encode image "$outputImage".');
    return;
  }

  final outputJson = path.setExtension(outputImage, '.9.json');
  print('Writing metadata to "$outputJson".');
  final File file = File(outputJson);
  await file.writeAsString(jsonEncode(np.metadata));

  print("$np");
}
