import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/models/education.dart';
import 'package:web_portfolio/utils/constants.dart';
import 'package:web_portfolio/utils/screen_helper.dart';

final List<Education> educationList = [
  Education(
    description:
        'Secondary School Education • Percentage: 85% • Foundation in core subjects',
    linkName: 'Narayana School',
    period: 'Apr 2019 - Mar 2020',
  ),
  Education(
    description:
        'Intermediate Education • Percentage: 97% • Focused on Science and Mathematics',
    linkName: 'Narayana College',
    period: 'May 2020 - Apr 2022',
  ),
  Education(
    description:
        'Bachelor of Computer Science Engineering • CGPA: 6.0/10 (till 6th semester) • Coursework: Software Engineering, Object-Oriented Programming, DBMS',
    linkName: 'Mahindra University',
    period: 'Aug 2022 - Present',
  ),
];

class EducationSection extends StatelessWidget {
  const EducationSection({Key? key}) : super(key: key);

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

  Widget _buildUi(double width) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width,
          minWidth: width,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EDUCATION',
              style: GoogleFonts.oswald(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 30.0,
                height: 1.3,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            const SizedBox(
              height: 40.0,
            ),
            ...educationList
                .map(
                  (education) => Container(
                    margin: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          education.period,
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: education.description
                              .split('•')
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '\u2022 ',
                                          style: TextStyle(
                                            color: kCaptionColor,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            item.trim(),
                                            style: const TextStyle(
                                              color: kCaptionColor,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              education.linkName,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
