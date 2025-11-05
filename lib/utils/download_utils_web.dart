import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// Web-specific implementation for downloading resume
Future<void> downloadResumeImpl(BuildContext context) async {
  try {
    // Load the PDF as bytes
    final data = await rootBundle.load('assets/Resume.pdf');
    final bytes = data.buffer.asUint8List();

    // Create a Blob from the bytes
    final blob = html.Blob([bytes], 'application/pdf');

    // Create a download URL
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger download
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'Resume.pdf')
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();

    // Clean up
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resume downloaded successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error downloading resume: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
