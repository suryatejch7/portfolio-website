import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Mobile/Desktop-specific implementation for downloading resume
Future<void> downloadResumeImpl(BuildContext context) async {
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Downloading resume...'),
            ],
          ),
        );
      },
    );

    // Load the PDF from assets
    ByteData data;
    Uint8List bytes;

    try {
      data = await rootBundle.load('assets/Resume.pdf');
      bytes = data.buffer.asUint8List();
    } catch (e) {
      // Try alternative paths
      try {
        data = await rootBundle.load('assets/resume.pdf');
        bytes = data.buffer.asUint8List();
      } catch (e2) {
        throw Exception('Could not load resume PDF from assets');
      }
    }

    // Get the downloads directory
    final Directory? downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloads directory not found')),
      );
      return;
    }

    // Create the file path
    final String filePath = '${downloadsDir.path}/Resume.pdf';
    final File file = File(filePath);

    // Write the file
    await file.writeAsBytes(bytes);

    // Close loading dialog
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Resume saved to: $filePath'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  } catch (e) {
    // Close loading dialog if it's open
    Navigator.of(context).pop();

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error downloading resume: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
