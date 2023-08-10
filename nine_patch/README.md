Flutter package for displaying nine-patch images.

by Andrew Brampton (https://bramp.net/)

## Features

Pre-process and display nine-patch images at any display resolution.

## Background

A standard nine-patch format is a PNG with a special 1 pixel border around the outside that contains the metadata for the image. 

![Example nine-patch PNG file named TextBox_Side.9.png](https://raw.githubusercontent.com/bramp/nine_patch/main/samples/2.0x/TextBox_Side.9.png)

These images can be made by numerous nine-patch editors, my favorite being [this one](https://romannurik.github.io/AndroidAssetStudio/nine-patches.html). However, this border makes it more complex to load/render the image, as well as more difficult to manage/resize the image assets (as you have to avoid resizing this 1 pixel boundary). Thus, this library decides to seperate the Image and Metadata into two files, a plain PNG file and a JSON file. The PNG can be [resized as normal to make 2.0x, 3.0x, etc](https://docs.flutter.dev/ui/assets/assets-and-images#resolution-aware), and the JSON file is scaled to the 1.0x.

<div align="center">
<table>
 <tr>
    <td>
    [samples/TextBox_Side.json](TODO)
    </td>
    <td>
    [samples/2.0x/TextBox_Side.png](TODO)
    </td>
 <tr>
    <td>
```json
{
  "stretch": {
    "x": 118,
    "y": 40,
    "width": 121,
    "height": 60
  },
  "contents": {
    "x": 19,
    "y": 18,
    "width": 248,
    "height": 101
  },
  "dimensions": {
    "x": 285,
    "y": 167
  },
  "name": "TextBox_Side.png",
  "scale": 2
}
```
    </td>
    <td>
![Example nine-patch PNG file named TextBox_Side.png](https://raw.githubusercontent.com/bramp/nine_patch/main/samples/2.0x/TextBox_Side.png)
    </td>
 </tr>
</table>
</div>

You can create the JSON metadata files easily with [https://pub.dev/packages/nine_patcher](https://pub.dev/packages/nine_patcher), as part of your build pipeline.

## Usage

To use the nine-patch image within a Flutter App, first include to dependency `flutter pub add nine_patch` or manually add to your `pubspec.yaml`:

```
dependencies:
    nine_patch: ^1.0.0
```

Then create a `NinePatchImage` widget where you need it, like so:

```dart
import 'package:nine_patch/nine_patch.dart';

...

// Create a new NinePatchImage widget
NinePatchImage.fromAssetMetadata(
    name: "image.9.json",
)
```

You can also specify children (to be within the NinePatch):

```dart
NinePatchImage.fromAssetMetadata(
    name: "image.9.json",
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10), // This is in addition to the fill area that may already be specificed in the nine-patch metadata.
    child: Center(
        child: child,
    ),
)
```

Finally, if your images/metadata are not in assets, you can provide any `ImageProvider` and create the metadata from another source:

```dart
NinePatchImage(
    image: NetworkImage("https://example.com/example.png"),
    metadata: NinePatchMetadata(...),
)
```

## TODO

[ ] Support multi-scaling area nine-patches.
[ ] Support the nine-patch metadata being stored in the PNG file itself. Currently only seperate JSON files are supported.

## Licence

The example image is from https://penzilla.itch.io/basic-gui-bundle.

This project is under BSD 3-clause:

```
BSD 3-Clause License

Copyright (c) 2023, Andrew Brampton (https://bramp.net)

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```