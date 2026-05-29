import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class SketchColoringView extends StatefulWidget {
  const SketchColoringView({super.key});

  @override
  State<SketchColoringView> createState() => _SketchColoringViewState();
}

class _SketchColoringViewState extends State<SketchColoringView> {
  int _selectedColorIndex = 0;
  bool _isBrushMode = true;

  final List<Color> _colors = [
    const Color(0xff4A90D9),
    const Color(0xffF5E642),
    const Color(0xff1B7A4A),
    const Color(0xffD94040),
    const Color(0xffB06ED4),
    const Color(0xff4FD1C5),
    const Color(0xff5AAD2E),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background ──
          Positioned.fill(
            child: Image.asset(
              "assets/png/magic_coloring_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding,
                vertical: AppSizes.horizontalPadding,
              ),
              child: Column(
                children: [
                  // ── Top bar ──
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/png/back_button.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/png/delete_button.png',
                        width: 46,
                        height: 46,
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'assets/png/screenshot_button.png',
                        width: 46,
                        height: 46,
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.coloringComplete,
                        ),
                        child: Image.asset(
                          'assets/png/check_button.png',
                          width: 46,
                          height: 46,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ── Drawing canvas ──
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPadding,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Center(
                          child: Image.asset(
                            'assets/png/castle_sketch_1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () => setState(() => _isBrushMode = !_isBrushMode),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: 47,
                        width: 90,
                        decoration: BoxDecoration(
                          color: AppColors.textYellow,
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: _isBrushMode ? null : 12,
                              right: _isBrushMode ? 12 : null,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Image.asset(
                                  _isBrushMode
                                      ? 'assets/png/paint_bucket.png'
                                      : 'assets/png/paint_brush.png',
                                  height: 20,
                                  width: 18,
                                  fit: BoxFit.contain,
                                  color: const Color(0xff4D4A51),
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              left: _isBrushMode ? -4 : 40,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _isBrushMode
                                          ? const Color(0xff0C5FBF)
                                          : const Color(0xff7FAB32),
                                      width: 2,
                                    ),
                                    color: _isBrushMode
                                        ? const Color(0xff3688E8)
                                        : const Color(0xff96B85E),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      _isBrushMode
                                          ? 'assets/png/paint_brush.png'
                                          : 'assets/png/paint_bucket.png',
                                      height: 20,
                                      width: 18,
                                      fit: BoxFit.contain,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ── Color palette ──
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_colors.length, (index) {
                        final bool isSelected = _selectedColorIndex == index;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedColorIndex = index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 47.73,
                              height: 57.73,
                              decoration: BoxDecoration(
                                color: _colors[index],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: _colors[index].withValues(
                                            alpha: 0.5,
                                          ),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
