import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_bloc.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_events.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_states.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/views/sketch_coloring_view.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/widgets/sketch_shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterStudioBookView extends StatefulWidget {
  const CharacterStudioBookView({super.key});

  @override
  State<CharacterStudioBookView> createState() =>
      _CharacterStudioBookViewState();
}

class _CharacterStudioBookViewState extends State<CharacterStudioBookView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MagicColoringBloc>().add(
        const SketchesForBookRequested('book_character_studio'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/my_drawing_book_bg.png",
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
                            'assets/png/purple_back_button.png',
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ),
                      // Title
                      Column(
                        children: [
                          const SizedBox(height: 25),
                          HeadingText(
                            text: "Choose\nCharacter\nto Color",
                            fontSize: 28,
                            color: AppColors.textYellow,
                            textAlign: TextAlign.center,
                            lineSpacing: 0,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: BlocBuilder<MagicColoringBloc, MagicColoringStates>(
                      builder: (context, state) {
                        // 👇 sirf ise book ke sketches load-hone ka signal —
                        // isSketchesLoading poore bloc-level flag hai, isliye
                        // guard bhi laga rahe: sketches empty na ho jab load ho chuka ho
                        if (state.isSketchesLoading) {
                          return _buildSkeletonGrid();
                        }

                        final characters = state.sketches
                            .where((s) => s.bookId == 'book_character_studio')
                            .toList();

                        if (characters.isEmpty) {
                          return const Center(
                            child: CustomText(
                              text: 'No characters available yet.',
                              color: Colors.black,
                              weight: FontWeight.w400,
                            ),
                          );
                        }

                        return GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: characters.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.62,
                              ),
                          itemBuilder: (context, index) {
                            final character = characters[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SketchColoringView(sketch: character),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.only(
                                  top: 35,
                                  bottom: 10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        character.thumbnailUrl,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    HeadingText(
                                      text: character.name.toLowerCase(),
                                      color: const Color(0xff6B617A),
                                      shadowColor: const Color(0xffD0CCF0),
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
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

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        return SketchShimmerLoading(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.circular(24),
          baseColor: const Color(0xFFD9E3FF),
          highlightColor: const Color(0xFFF4F8FF),
          decorationColor: const Color(0xFFE7F0FF),
        );
      },
    );
  }
}
