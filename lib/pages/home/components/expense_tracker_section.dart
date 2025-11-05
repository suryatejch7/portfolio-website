import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/utils/constants.dart';
import 'package:web_portfolio/utils/screen_helper.dart';

class ExpenseTrackerSection extends StatelessWidget {
  const ExpenseTrackerSection({Key? key}) : super(key: key);

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
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth =
              constraints.maxWidth.clamp(0.0, maxWidth);
          final bool isHorizontal = availableWidth > 720.0;

          Widget buildImage(double width, double height) {
            return Container(
              constraints: BoxConstraints(
                maxWidth: width,
                maxHeight: height,
              ),
              child: Image.asset(
                'assets/expense_tracker.png',
                fit: BoxFit.contain,
              ),
            );
          }

          final Widget textBlock = _buildTextContent();

          return RepaintBoundary(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: availableWidth),
              child: Flex(
                direction: isHorizontal ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isHorizontal)
                    Flexible(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: buildImage(400.0, 500.0),
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.center,
                      child: buildImage(300.0, 400.0),
                    ),
                  if (isHorizontal)
                    const SizedBox(width: 40.0)
                  else
                    const SizedBox(height: 20.0),
                  if (isHorizontal)
                    Flexible(
                      flex: 1,
                      child: textBlock,
                    )
                  else
                    textBlock,
                ],
              ),
            ),
          );
        },
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
          'An intelligent expense management application featuring manual entry and automated data extraction via screenshot sharing. Leveraging advanced OCR and image processing technologies, the app automatically populates expense details including name, amount, and date from payment screenshots. Users can categorize expenses, set category-specific limits, establish monthly budgets, and visualize spending patterns through comprehensive analytics dashboards.',
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
