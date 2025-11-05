import 'package:flutter/material.dart';

/// A widget that manages 3D page transitions with layered screens
/// New screens slide in from behind the current screen with depth effect
class PageTransition3D extends StatefulWidget {

  const PageTransition3D({
    Key? key,
    required this.child,
    required this.pageKey,
    this.transitionDuration = const Duration(milliseconds: 800),
  }) : super(key: key);
  final Widget child;
  final String pageKey;
  final Duration transitionDuration;

  @override
  State<PageTransition3D> createState() => _PageTransition3DState();
}

class _PageTransition3DState extends State<PageTransition3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _depthAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  String? _previousPageKey;
  Widget? _previousChild;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );

    // Animation for depth (z-axis movement)
    _depthAnimation = Tween<double>(
      begin: -200.0, // Start behind
      end: 0.0, // Come to front
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    // Scale animation for depth perception
    _scaleAnimation = Tween<double>(
      begin: 0.85, // Smaller when behind
      end: 1.0, // Full size at front
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    // Opacity for smooth fade
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _previousPageKey = widget.pageKey;
    _previousChild = widget.child;
  }

  @override
  void didUpdateWidget(PageTransition3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageKey != widget.pageKey) {
      _startTransition(oldWidget.child);
    }
  }

  void _startTransition(Widget oldChild) {
    setState(() {
      _isTransitioning = true;
      _previousChild = oldChild;
      _previousPageKey = widget.pageKey;
    });

    _controller.forward(from: 0.0).then((_) {
      setState(() {
        _isTransitioning = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Previous page - fades out and scales down
            if (_isTransitioning && _previousChild != null)
              Transform.scale(
                scale: 1.0 - (_scaleAnimation.value - 0.85) * 0.5,
                child: Opacity(
                  opacity: 1.0 - _opacityAnimation.value,
                  child: _previousChild,
                ),
              ),

            // New page - slides in from behind
            if (_isTransitioning)
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..translate(0.0, 0.0, _depthAnimation.value)
                  ..scale(_scaleAnimation.value),
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: widget.child,
                ),
              )
            else
              widget.child,
          ],
        );
      },
    );
  }
}

/// A simpler sliding transition for section navigation
class SectionSlideTransition extends StatelessWidget {

  const SectionSlideTransition({
    Key? key,
    required this.child,
    required this.slideAnimation,
  }) : super(key: key);
  final Widget child;
  final Animation<Offset> slideAnimation;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }
}
