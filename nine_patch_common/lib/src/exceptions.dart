/// Thrown when this is not a nine-patch image.
final class NotNinePatchException implements Exception {
  /// Create a [NotNinePatchException].
  NotNinePatchException(String message) : _message = message;
  final String _message;

  @override
  String toString() => "NotNinePatchException: '$_message'";
}

/// Thrown when there is a issue with the nine-patch image.
final class InvalidNinePatchException implements Exception {
  /// Create an [InvalidNinePatchException].
  InvalidNinePatchException(String message) : _message = message;
  final String _message;

  @override
  String toString() => "InvalidNinePatchException: '$_message'";
}

/// Thrown when this is not a supported form of nine-patch.
final class UnsupportedNinePatchException implements Exception {
  /// Create an [UnsupportedNinePatchException].
  UnsupportedNinePatchException(String message) : _message = message;
  final String _message;

  @override
  String toString() => "UnsupportedNinePatchException: '$_message'";
}
