import 'dart:convert';
import 'dart:math';

import 'package:nine_patch_common/nine_patch_common.dart';
import 'package:test/test.dart';

void main() {
  test('json_serialise (minimal)', () {
    final expected = NinePatchMetadata(
      stretch: Rectangle(54, 90, 272, 231),
      contents: Rectangle(26, 29, 332, 323),
    );
    final encoded = jsonEncode(expected);

    // TODO Make this test less fragile to the ordering of the json document.
    expect(encoded,
        '{"stretch":{"x":54,"y":90,"width":272,"height":231},"contents":{"x":26,"y":29,"width":332,"height":323}}');

    Map<String, dynamic> metadataMap = jsonDecode(encoded);
    var actual = NinePatchMetadata.fromJson(metadataMap);

    expect(actual, equals(expected));
  });

  test('json_serialise (full)', () {
    final expected = NinePatchMetadata(
      stretch: Rectangle(54, 90, 272, 231),
      contents: Rectangle(26, 29, 332, 323),
      dimensions: Point(380, 380),
      name: "image.png",
      scale: 2.0,
    );
    final encoded = jsonEncode(expected);

    // TODO Make this test less fragile to the ordering of the json document.
    expect(encoded,
        '{"stretch":{"x":54,"y":90,"width":272,"height":231},"contents":{"x":26,"y":29,"width":332,"height":323},"dimensions":{"x":380,"y":380},"name":"image.png","scale":2.0}');

    Map<String, dynamic> metadataMap = jsonDecode(encoded);
    var actual = NinePatchMetadata.fromJson(metadataMap);

    expect(actual, equals(expected));
  });
}
