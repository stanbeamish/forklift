import 'package:flutter/material.dart';

class BasicLogger {
  static void log(String methodName, String message) {
    debugPrint('{$methodName} | {$message}');
  }
}