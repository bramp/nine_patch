import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine_patch/nine_patch.dart';
import 'package:nine_patch_common/nine_patch_common.dart' as common;

void main() {
  test('scale', () {
    final src = common.NinePatchMetadata(
      dimensions: const Point(100, 100),
      stretch: const Rectangle(25, 33, 33, 50),
      contents: const Rectangle(10, 20, 80, 40),
      name: "image.png",
      scale: 2.0,
    );

    final actual = NinePatchMetadata.from(src);
    final expected = NinePatchMetadata(
      dimensions: const Size(50, 50),
      scalableArea: const Rect.fromLTWH(12.5, 16.5, 16.5, 25),
      fillArea: const EdgeInsets.fromLTRB(5, 10, 5, 20),
    );

    expect(actual, equals(expected));
  });
}
