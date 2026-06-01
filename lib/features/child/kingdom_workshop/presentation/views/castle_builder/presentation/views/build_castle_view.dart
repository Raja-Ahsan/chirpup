import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class BuildCastleView extends StatefulWidget {
  const BuildCastleView({super.key});

  @override
  State<BuildCastleView> createState() => _BuildCastleViewState();
}

class _BuildCastleViewState extends State<BuildCastleView> {
  // Canvas pe placed pieces ki list
  final List<String> placedPieces = [];

  final List<String> magicalPieces = [
    'assets/png/castle_roof.png',
    'assets/png/castle_wall.png',
    'assets/png/castle_door.png',
    'assets/png/castle_tower.png',
    'assets/png/castle_door_wall.png',
    'assets/png/castle_tree.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/png/castle_bg.png", fit: BoxFit.fill),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.verticalPadding,
                    horizontal: AppSizes.horizontalPadding,
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          HeadingText(
                            text: 'Castle Builder',
                            fontSize: 28,
                            fontFamily: 'LuckiestGuy',
                            textAlign: TextAlign.center,
                            color: AppColors.textYellow,
                          ),
                          CustomText(
                            text:
                                "Build a magical castle that feels\npeaceful, safe, and happy",
                            fontSize: 14,
                            weight: FontWeight.w700,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Castle Canvas + Bottom ──
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        // ── Canvas (DragTarget) ──
                        Expanded(
                          child: DragTarget<String>(
                            onAcceptWithDetails: (details) {
                              setState(() {
                                placedPieces.add(details.data);
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              final isHovering = candidateData.isNotEmpty;
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    // Background
                                    Positioned.fill(
                                      child: Image.asset(
                                        'assets/png/build_castle_bg.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    // Hover highlight
                                    if (isHovering)
                                      Positioned.fill(
                                        child: Container(
                                          color: Colors.white.withValues(
                                            alpha: 0.15,
                                          ),
                                        ),
                                      ),

                                    // Placed pieces — stacked center mein
                                    ...placedPieces.map(
                                      (piece) => Center(
                                        child: Image.asset(
                                          piece,
                                          height: 70,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),

                                    // Hint text — jab kuch nahi placed
                                    if (placedPieces.isEmpty)
                                      Center(
                                        child: CustomText(
                                          text:
                                              "Try different magical pieces\nto make your castle unique",
                                          fontSize: 14,
                                          weight: FontWeight.w700,
                                          textAlign: TextAlign.center,
                                          lineSpacing: 0,
                                          color: const Color(0xff6C8387),
                                        ),
                                      ),

                                    // Drop here hint — jab drag ho raha ho
                                    if (isHovering)
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.7,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: CustomText(
                                            text: "Drop here!",
                                            fontSize: 14,
                                            weight: FontWeight.w700,
                                            color: const Color(0xff6C8387),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ── Magical Pieces Section ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffECF3F6),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeadingText(
                                text: 'MAGICAL PIECES',
                                fontSize: 20,
                                color: AppColors.dialogHeadingColor,
                                shadowColor: Colors.white,
                                letterSpacing: 0,
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    magicalPieces.length,
                                    (index) {
                                      final piece = magicalPieces[index];
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          right:
                                              index != magicalPieces.length - 1
                                              ? 12
                                              : 0,
                                        ),
                                        child: LongPressDraggable<String>(
                                          data: piece,
                                          delay: const Duration(
                                            milliseconds: 150,
                                          ),
                                          // baaki sab same rehga
                                          feedback: Material(
                                            color: Colors.transparent,
                                            child: Opacity(
                                              opacity: 0.85,
                                              child: Container(
                                                width: 77,
                                                height: 78,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xffD7E9F0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.15,
                                                          ),
                                                      blurRadius: 10,
                                                      offset: const Offset(
                                                        0,
                                                        4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Image.asset(
                                                  piece,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          childWhenDragging: Opacity(
                                            opacity: 0.4,
                                            child: Container(
                                              width: 77,
                                              height: 78,
                                              decoration: BoxDecoration(
                                                color: const Color(0xffD7E9F0),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              padding: const EdgeInsets.all(20),
                                              child: Image.asset(
                                                piece,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          child: Container(
                                            width: 77,
                                            height: 78,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffD7E9F0),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            child: Image.asset(
                                              piece,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: CommonButton(
                                title: 'FINISH CASTLE',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, AppRoutes.castleComplete);
                                },
                                borderColor: const Color(0xff4E6D19),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              // Undo — last placed piece hatao
                              onTap: () => setState(() {
                                if (placedPieces.isNotEmpty) {
                                  placedPieces.removeLast();
                                }
                              }),
                              child: Image.asset(
                                'assets/png/undo_button.png',
                                height: 53,
                                width: 53,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
