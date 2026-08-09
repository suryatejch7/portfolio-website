import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:web_portfolio/utils/constants.dart';

class Avatar3D extends StatefulWidget {
  const Avatar3D({Key? key}) : super(key: key);

  @override
  State<Avatar3D> createState() => _Avatar3DState();
}

class _Avatar3DState extends State<Avatar3D> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Auto-hide loading after 3 seconds (give it time to load)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only render 3D model on web platform
    if (!kIsWeb) {
      // Fallback for non-web platforms (desktop/mobile apps)
      return Container(
        constraints: const BoxConstraints(
          maxHeight: 500,
          maxWidth: 500,
        ),
        child: Center(
          child: Icon(
            Icons.account_circle,
            size: 200,
            color: kPrimaryColor.withOpacity(0.3),
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 800,
        maxWidth: 700,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The 3D Model Viewer
          ModelViewer(
            src: 'https://models.readyplayer.me/690ad2723ea48bdc1e458872.glb',
            alt: 'Ready Player Me Avatar',
            ar: false,
            autoRotate: true,
            autoRotateDelay: 0,
            rotationPerSecond: '30deg',
            cameraControls: true,
            disableZoom: true,
            touchAction: TouchAction.panY,
            backgroundColor: Colors.transparent,
            loading: Loading.eager,
            reveal: Reveal.auto,
            cameraOrbit: '0deg 75deg 4.2m',
            fieldOfView: '40deg',
            minCameraOrbit: 'auto auto 3m',
            maxCameraOrbit: 'auto auto 5m',
            interpolationDecay: 200,
          ),

          // Loading overlay with spinner
          if (_isLoading)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading 3D Avatar...',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
