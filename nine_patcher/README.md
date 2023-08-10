# Nine Patcher

This creates nine-patch JSON metadata files, for use with this [Flutter package](https://pub.dev/packages/nine_patch).

## Workflow

* Create a nine-patch file at high resolution, with the appropriate nine-patch border.
* Run:

```shell
dart run nine_patcher path/to/image.9.png output/dir 
```

This will take the `image.9.png` and create two files in `output/dir`:
1. `image.png` the plain image without the nine-patch border.
2. `image.9.json` the metadata for the nine-patch border in JSON format.

If the file is of the format `path/to/Nx/image.9.png` (where Nx could be say `4x`)
then Nx is assumed to be the scale and added to the metadata to aid in rendering
resolution independent assets.

## Example

```
dart run nine_patcher examples/4.0x/box_orange_rounded.9.png
```