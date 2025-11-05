import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/models/header_item.dart';
import 'package:web_portfolio/utils/globals.dart';
import 'package:web_portfolio/utils/screen_helper.dart';

// Initialize with dummy callbacks - will be set by Home widget
List<HeaderItem> headerItems = [
  HeaderItem(
    title: 'HOME',
    onTap: () {},
  ),
  HeaderItem(title: 'PROJECTS', onTap: () {}),
  HeaderItem(title: 'EDUCATION', onTap: () {}),
  HeaderItem(title: 'SKILLS', onTap: () {}),
];

// Function to set navigation callbacks
// Note: `onHireMe` is accepted as an optional named callback for compatibility
// but the UI no longer shows a "HIRE ME" entry in the sidebar.
void setNavigationCallbacks({
  required VoidCallback onHome,
  required VoidCallback onProjects,
  required VoidCallback onEducation,
  required VoidCallback onSkills,
  VoidCallback? onHireMe,
}) {
  headerItems = [
    HeaderItem(title: 'HOME', onTap: onHome),
    HeaderItem(title: 'PROJECTS', onTap: onProjects),
    HeaderItem(title: 'EDUCATION', onTap: onEducation),
    HeaderItem(title: 'SKILLS', onTap: onSkills),
  ];
}

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Toggle sidebar menu
          Globals.menuOpen.value = !Globals.menuOpen.value;
        },
        child: const Icon(
          Icons.menu_rounded,
          color: Colors.white,
          size: 32.0,
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Globals.currentSectionTitle,
      builder: (context, title, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, anim) {
            return FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.3),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            );
          },
          child: Text(
            title,
            key: ValueKey(title),
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
              letterSpacing: 1.2,
            ),
          ),
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: buildHeader(),
        ),
        // We will make this in a bit
        mobile: buildMobileHeader(),
        tablet: buildHeader(),
      ),
    );
  }

  // mobile header
  Widget buildMobileHeader() {
    final Widget menuChip = _glassWrap(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: HeaderLogo(),
      ),
    );

    final Widget titleChip = _glassWrap(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: _HeaderTitle(),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        height: 48.0, // Reduced height
        child: Row(
          children: [
            // Left glassmorphic menu button
            menuChip,
            const SizedBox(width: 16.0),
            // Centered title (use Expanded + Align.center)
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: titleChip,
              ),
            ),
            // Right spacer to preserve perfect centering (same size as left chip)
            const SizedBox(width: 16.0),
            Opacity(opacity: 0.0, child: menuChip),
          ],
        ),
      ),
    );
  }

  // Desktop/tablet header
  Widget buildHeader() {
    final Widget menuChip = _glassWrap(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: HeaderLogo(),
      ),
    );

    final Widget titleChip = _glassWrap(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: _HeaderTitle(),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        height: 48.0, // Reduced height
        child: Row(
          children: [
            // Left glassmorphic menu button
            menuChip,
            const SizedBox(width: 16.0),
            // Centered title (use Expanded + Align.center)
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: titleChip,
              ),
            ),
            // Right spacer to preserve perfect centering (same size as left chip)
            const SizedBox(width: 16.0),
            Opacity(opacity: 0.0, child: menuChip),
          ],
        ),
      ),
    );
  }

  // Shared glass wrapper for iOS-like liquid glass effect
  Widget _glassWrap(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.10),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
