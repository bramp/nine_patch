// Thrown when this is not a nine-patch image.
final class NotNinePatchException implements Exception {
  final String _message;
  NotNinePatchException(String message) : _message = message;

  @override
  String toString() => "NotNinePatchException: '$_message'";
}

// Thrown when there is a issue with the nine-patch image.
final class InvalidNinePatchException implements Exception {
  final String _message;
  InvalidNinePatchException(String message) : _message = message;

  @override
  String toString() => "InvalidNinePatchException: '$_message'";
}

// Thrown when this is not a supported form of nine-patch.
final class UnsupportedNinePatchException implements Exception {
  final String _message;
  UnsupportedNinePatchException(String message) : _message = message;

  @override
  String toString() => "UnsupportedNinePatchException: '$_message'";
}
