import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/utils/constants.dart';
import 'package:web_portfolio/utils/screen_helper.dart';

class IosAppAd extends StatelessWidget {
  const IosAppAd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth),
        tablet: _buildUi(kTabletMaxWidth),
        mobile: _buildUi(getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildUi(double maxWidth) {
    final bool isHorizontal = maxWidth > 720.0;

    Widget buildImage({required double maxWidth, required double maxHeight}) {
      return Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        child: Image.asset(
          'assets/expense_tracker.png',
          fit: BoxFit.contain,
        ),
      );
    }

    final Widget textBlock = _buildTextContent();

    return Center(
      child: RepaintBoundary(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: isHorizontal
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: buildImage(maxWidth: 400.0, maxHeight: 500.0),
                      ),
                    ),
                    const SizedBox(width: 40.0),
                    Expanded(
                      child: textBlock,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: buildImage(maxWidth: 300.0, maxHeight: 400.0),
                    ),
                    const SizedBox(height: 20.0),
                    textBlock,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ANDROID/IOS APP',
          style: GoogleFonts.oswald(
            color: kPrimaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 15.0),
        Text(
          'EXPENSE TRACKER APP',
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            height: 1.3,
            fontSize: 35.0,
          ),
        ),
        const SizedBox(height: 10.0),
        const Text(
          'Add Expenses manually or just by sharing PhonePe screenshot where details are extracted and auto-filled with help of OCR and Image processing.',
          style: TextStyle(
            color: kCaptionColor,
            height: 1.5,
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }
}
