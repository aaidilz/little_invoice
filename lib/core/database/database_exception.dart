class DatabaseException implements Exception {
  final String message;
  final dynamic originalException;

  DatabaseException(this.message, [this.originalException]);

  @override
  String toString() => 'DatabaseException: $message \n Original: $originalException';
}
