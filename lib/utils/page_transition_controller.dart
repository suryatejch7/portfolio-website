import 'package:flutter/material.dart';
import 'dart:collection';

/// Controller for managing 3D page transitions with queueing
class PageTransitionController extends ChangeNotifier {

  PageTransitionController({String? initialPage}) : _currentPage = initialPage;
  final Queue<PageTransitionRequest> _queue = Queue();
  bool _isTransitioning = false;
  String? _currentPage;
  String? _targetPage;

  bool get isTransitioning => _isTransitioning;
  String? get currentPage => _currentPage;
  String? get targetPage => _targetPage;
  bool get hasPending => _queue.isNotEmpty;

  /// Request a transition to a new page
  void requestTransition(String targetPage, ScrollController scrollController, GlobalKey targetKey) {
    _queue.add(PageTransitionRequest(
      targetPage: targetPage,
      scrollController: scrollController,
      targetKey: targetKey,
    ));
    _processQueue();
  }

  /// Process the next transition in queue
  Future<void> _processQueue() async {
    if (_isTransitioning || _queue.isEmpty) return;

    final request = _queue.removeFirst();

    // Don't transition if we're already on this page
    if (_currentPage == request.targetPage) {
      _processQueue(); // Process next in queue
      return;
    }

    _isTransitioning = true;
    _targetPage = request.targetPage;
    notifyListeners();

    // Wait for 3D animation to complete
    await Future.delayed(const Duration(milliseconds: 800));

    // Update current page and scroll to target
    _currentPage = request.targetPage;
    _scrollToTarget(request.scrollController, request.targetKey);

    // Small delay before marking transition complete
    await Future.delayed(const Duration(milliseconds: 200));

    _isTransitioning = false;
    _targetPage = null;
    notifyListeners();

    // Process next transition if any
    _processQueue();
  }

  void _scrollToTarget(ScrollController controller, GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;

    // Check if controller has any positions attached
    if (!controller.hasClients) return;

    try {
      final offset = box.localToGlobal(Offset.zero);
      final scrollPosition = controller.offset + offset.dy - 64.0; // headerHeight

      controller.animateTo(
        scrollPosition.clamp(0.0, controller.position.maxScrollExtent),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    } catch (e) {
      // Ignore scroll errors during transition
      debugPrint('Scroll error during transition: $e');
    }
  }

  /// Clear all pending transitions
  void clearQueue() {
    _queue.clear();
  }
}

class PageTransitionRequest {

  PageTransitionRequest({
    required this.targetPage,
    required this.scrollController,
    required this.targetKey,
  });
  final String targetPage;
  final ScrollController scrollController;
  final GlobalKey targetKey;
}
