import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/sketch_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/widgets/sketch_card_widget.dart';
import 'package:flutter/material.dart';

class ChooseSketchView extends StatefulWidget {
  const ChooseSketchView({super.key});

  @override
  State<ChooseSketchView> createState() => _ChooseSketchViewState();
}

class _ChooseSketchViewState extends State<ChooseSketchView> {
  int _selectedIndex = 0;

  // Category tabs
  final List<Map<String, dynamic>> _categories = [
    {'imagePath': 'assets/png/color_castle.png', 'isSelected': true},
    {'imagePath': 'assets/png/horse.png', 'isSelected': false},
  ];

  // Sketches list — add more, grid auto scrolls
  final List<SketchItem> _sketches = [
    SketchItem(imagePath: 'assets/png/castle_sketch_1.png', isLocked: false),
    SketchItem(imagePath: 'assets/png/castle_sketch_2.png', isLocked: false),
    SketchItem(imagePath: 'assets/png/castle_sketch_3.png', isLocked: false),
    SketchItem(imagePath: 'assets/png/castle_sketch_4.png', isLocked: false),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/magic_coloring_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.verticalPadding,
                horizontal: AppSizes.horizontalPadding,
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            'assets/png/back_button.png',
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ),
                      // Title
                      Column(
                        children: [
                          SizedBox(height: 25),
                          HeadingText(
                            text: "Choose a\nMagical\nDrawing",
                            fontSize: 26,
                            color: AppColors.textYellow,
                            textAlign: TextAlign.center,
                            lineSpacing: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // ── White container ──
                        Positioned(
                          top: 40,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffF8FDFF),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            height: 453,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: GridView.builder(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  bottom: 15,
                                  top: 70,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.9,
                                    ),
                                itemCount: _sketches.length,
                                itemBuilder: (context, index) {
                                  final sketch = _sketches[index];
                                  return SketchCard(sketch: sketch);
                                },
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 0,
                          left: 20,
                          child: Row(
                            children: List.generate(_categories.length, (
                              index,
                            ) {
                              final isSelected = _selectedIndex == index;
                              return GestureDetector(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(right: 5),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xff97C335)
                                        : const Color(0xffECF3F6),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Image.asset(
                                    _categories[index]['imagePath'],
                                    height: screenWidth * 0.14,
                                    width: screenWidth * 0.14,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
