import 'package:flutter/material.dart';

extension FeedbackX on BuildContext {
  /// Lightweight confirmation for actions that would hit the backend.
  void showFeedback(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
