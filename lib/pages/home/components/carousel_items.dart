import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/models/carousel_item_model.dart';
import 'package:web_portfolio/utils/constants.dart';
import 'package:web_portfolio/widgets/code_terminal.dart';

// Global callback function for download
VoidCallback? onDownloadPressed;

List<CarouselItemModel> carouselItems = List.generate(
  5,
  (index) => CarouselItemModel(
    text: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SURYA\nTEJ',
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 56.0,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 48.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
              ),
              child: TextButton(
                onPressed: onDownloadPressed,
                child: const Text(
                  'DOWNLOAD CV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
    image: const Center(child: CodeTerminal()),
  ),
);