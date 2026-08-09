import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/utils/constants.dart';
import 'package:web_portfolio/utils/screen_helper.dart';

class _Skill {
  const _Skill(this.name);
  final String name;
}

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

  Widget _skillRow(_Skill skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: kPrimaryColor,
            size: 20.0,
          ),
          const SizedBox(width: 16.0),
          Text(
            skill.name,
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required List<_Skill> skills,
  }) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A24).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, color: kPrimaryColor, size: 22.0),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontWeight: FontWeight.w500, // Thinner font weight
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          ...skills.map(_skillRow),
        ],
      ),
    );
  }

  Widget _buildUi(double width) {
    const languages = [
      _Skill('Java'),
      _Skill('Dart'),
      _Skill('JavaScript'),
      _Skill('Python'),
    ];
    const frameworks = [
      _Skill('Spring Boot'),
      _Skill('Flutter'),
      _Skill('MySQL / PostgreSQL'),
      _Skill('Node.js'),
    ];

    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isHorizontal = constraints.maxWidth > 800;
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
                const SizedBox(height: 40.0),
                Flex(
                  direction: isHorizontal ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _card(
                        icon: Icons.code_rounded,
                        title: 'Languages',
                        skills: languages,
                      ),
                    ),
                    SizedBox(
                      width: isHorizontal ? 28.0 : 0.0,
                      height: isHorizontal ? 0.0 : 28.0,
                    ),
                    Expanded(
                      child: _card(
                        icon: Icons.layers_rounded,
                        title: 'Frameworks & Databases',
                        skills: frameworks,
                      ),
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