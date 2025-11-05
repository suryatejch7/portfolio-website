import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/utils/constants.dart';
import 'package:web_portfolio/utils/screen_helper.dart';

class SkillSection extends StatelessWidget {
  const SkillSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth),
        tablet: _buildUi(kTabletMaxWidth),
        mobile: _buildUi(getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Text(
        text,
        style: GoogleFonts.oswald(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13.0,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _card({required String title, required List<String> items}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A24).withOpacity(0.7),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.oswald(
              color: kPrimaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            children: items.map(_buildChip).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUi(double width) {
    const languages = ['Java', 'Dart', 'JavaScript', 'HTML (Basic)'];
    const frameworks = [
      'Spring Boot',
      'Flutter',
      'Node.js',
      'OOPS',
      'MySQL',
      'PostgreSQL'
    ];

    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            constraints: BoxConstraints(
              maxWidth: width,
              minWidth: width,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SKILLS',
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 30.0,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'A snapshot of my current toolset and strengths.',
                  style: TextStyle(
                    color: kCaptionColor,
                    height: 1.6,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 24.0),
                Flex(
                  direction: constraints.maxWidth > 800
                      ? Axis.horizontal
                      : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _card(title: 'Languages', items: languages),
                    ),
                    const SizedBox(width: 20.0, height: 20.0),
                    Expanded(
                      child: _card(
                          title: 'Frameworks & Databases', items: frameworks),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
