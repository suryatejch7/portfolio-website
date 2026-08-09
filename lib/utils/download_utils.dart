import 'package:flutter/material.dart';

// Conditional import: use web implementation on web, io implementation otherwise
import 'download_utils_io.dart'
    if (dart.library.html) 'download_utils_web.dart';

// Main entry point that delegates to platform-specific implementation
Future<void> downloadResume(BuildContext context) async {
  return downloadResumeImpl(context);
}
