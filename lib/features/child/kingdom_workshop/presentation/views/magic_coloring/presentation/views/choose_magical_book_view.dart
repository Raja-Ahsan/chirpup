import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_bloc.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/config/coloring_capability_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _BookOption {
  final BookType type;
  final String title;
  final String subTitle;
  final String imagePath;
  final String route;

  const _BookOption({
    required this.type,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.route,
  });
}

class ChooseMagicalBookView extends StatefulWidget {
  const ChooseMagicalBookView({super.key});

  @override
  State<ChooseMagicalBookView> createState() => _ChooseMagicalBookViewState();
}

class _ChooseMagicalBookViewState extends State<ChooseMagicalBookView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  late final PageController _pageController;
  int _currentPage = 0;

  // 👇 sabhi possible books — asal list yahan se capability ke hisab se filter hogi
  static const List<_BookOption> _allBooks = [
    _BookOption(
      type: BookType.sketchesBook,
      title: 'Create\nNew Magic',
      subTitle: 'Express imagination with colors',
      imagePath: 'assets/png/magic_coloring_book.png',
      route: AppRoutes.chooseSketch,
    ),
    _BookOption(
      type: BookType.myDrawingBook,
      title: 'My Magical\nMemories',
      subTitle: 'See all your Saved creations',
      imagePath: 'assets/png/my_drawing_book.png',
      route: AppRoutes.myDrawingBook,
    ),
    _BookOption(
      type: BookType.characterStudioBook,
      title: 'Color Your\nCharacters',
      subTitle: 'Create Your Magical Characters',
      imagePath: 'assets/png/character_studio_book.png',
      route: AppRoutes.characterStudioBook,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _pageController = PageController(
      viewportFraction: 0.52,
      initialPage: _currentPage,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onSingleBookTap() async {
    if (_controller.isAnimating || _controller.isCompleted) return;
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.chooseSketch);
    }
  }

  Future<void> _onBookTap(List<_BookOption> books, int index) async {
    if (index != _currentPage) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
      return;
    }
    if (_controller.isAnimating || _controller.isCompleted) return;
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      Navigator.pushReplacementNamed(context, books[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ageGroup = context.select<MagicColoringBloc, AgeGroup>(
      (bloc) => bloc.state.ageGroup,
    );

    final capabilities = ColoringCapabilityConfig.byAgeGroup[ageGroup]!;
    final bool isYoungestAgeGroup = ageGroup == AgeGroup.age1to2 || ageGroup == AgeGroup.age3to4;

    final visibleBooks = _allBooks
        .where((book) => capabilities.visibleBooks.contains(book.type))
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/magic_coloring_onboarding_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: SafeArea(
              child: isYoungestAgeGroup
                  ? _buildSingleBookUI()
                  : _buildCarouselUI(visibleBooks),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // ── Age 1-2: Single book UI ──
  // ═══════════════════════════════════════════════
  Widget _buildSingleBookUI() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.verticalPadding,
        horizontal: AppSizes.horizontalPadding,
      ),
      child: Column(
        children: [
          HeadingText(
            text: "The Magical\nBook Awaits",
            fontSize: 28,
            color: AppColors.textYellow,
            textAlign: TextAlign.center,
            lineSpacing: 0,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: _onSingleBookTap,
                    child: Image.asset(
                      'assets/png/magic_coloring_book.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                HeadingText(
                  text: 'Every page holds a\nmagical secret for you\nto discover',
                  fontSize: 18,
                  shadowColor: Colors.transparent,
                  textAlign: TextAlign.center,
                  lineSpacing: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // ── Age 3-4+: Carousel UI (books dynamic hain) ──
  // ═══════════════════════════════════════════════
  Widget _buildCarouselUI(List<_BookOption> books) {
    // safety: agar kisi wajah se list khaali ho (config galat set ho), crash mat karo
    if (books.isEmpty) {
      return const Center(
        child: Text(
          'No books available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final int safeCurrentPage = _currentPage.clamp(0, books.length - 1);
    final currentBook = books[safeCurrentPage];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.verticalPadding),
      child: Column(
        children: [
          HeadingText(
            text: "Choose Your\nMagical Book",
            fontSize: 28,
            color: AppColors.textYellow,
            textAlign: TextAlign.center,
            lineSpacing: 0,
          ),

          const SizedBox(height: 30),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: books.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Center(
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      final double page = _pageController.hasClients
                          ? (_pageController.page ??
                              _pageController.initialPage.toDouble())
                          : _pageController.initialPage.toDouble();

                      final double distance = (page - index).abs();

                      double scale = (1 - (distance * 0.35)).clamp(
                        0.58,
                        1.0,
                      );

                      if (index == 0) {
                        scale *= 1.08;
                      }

                      final double opacity = (1 - (distance * 0.60)).clamp(
                        0.30,
                        1.0,
                      );

                      return Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale.clamp(0.58, 1.08),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => _onBookTap(books, index),
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: SizedBox(
                          height: index == 0 ? 320 : 300,
                          child: Image.asset(
                            books[index].imagePath,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Column(
              key: ValueKey(safeCurrentPage),
              children: [
                HeadingText(
                  text: currentBook.title,
                  fontSize: 28,
                  textAlign: TextAlign.center,
                  lineSpacing: 0,
                  color: AppColors.textYellow,
                ),
                const SizedBox(height: 2),
                CustomText(
                  text: currentBook.subTitle,
                  weight: FontWeight.w700,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}