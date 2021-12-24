class RequestException implements Exception {
  final String reason;
  final int statusCode;

  static const badRequest =
      RequestException(reason: 'Bad request', statusCode: 400);

  static const notFound =
      RequestException(reason: 'Not found', statusCode: 404);

  static const serverError =
      RequestException(reason: 'Server error', statusCode: 500);

  const RequestException({required this.reason, required this.statusCode});
}

class DBException implements Exception {}

class TypeMismatchException implements Exception {}
