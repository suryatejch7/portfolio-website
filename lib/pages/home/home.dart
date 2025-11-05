import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/pages/home/components/carousel.dart';
import 'package:web_portfolio/pages/home/components/education_section.dart';
import 'package:web_portfolio/pages/home/components/footer.dart';
import 'package:web_portfolio/pages/home/components/header.dart';
import 'package:web_portfolio/pages/home/components/expense_tracker_section.dart';
import 'package:web_portfolio/pages/home/components/portfolio_stats.dart';
import 'package:web_portfolio/pages/home/components/skill_section.dart';
import 'package:web_portfolio/pages/home/components/website_ad.dart';
import 'package:web_portfolio/utils/constants.dart';
import 'package:web_portfolio/utils/globals.dart';
import 'package:web_portfolio/widgets/fade_in_on_scroll.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Tilt animation controller
  late final AnimationController _tiltController;
  late final VoidCallback _menuListener;

  // Title control
  Timer? _titleDebounce;
  bool _titleLocked = false;
  DateTime? _titleUnlockAt;
  String _lastTitle = 'HOME';
  bool _programmaticScroll = false;

  // Section keys
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize tilt controller
    _tiltController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: Globals.menuOpen.value ? 1.0 : 0.0,
    );

    // Listen to menu open changes to animate tilt smoothly
    _menuListener = () {
      final target = Globals.menuOpen.value ? 1.0 : 0.0;
      _tiltController.animateTo(
        target,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubicEmphasized,
      );
    };
    Globals.menuOpen.addListener(_menuListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitleForOffset();
      _setupNavigation();
    });
  }

  void _setupNavigation() {
    setNavigationCallbacks(
      onHome: () => _navigateToSection('HOME', _homeKey),
      onProjects: () => _navigateToSection('PROJECTS', _projectsKey),
      onEducation: () => _navigateToSection('EDUCATION', _educationKey),
      onSkills: () => _navigateToSection('SKILLS', _skillsKey),
      onHireMe: () {
        // TODO: Open contact form or mailto
      },
    );
  }

  // Navigate by scrolling within tilted screen
  Future<void> _navigateToSection(String sectionName, GlobalKey key) async {
    // Lock the title to the target to prevent flicker during programmatic scroll
    Globals.currentSectionTitle.value = sectionName;
    _lastTitle = sectionName;
    _titleLocked = true;

    // Programmatic scroll flag suppresses title updates
    _programmaticScroll = true;

    // Ensure menu remains open (tilted) during scroll
    if (!Globals.menuOpen.value) {
      Globals.menuOpen.value = true;
    }

    await _scrollToKey(key);

    // Small settle delay
    await Future.delayed(const Duration(milliseconds: 100));

    // Close sidebar after reaching target
    Globals.menuOpen.value = false;

    // Unlock title and resume normal updates
    _titleLocked = false;
    _programmaticScroll = false;

    // Refresh title based on actual visibility
    _updateTitleForOffset();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _titleDebounce?.cancel();
    Globals.menuOpen.removeListener(_menuListener);
    _tiltController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_programmaticScroll) return;
    if (_titleLocked &&
        _titleUnlockAt != null &&
        DateTime.now().isBefore(_titleUnlockAt!)) {
      return;
    } else {
      _titleLocked = false;
    }
    // Immediate updates for fast scrolling without debounce
    _updateTitleForOffset();
  }

  double _visibleFraction(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return 0.0;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return 0.0;

    final size = box.size;
    if (size.height <= 0) return 0.0;

    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + size.height;
    final screenSize = MediaQuery.of(context).size;
    const viewportTop = Globals.headerHeight; // below persistent header
    final viewportBottom = screenSize.height;

    final visibleTop = top.clamp(viewportTop, viewportBottom);
    final visibleBottom = bottom.clamp(viewportTop, viewportBottom);
    final visibleHeight = (visibleBottom - visibleTop).clamp(0.0, size.height);
    return visibleHeight / size.height;
  }

  void _updateTitleForOffset() {
    final vis = <String, double>{
      'HOME': _visibleFraction(_homeKey),
      'PROJECTS': _visibleFraction(_projectsKey),
      'EDUCATION': _visibleFraction(_educationKey),
      'SKILLS': _visibleFraction(_skillsKey),
    };

    // Select the most visible section but only switch when it is at least 50% visible
    final topEntry = vis.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final desired = topEntry.key;
    final desiredVis = topEntry.value;

    String nextTitle = _lastTitle;
    if (desiredVis >= 0.5) {
      nextTitle = desired;
    }

    if (Globals.currentSectionTitle.value != nextTitle) {
      Globals.currentSectionTitle.value = nextTitle;
    }
    _lastTitle = nextTitle;
  }

  Future<void> _scrollToKey(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null || !_scrollController.hasClients) return;
    try {
      // First ensure the target is visible near the top
      await Scrollable.ensureVisible(
        ctx,
        alignment: 0.0,
        curve: Curves.easeOutCubic,
        duration: const Duration(milliseconds: 350),
      );
      // Then compensate for the persistent header
      final corrected = (_scrollController.offset - Globals.headerHeight)
          .clamp(0.0, _scrollController.position.maxScrollExtent);
      if ((corrected - _scrollController.offset).abs() > 1.0) {
        await _scrollController.animateTo(
          corrected,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      }
    } catch (_) {
      // Silent fail to avoid jank
    }
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Globals.headerHeight),
          Container(key: _homeKey, child: const Carousel()),
          const SizedBox(height: 20.0),
          Container(
            key: _projectsKey,
            child: const FadeInOnScroll(child: ExpenseTrackerSection()),
          ),
          const SizedBox(height: 70.0),
          const WebsiteAd(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28.0),
            child: FadeInOnScroll(child: PortfolioStats()),
          ),
          const SizedBox(height: 50.0),
          Container(
            key: _educationKey,
            child: const FadeInOnScroll(child: EducationSection()),
          ),
          const SizedBox(height: 50.0),
          Container(
            key: _skillsKey,
            child: const FadeInOnScroll(child: SkillSection()),
          ),
          const SizedBox(height: 50.0),
          const FadeInOnScroll(child: Footer()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Globals.scaffoldKey,
      body: Stack(
        children: [
          // Sidebar
          ValueListenableBuilder<bool>(
            valueListenable: Globals.menuOpen,
            builder: (context, open, _) {
              const double sidebarWidth = 260.0;
              const Duration duration = Duration(milliseconds: 400);
              const curve = Curves.fastEaseInToSlowEaseOut;
              return AnimatedPositioned(
                duration: duration,
                curve: curve,
                left: open ? 0 : -sidebarWidth,
                top: Globals.headerHeight + 8.0,
                bottom: 0,
                width: sidebarWidth,
                child: RepaintBoundary(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 12.0, bottom: 12.0, right: 12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E1A24).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                      itemBuilder: (BuildContext context, int index) {
                        final item = headerItems[index];
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: item.isButton
                              ? Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: kDangerColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: TextButton(
                                    onPressed: item.onTap,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 10.0),
                                      child: Text(
                                        item.title,
                                        style: GoogleFonts.oswald(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : ListTile(
                                  title: Text(
                                    item.title,
                                    style: GoogleFonts.oswald(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  onTap: item.onTap,
                                ),
                        );
                      },
                      separatorBuilder: (_, __) =>
                          const Divider(color: Colors.white24),
                      itemCount: headerItems.length,
                    ),
                  ),
                ),
              );
            },
          ),

          // Main content with sidebar tilt (smooth) and animated border when tilted
          ValueListenableBuilder<bool>(
            valueListenable: Globals.menuOpen,
            builder: (context, open, _) {
              const double sidebarWidth = 260.0;
              const double angle = 0.279; // ~16°
              return AnimatedBuilder(
                animation: _tiltController,
                builder: (context, child) {
                  final double t = _tiltController.value;
                  final Matrix4 matrix = Matrix4.identity()
                    ..setEntry(3, 2, 0.0015)
                    // Translate first, then rotate for smoother effect
                    ..translate(sidebarWidth * t, 0.0, 0.0)
                    ..rotateY(angle * t);
                  return Transform(
                    transform: matrix,
                    alignment: Alignment.centerRight,
                    transformHitTests: true,
                    child: child,
                  );
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (open) Globals.menuOpen.value = false;
                  },
                  child: RepaintBoundary(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(open ? 20.0 : 0.0),
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          border: open
                              ? Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                  width: 1.0,
                                )
                              : null,
                        ),
                        child: _buildContent(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Persistent top header - isolated from transforms
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: false,
              child: RepaintBoundary(
                child: Container(
                  color: Colors.transparent,
                  child: const SafeArea(child: Header()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
