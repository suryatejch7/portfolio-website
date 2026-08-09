import 'package:flutter/material.dart';

class Globals {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final ValueNotifier<bool> menuOpen = ValueNotifier<bool>(false);
  static const double headerHeight = 64.0; // Reduced height
  static final ValueNotifier<String> currentSectionTitle = ValueNotifier<String>('HOME');

  // Section keys for navigation
  static final GlobalKey homeKey = GlobalKey();
  static final GlobalKey projectsKey = GlobalKey();
  static final GlobalKey educationKey = GlobalKey();
  static final GlobalKey skillsKey = GlobalKey();
}
