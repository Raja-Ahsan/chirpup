import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/delete_dialog.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_bloc.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_events.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_states.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/dummy/dummy_sketches.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/my_drawing_entry_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/sketch_template_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/views/sketch_coloring_view.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/widgets/sketch_shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class MyDrawingBookView extends StatefulWidget {
  final String? childId;
  const MyDrawingBookView({super.key, this.childId});

  @override
  State<MyDrawingBookView> createState() => _MyDrawingBookViewState();
}

class _MyDrawingBookViewState extends State<MyDrawingBookView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MagicColoringBloc>().add(MyDrawingsRequested(widget.childId??""));
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
                      Column(
                        children: [
                          const SizedBox(height: 25),
                          HeadingText(
                            text: "My Magical\nCreations",
                            fontSize: 28,
                            color: AppColors.textYellow,
                            textAlign: TextAlign.center,
                            lineSpacing: 0,
                          ),
                          const SizedBox(height: 5),
                          CustomText(
                            text:
                                'Every picture you made tells\na story of imagination',
                            fontSize: 14,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: BlocBuilder<MagicColoringBloc, MagicColoringStates>(
                      builder: (context, state) {
                        if (state.isMyDrawingsLoading) {
                          return _buildSkeletonGrid();
                        }

                        if (state.myDrawings.isEmpty) {
                          return Center(
                            child: CustomText(
                              text: 'No creations saved yet.\nBookmark a coloring to see it here!',
                              fontSize: 18,
                              weight: FontWeight.w400,
                              color: Colors.black,
                              textAlign: TextAlign.center,
                              lineSpacing: 0,
                            ),
                          );
                        }

                        return GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.myDrawings.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            final entry = state.myDrawings[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => _CreationDetailView(entry: entry),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: _DrawingThumbnail(url: entry.coloredImageUrl),
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
        childAspectRatio: 0.8,
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

/// coloredImageUrl ab kabhi local asset path (dummy) ho sakta hai, kabhi
/// real network URL (API aane pe) — ye widget dono handle karta hai.
class _DrawingThumbnail extends StatelessWidget {
  final String url;
  const _DrawingThumbnail({required this.url});

  @override
  Widget build(BuildContext context) {
    final bool isNetwork = url.startsWith('http');
    return isNetwork
        ? Image.network(url, fit: BoxFit.contain)
        : Image.asset(url, fit: BoxFit.contain);
  }
}

class _CreationDetailView extends StatelessWidget {
  final MyDrawingEntryModel entry;
  const _CreationDetailView({required this.entry});

  void _onDeleteTap(BuildContext context) {
    showCommonDialog(
      context: context,
      child: deleteDialog(
        context,
        'Are you sure you want to\ndelete this creation?',
        onConfirm: () {
          context.read<MagicColoringBloc>().add(MyDrawingDeleteRequested(entry.id));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onEditTap(BuildContext context) {
    // 👇 API aane pe: yahan asal sketch-template (sourceSketchId se) load hoga,
    // aur MagicColoringBloc pehle se hi entry.coloredImageUrl + entry.regionColors
    // ko bakedLayer mein restore kar dega jaisa progress-load karta hai.
    // Abhi dummy phase mein, ek fresh sketch khulti hai (jaisa tumne bataya).
    final SketchTemplateModel sketch = DummySketchesData.forBook('book_sketches')
        .firstWhere(
          (s) => s.id == entry.sourceSketchId,
          orElse: () => DummySketchesData.forBook('book_sketches').first,
        );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SketchColoringView(sketch: sketch),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.4),
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
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => _onEditTap(context),
                          child: Image.asset(
                            'assets/png/edit_button.png',
                            width: 46,
                            height: 46,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _onDeleteTap(context),
                          child: Image.asset(
                            'assets/png/delete_button.png',
                            width: 46,
                            height: 46,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset('assets/svg/cross.svg'),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: Center(
                        child: _DrawingThumbnail(url: entry.coloredImageUrl),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}