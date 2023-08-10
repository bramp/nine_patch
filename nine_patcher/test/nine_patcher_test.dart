import 'package:test/test.dart';

import '../bin/nine_patcher.dart';

void main() {
  group('scaleFromPath', () {
    var inputsToExpected = {
      '/image.png': null,
      '/4x/image.png': 4,
      '/4.0x/image.png': 4,
      '/4.0.x/image.png': null,
      '/1/image.png': null,
    };
    inputsToExpected.forEach((input, expected) {
      test("$input -> $expected", () {
        expect(scaleFromPath(input), expected);
      });
    });
  });

  group('baseNameWithNewExtension', () {
    var inputsToExpected = {
      // Expect a replacement
      'image.9.png': 'image.png',
      '/blah/blah/blah/image.9.png': 'image.png',
      '/image.9.png/image.9.png': 'image.png',
      '/image.1.2.9.png': 'image.1.2.png',

      // We actually support all image formats (even if the original spec says pngs)
      '/image.9.gif': 'image.gif',

      // Expect the same
      '/image.png': 'image.png',
      '/image.1.png': 'image.1.png',
      '/image.9.png/image.1.png': 'image.1.png',
      '/image.1.gif': 'image.1.gif',
      '/image.9.1.2.png': 'image.9.1.2.png',
    };
    inputsToExpected.forEach((input, expected) {
      test("$input -> $expected", () {
        expect(baseNameWithNewExtension(input), expected);
      });
    });
  });
}
