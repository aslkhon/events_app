import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SnackbarError extends Equatable {
  final String message;
  final Color color;

  static const noConnection =
      SnackbarError(message: 'Check your internet connection');

  static const noMoreEvents =
      SnackbarError(message: 'No more events', color: Colors.blue);

  static const requestFailure = SnackbarError(
      message: 'We are, sorry, problems related to server',
      color: Colors.black);

  const SnackbarError({required this.message, this.color = Colors.red});

  @override
  List<Object?> get props => [message, color];
}
