import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/models/footer_item.dart';
import 'package:web_portfolio/utils/constants.dart';
import 'package:web_portfolio/utils/screen_helper.dart';
import 'package:url_launcher/url_launcher.dart';

final List<FooterItem> footerItems = [
  FooterItem(
    iconPath: 'assets/mappin.png',
    title: 'ADDRESS',
    text1: 'Mahindra University,',
    text2: 'Hyderabad',
  ),
  FooterItem(
    iconPath: 'assets/phone.png',
    title: 'PHONE',
    text1: '+91 7702282663',
    text2: '',
  ),
  FooterItem(
    iconPath: 'assets/email.png',
    title: 'EMAIL',
    text1: 'suryatejch7@gmail.com',
    text2: '',
  ),
  FooterItem(
    iconPath: 'assets/whatsapp.png',
    title: 'WHATSAPP',
    text1: '+91 7702282663',
    text2: '',
  )
];

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }
}

Widget _buildUi(double width, BuildContext context) {
  return Center(
    child: Container(
      constraints: BoxConstraints(
        maxWidth: width,
        minWidth: width,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = ScreenHelper.isMobile(context);
          final crossAxisCount = isMobile ? 1 : 2;
          final tileWidth = constraints.maxWidth / crossAxisCount - 20.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CONTACT',
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 30.0,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Let\'s connect. Tap any card to reach out instantly.',
                style: TextStyle(
                  color: kCaptionColor,
                  height: 1.6,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 28.0),
              Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: footerItems.map((footerItem) {
                  return GestureDetector(
                    onTap: () => _handleContactTap(footerItem, context),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: tileWidth,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1A24).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  footerItem.iconPath,
                                  width: 24.0,
                                ),
                                const SizedBox(width: 12.0),
                                Text(
                                  footerItem.title,
                                  style: GoogleFonts.oswald(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${footerItem.text1}\n',
                                    style: const TextStyle(
                                      color: kCaptionColor,
                                      height: 1.8,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${footerItem.text2}\n',
                                    style: const TextStyle(
                                      color: kCaptionColor,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40.0),
            ],
          );
        },
      ),
    ),
  );
}

// Function to handle contact taps
void _handleContactTap(FooterItem footerItem, BuildContext context) async {
  String? url;
  
  switch (footerItem.title) {
    case 'ADDRESS':
      // Open Google Maps with the address
      url = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent("Mahindra University, Hyderabad")}";
      break;
    case 'PHONE':
      // Open phone dialer
      url = 'tel:+917702282663';
      break;
    case 'EMAIL':
      // Open email client
      url = 'mailto:suryatejch7@gmail.com';
      break;
    case 'WHATSAPP':
      // Open WhatsApp
      url = 'https://wa.me/917702282663';
      break;
  }
  
  if (url != null) {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // Fallback: show a snackbar with the contact info
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open ${footerItem.title.toLowerCase()}. Contact: ${footerItem.text1}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening ${footerItem.title.toLowerCase()}: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
