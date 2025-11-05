import 'package:flutter/material.dart';

class HeaderItem {

  HeaderItem({
    required this.title,
    required this.onTap,
    this.isButton = false,
  });
  final String title;
  final VoidCallback onTap;
  final bool isButton;
}
