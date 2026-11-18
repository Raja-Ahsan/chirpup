import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/utils/get_character_by_id_helper.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/child_dashboard/presentation/widgets/shimmer_box_widget.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/bloc/kingdom_workshop_bloc.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/bloc/kingdom_workshop_events.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/bloc/kingdom_workshop_states.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/data/models/game_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/views/magic_coloring_entry_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KingdomWorkshopView extends StatelessWidget {
  final String? childId;
  final String? characterId;
  final int? gameCategoryId;
  final int? yearId;

  const KingdomWorkshopView({
    super.key,
    this.childId,
    this.characterId,
    this.gameCategoryId,
    this.yearId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          KingdomWorkshopBloc()
            ..add(LoadGamesEvent(context, gameCategoryId??1, yearId)),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _TopSection(characterId: characterId),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.verticalPadding,
                  horizontal: AppSizes.horizontalPadding,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      BlocBuilder<KingdomWorkshopBloc, KingdomWorkshopStates>(
                        builder: (context, state) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final double itemWidth =
                                  (constraints.maxWidth - 10) / 2;
                              final double itemHeight = itemWidth * 1.4;

                              if (state.isLoading) {
                                return _buildGamesSkeleton(
                                  itemWidth,
                                  itemHeight,
                                );
                              }

                              if (state.games.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: Center(
                                    child: CustomText(
                                      text: 'Could not load games.',
                                      fontSize: 14,
                                      weight: FontWeight.w700,
                                      color: Color(0xff645973),
                                    ),
                                  ),
                                );
                              }

                              return Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 10,
                                children: state.games.map((game) {
                                  return InkWell(
                                    onTap: () => _onGameTap(context, game),
                                    child: SizedBox(
                                      width: itemWidth,
                                      height: itemHeight,
                                      child: Image.network(
                                        game.imageUrl,
                                        width: itemWidth,
                                        height: itemHeight,
                                        fit: BoxFit.fill,
                                        loadingBuilder:
                                            (context, child, progress) {
                                              if (progress == null) {
                                                return child;
                                              }
                                              return ShimmerBox(
                                                width: itemWidth,
                                                height: itemHeight,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              );
                                            },
                                        errorBuilder: (_, __, ___) => Container(
                                          width: itemWidth,
                                          height: itemHeight,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: CustomText(
                                            text: game.name,
                                            fontSize: 14,
                                            weight: FontWeight.w700,
                                            color: const Color(0xff645973),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      Image.asset('assets/png/kingdom_workshop_banner_bg.png'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Game slug ke hisab se kholo ──
  void _onGameTap(BuildContext context, GameModel game) {
    switch (game.slug) {
      case 'castle-builder':
        Navigator.pushNamed(context, AppRoutes.buildCastle);
        break;
      case 'magic-coloring':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MagicColoringEntryView(
              childId: childId ?? '',
              characterId: characterId ?? '',
            ),
          ),
        );
        break;
      default:
        break;
    }
  }

  // ── Cards skeleton (dashboard jaisa) ──
  Widget _buildGamesSkeleton(double itemWidth, double itemHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShimmerBox(
          width: itemWidth,
          height: itemHeight,
          borderRadius: BorderRadius.circular(20),
        ),
        const SizedBox(width: 10),
        ShimmerBox(
          width: itemWidth,
          height: itemHeight,
          borderRadius: BorderRadius.circular(20),
        ),
      ],
    );
  }
}

class _TopSection extends StatefulWidget {
  final String? characterId;
  const _TopSection({this.characterId});
  @override
  State<_TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<_TopSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // Circle 1 (small)
  late Animation<double> _circle1Scale;
  late Animation<double> _circle1Opacity;

  // Circle 2 (medium)
  late Animation<double> _circle2Scale;
  late Animation<double> _circle2Opacity;

  // Cloud
  late Animation<double> _cloudScale;
  late Animation<double> _cloudOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // ── Circle 1: 0% → 25% ──
    _circle1Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );
    _circle1Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    // ── Circle 2: 20% → 50% ──
    _circle2Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.elasticOut),
      ),
    );
    _circle2Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.45, curve: Curves.easeIn),
      ),
    );

    // ── Cloud: 45% → 85% ──
    _cloudScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.85, curve: Curves.elasticOut),
      ),
    );
    _cloudOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
      ),
    );

    // Auto start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = AppSizes.horizontalPadding;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      width: double.infinity,
      height: screenHeight * 0.75,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/png/parent_dashboard_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSizes.verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeadingText(
                    text: 'Kingdom\nWorkshop',
                    fontSize: 28,
                    fontFamily: 'LuckiestGuy',
                    lineSpacing: 0,
                    textAlign: TextAlign.center,
                    color: AppColors.textYellow,
                  ),
                  CustomText(
                    text: "Let your imagination bring\nthe kingdom to life",
                    fontSize: 14,
                    weight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // ── Character + Bubbles ──
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final stackHeight = constraints.maxHeight;
                        final stackWidth = constraints.maxWidth;
                        final double characterHeight = stackHeight * 0.85;
                        final double circle1Size = stackWidth * 0.05;
                        final double circle2Size = stackWidth * 0.09;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // ── Circle 1 ──
                            Positioned(
                              bottom: characterHeight * 0.78,
                              left: stackWidth * 0.6,
                              child: AnimatedBuilder(
                                animation: _circle1Scale,
                                builder: (context, _) => Opacity(
                                  opacity: _circle1Opacity.value,
                                  child: Transform.scale(
                                    scale: _circle1Scale.value,
                                    child: Container(
                                      width: circle1Size,
                                      height: circle1Size,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // ── Circle 2 ──
                            Positioned(
                              bottom: characterHeight * 0.81,
                              left: stackWidth * 0.66,
                              child: AnimatedBuilder(
                                animation: _circle2Scale,
                                builder: (context, _) => Opacity(
                                  opacity: _circle2Opacity.value,
                                  child: Transform.scale(
                                    scale: _circle2Scale.value,
                                    child: Container(
                                      width: circle2Size,
                                      height: circle2Size,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // ── Cloud ──
                            Positioned(
                              bottom: characterHeight * 0.88,
                              left: stackWidth * 0.58,
                              child: AnimatedBuilder(
                                animation: _cloudScale,
                                builder: (context, _) => Opacity(
                                  opacity: _cloudOpacity.value,
                                  child: Transform.scale(
                                    scale: _cloudScale.value,
                                    alignment: Alignment.bottomLeft,
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'assets/png/cloud_message.png',
                                          width: stackWidth * 0.45,
                                        ),
                                        Positioned(
                                          bottom: stackWidth * 0.1,
                                          left: stackWidth * 0.10,
                                          child: CustomText(
                                            text:
                                                'Let\'s create a\npeaceful place\njust for you',
                                            color: const Color(0xff645973),
                                            fontSize: stackWidth * 0.035,
                                            fontFamily: 'LuckiestGuy',
                                            textAlign: TextAlign.center,
                                            lineSpacing: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // ── Character ──
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Image.asset(
                                CharacterStaticImageMap.imageForCharacterId(
                                  widget.characterId,
                                ),
                                height: characterHeight,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
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
}
