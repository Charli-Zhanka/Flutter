class NoConnectionException implements Exception {
  const NoConnectionException();
  @override
  String toString() => 'No connection';
}

class ApiException implements Exception {
  const ApiException(this.statusCode);
  final int statusCode;
  @override
  String toString() => 'Server error $statusCode';
}
