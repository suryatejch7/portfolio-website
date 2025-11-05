import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/utils/constants.dart';
import 'package:web_portfolio/utils/screen_helper.dart';
import 'package:url_launcher/url_launcher.dart';

// Removed stats - replaced with GitHub button

class PortfolioStats extends StatelessWidget {
  const PortfolioStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Future<void> _openGitHub() async {
    final Uri url = Uri.parse('https://github.com/suryatejch7?tab=repositories');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: '_blank');
    }
  }

  Widget _buildUi(double width, BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width,
          minWidth: width,
        ),
        child: Center(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _openGitHub,
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'VIEW ALL',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '(GitHub)',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
