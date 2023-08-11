import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nine_patch_common/nine_patch_common.dart' as common;
import 'package:path/path.dart' as path;

final _log = Logger('nine_patch_image.dart');

class NinePatchMetadata {
  /// The dimensions of the image (in logical pixels).
  final Size dimensions;

  /// The middle area for scaling (in logical pixels).
  final Rect scalableArea;

  /// The insets from the edge to nest child widgets within (in logical pixels).
  final EdgeInsets fillArea;

  NinePatchMetadata({
    required this.dimensions,
    required this.scalableArea,
    required this.fillArea,
  })  : assert(!dimensions.isEmpty, 'dimensions must not be empty.'),
        assert(
            scalableArea.left < scalableArea.right &&
                scalableArea.top < scalableArea.bottom,
            'DecorationImage does not like it when the scalable area is empty '
            '(or worse negative). While I think that\'s a valid Nine Patch, '
            'because you don\'t scale in that direction, it\'s not supported '
            'by Flutter.');

  // Create a Flutter NinePatchMetadata from the
  // nine_patch_common.NinePatchMetadata. This types are subtly different as
  // nine_patch_common does not depend on flutter, and thus doesn't have the
  // flutter/dart:ui types. We convert to the appropriate types here to aid in
  // rendering.
  NinePatchMetadata.from(common.NinePatchMetadata metadata)
      : this(
          dimensions:
              _sizeFromPoint(metadata.dimensions!) / (metadata.scale ?? 1.0),
          scalableArea: _rectFromRectangle(metadata.stretch,
              scale: metadata.scale ?? 1.0),
          fillArea: _edgeInsetsFromRectangle(
                  metadata.contents, metadata.dimensions!) /
              (metadata.scale ?? 1.0),
        );

  static Size _sizeFromPoint(Point<int> size) {
    return Size(size.x.toDouble(), size.y.toDouble());
  }

  static Rect _rectFromRectangle(Rectangle<int> rect, {double scale = 1.0}) {
    return Rect.fromLTWH(
        rect.left.toDouble() / scale,
        rect.top.toDouble() / scale,
        rect.width.toDouble() / scale,
        rect.height.toDouble() / scale);
  }

  static EdgeInsets _edgeInsetsFromRectangle(
      Rectangle<int> rect, Point<int> size) {
    return EdgeInsets.fromLTRB(rect.left.toDouble(), rect.top.toDouble(),
        (size.x - rect.right).toDouble(), (size.y - rect.bottom).toDouble());
  }

  @override
  bool operator ==(Object other) =>
      other is NinePatchMetadata &&
      dimensions == other.dimensions &&
      scalableArea == other.scalableArea &&
      fillArea == other.fillArea;

  @override
  int get hashCode => Object.hash(dimensions, scalableArea, fillArea);

  @override
  String toString() =>
      "NinePatchMetadata(dimensions: $dimensions, scalableArea: $scalableArea, fillArea: $fillArea)";
}

// A nine patch widget.
// TODO Figure out how to test widgets.
// TODO Create a way to ensure metadata is loaded before the widget is built.
class NinePatchImage extends StatelessWidget {
  final ImageProvider image;
  final NinePatchMetadata metadata;

  /// Outside margin for the box.
  final EdgeInsetsGeometry? margin;

  /// Inside padding for the box.
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  // Create a new nine-patch image from a image (without the nine-patch border)
  // and metadata.
  const NinePatchImage({
    super.key,
    required this.image,
    required this.metadata,
    this.margin,
    this.padding,
    this.child,
  });

  // Borrowed from flutter/3.10.6/flutter/packages/flutter/lib/src/widgets/image.dart
  // TODO Add a errorBuilder parameter, similar to Image.
  static Widget _debugBuildErrorWidget(BuildContext context, Object error) {
    _log.severe(error);

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        const Positioned.fill(
          child: Placeholder(
            color: Color(0xCF8D021F),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: FittedBox(
            child: Text(
              '$error',
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                shadows: <Shadow>[
                  Shadow(blurRadius: 1.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Create a new nine-patch image from a `.9.json` asset.
  ///
  /// The [bundle] argument may be null, in which case the [rootBundle] is used.
  ///
  /// The [package] argument must be non-null when fetching an asset that is
  /// included in a package.
  static Widget fromAssetMetadata({
    Key? key,
    required String name,
    AssetBundle? bundle,
    String? package,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Widget? child,
  }) {
    assert(name.endsWith('.9.json'),
        "We expect nine-patch metadata, which should end in '.9.json'.");

    final keyName = package == null ? name : 'packages/$package/$name';
    final metadataFile = (bundle ?? rootBundle).loadString(keyName);

    // We can't read the metadata asset synchronously, so we have to return a
    // FutureBuilder.
    return FutureBuilder(
      future: metadataFile,
      builder: (context, snapshot) {
        // handle errors
        if (snapshot.hasError) {
          return _debugBuildErrorWidget(context,
              'Error loading metadata for $keyName: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          // TODO Some kind of loading widget. What does Image do?
          return const Placeholder();
        }

        final metadata =
            common.NinePatchMetadata.fromJson(json.decode(snapshot.data!));

        if (metadata.name == null) {
          // TODO We could just guess the name.
          return _debugBuildErrorWidget(context,
              'Missing nine-patch image name in metadata for $keyName');
        }

        // Assume the image is in the same directory as the metadata.
        final p = path.Context(style: path.Style.posix);
        final imageName = p.join(p.dirname(keyName), metadata.name);

        return NinePatchImage(
          key: key,
          image: AssetImage(imageName),
          metadata: NinePatchMetadata.from(metadata),
          margin: margin,
          padding: padding,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scalable = metadata.scalableArea;
    final fill = metadata.fillArea;

    final minWidth =
        scalable.left + (metadata.dimensions.width - scalable.right);
    final minHeight =
        scalable.top + (metadata.dimensions.height - scalable.bottom);

    final img = Container(
      margin: margin,
      constraints: BoxConstraints(
        minWidth: minWidth,
        minHeight: minHeight,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: image,
          centerSlice: scalable,
        ),
      ),
      padding: padding != null ? fill.add(padding!) : fill,
      child: child,
    );

    // ignore: dead_code
    if (false && kDebugMode) {
      // When in debug mode, do some extra bounds checking.
      return LayoutBuilder(
        builder: (context, constraints) {
          // TODO(https://github.com/flutter/flutter/issues/27827) Fixes these issues

          final right = metadata.dimensions.width - scalable.right;
          assert(
              minWidth < constraints.maxWidth,
              'The parent must be wider than the scalable area.\n'
              'Parent width: ${constraints.maxWidth}\n'
              'Scalable left: ${scalable.left}\n'
              'Scalable right: $right');

          final bottom = metadata.dimensions.height - scalable.bottom;
          assert(
              minHeight < constraints.maxHeight,
              'The parent must be taller than the scalable area.\n'
              'Parent height: ${constraints.maxHeight}\n'
              'Scalable top: ${scalable.top}\n'
              'Scalable bottom: $bottom');

          _log.info('NinePatchImage: $image, Constraints: $constraints, '
              'Left: ${scalable.left}, Right: $right, Top: ${scalable.top}, Bottom: $bottom');

          return img;
        },
      );
    }

    return img;
  }
}
