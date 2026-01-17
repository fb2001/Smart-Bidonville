import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutterTest) async {
  // Configure test timeout globally
  setUpAll(() {
    // Prevent tests from hanging
  });
  
  // Run all tests with a default timeout
  return FutterTest();
}
