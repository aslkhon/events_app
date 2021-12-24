class Failure {
  final String reason;

  static const noMoreEvents = Failure('NO_MORE_EVENTS');

  static const noConnection = Failure('NO_CONNECTION');

  static const requestFailure = Failure('REQUEST_FAILURE');

  static const undefinedFailure = Failure('UNDEFINED_FAILURE');

  const Failure(this.reason);
}
