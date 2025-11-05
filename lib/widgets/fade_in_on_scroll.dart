import 'package:flutter/material.dart';

/// Fades its child in when it first enters the viewport while scrolling.
/// - No dependencies required
/// - Triggers once (does not fade out when scrolled away)
class FadeInOnScroll extends StatefulWidget { // 0..1 of the widget height that must be visible to trigger

  const FadeInOnScroll({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.offset = 20.0,
    this.visibilityFactor = 0.1,
  }) : super(key: key);
  final Widget child;
  final Duration duration;
  final double offset;
  final double visibilityFactor;

  @override
  _FadeInOnScrollState createState() => _FadeInOnScrollState();
}

class _FadeInOnScrollState extends State<FadeInOnScroll> {
  bool _hasAnimatedIn = false;
  final GlobalKey _key = GlobalKey();
  ScrollPosition? _position;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _attachScrollListener();
      _updateVisibility();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-attach if scrollable context changed
    _attachScrollListener();
  }

  void _attachScrollListener() {
    final scrollableState = Scrollable.maybeOf(context);
    final newPosition = scrollableState?.position;
    if (_position == newPosition) return;

    _position?.removeListener(_onScroll);
    _position = newPosition;
    _position?.addListener(_onScroll);
  }

  void _onScroll() {
    // Throttle by scheduling after frame to avoid layout during scroll
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  void _updateVisibility() {
    if (_hasAnimatedIn) return;
    final contextForKey = _key.currentContext;
    if (contextForKey == null) return;
    final renderObject = contextForKey.findRenderObject();
    if (renderObject is! RenderBox) return;

    final size = renderObject.size;
    if (!renderObject.attached) return;

    // Position of the widget in global coordinates
    final topLeft = renderObject.localToGlobal(Offset.zero);
    final top = topLeft.dy;
    final bottom = top + size.height;

    final screenHeight = MediaQuery.of(context).size.height;

    // Check if at least [visibilityFactor] of height is within [0, screenHeight]
    final requiredVisibleHeight = size.height * widget.visibilityFactor;
    final visibleTop = top.clamp(0.0, screenHeight);
    final visibleBottom = bottom.clamp(0.0, screenHeight);
    final visibleHeight = (visibleBottom - visibleTop).clamp(0.0, size.height);

    final isNowVisible = visibleHeight >= requiredVisibleHeight;
    if (isNowVisible && !_hasAnimatedIn && mounted) {
      setState(() {
        _hasAnimatedIn = true;
      });
      // After animating in, we no longer need the scroll listener
      _position?.removeListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _hasAnimatedIn;
    // Wrap in RepaintBoundary to isolate from parent transforms
    return RepaintBoundary(
      key: _key,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: widget.offset,
            end: visible ? 0.0 : widget.offset,
          ),
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
