import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/services/storage_service.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/confirmation_dialog.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/child_dashboard/bloc/child_dashboard_bloc.dart';
import 'package:chirp_up_app/features/child/child_dashboard/bloc/child_dashboard_events.dart';
import 'package:chirp_up_app/features/child/child_dashboard/bloc/child_dashboard_states.dart';
import 'package:chirp_up_app/features/child/child_dashboard/data/character_gifs_map.dart';
import 'package:chirp_up_app/features/child/child_dashboard/presentation/widgets/mood_chip_widget.dart';
import 'package:chirp_up_app/features/child/child_dashboard/presentation/widgets/shimmer_box_widget.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/kingdom_workshop_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/age_1to2_config.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/age_3to4_config.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/age_5to6_config.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/age_7to8_config.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/age_9plus_config.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/melody_mixer_enums.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/playlist_song_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/create/melody_create_generate_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/create/melody_play_room_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/create/mood_select_grid_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/playlist/melody_playlist_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/quest/melody_quest_room_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/quest/quest_intro_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/quest/quest_result_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/quest/quest_reward_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/shared/hub_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/shared/melody_celebration_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/shared/melody_create_intro_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/shared/melody_intro_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/shared/melody_mood_select_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ChildDashboardView extends StatefulWidget {
  final String? childId;
  const ChildDashboardView({super.key, this.childId});

  @override
  State<ChildDashboardView> createState() => _ChildDashboardViewState();
}

class _ChildDashboardViewState extends State<ChildDashboardView>
    with TickerProviderStateMixin {
  late final AnimationController _characterFadeController;
  late final Animation<double> _characterFadeAnimation;
  bool _hasAnimatedCharacterIn = false;
  late final AnimationController _cloudController;
  late final Animation<double> _circle1Scale;
  late final Animation<double> _circle1Opacity;
  late final Animation<double> _circle2Scale;
  late final Animation<double> _circle2Opacity;
  late final Animation<double> _cloudScale;
  late final Animation<double> _cloudOpacity;
  late final String _resolvedChildId;

  @override
  void initState() {
    super.initState();
    final id = widget.childId ?? '';
    _resolvedChildId = id.isNotEmpty ? id : StorageService.getChildId();
    _characterFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _characterFadeAnimation = CurvedAnimation(
      parent: _characterFadeController,
      curve: Curves.easeIn,
    );

    // 👇 character fade complete hote hi cloud animation trigger karo
    _characterFadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _cloudController.forward();
      }
    });

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _circle1Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cloudController,
        curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );
    _circle1Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cloudController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _circle2Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cloudController,
        curve: const Interval(0.2, 0.5, curve: Curves.elasticOut),
      ),
    );
    _circle2Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cloudController,
        curve: const Interval(0.2, 0.45, curve: Curves.easeIn),
      ),
    );

    _cloudScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _cloudController,
        curve: const Interval(0.45, 0.85, curve: Curves.elasticOut),
      ),
    );
    _cloudOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cloudController,
        curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _characterFadeController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) =>
          ChildDashboardBloc()
            ..add(LoadDashboardEvent(context, _resolvedChildId)),
      child: BlocBuilder<ChildDashboardBloc, ChildDashboardStates>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenHeight * 0.7,
                    child: Image.asset(
                      'assets/png/child_dashboard_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // ── Header card ──
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPadding,
                            vertical: AppSizes.verticalPadding,
                          ),
                          child: state.isLoading
                              ? _buildHeaderSkeleton()
                              : _buildHeaderCard(state),
                        ),

                        // ── Character ──
                        Builder(
                          builder: (context) {
                            if (!state.isLoading && !_hasAnimatedCharacterIn) {
                              _hasAnimatedCharacterIn = true;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) _characterFadeController.forward();
                              });
                            }

                            return SizedBox(
                              height: screenHeight * 0.4,
                              child: state.isLoading
                                  ? const SizedBox.shrink()
                                  : RepaintBoundary(
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final stackWidth =
                                              constraints.maxWidth;
                                          final stackHeight =
                                              constraints.maxHeight;
                                          final double circle1Size =
                                              stackWidth * 0.03;
                                          final double circle2Size =
                                              stackWidth * 0.05;

                                          return Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              // ── Circle 1 ──
                                              Positioned(
                                                top: stackHeight * 0.26,
                                                right: stackWidth * 0.4,
                                                child: AnimatedBuilder(
                                                  animation: _circle1Scale,
                                                  builder: (context, _) => Opacity(
                                                    opacity:
                                                        _circle1Opacity.value,
                                                    child: Transform.scale(
                                                      scale:
                                                          _circle1Scale.value,
                                                      child: Container(
                                                        width: circle1Size,
                                                        height: circle1Size,
                                                        decoration:
                                                            const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .circle,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  blurRadius: 6,
                                                                  offset:
                                                                      Offset(
                                                                        0,
                                                                        2,
                                                                      ),
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
                                                top: stackHeight * 0.19,
                                                right: stackWidth * 0.34,
                                                child: AnimatedBuilder(
                                                  animation: _circle2Scale,
                                                  builder: (context, _) => Opacity(
                                                    opacity:
                                                        _circle2Opacity.value,
                                                    child: Transform.scale(
                                                      scale:
                                                          _circle2Scale.value,
                                                      child: Container(
                                                        width: circle2Size,
                                                        height: circle2Size,
                                                        decoration:
                                                            const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .circle,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  blurRadius: 8,
                                                                  offset:
                                                                      Offset(
                                                                        0,
                                                                        3,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // ── Cloud with quote ──
                                              Positioned(
                                                top: 0,
                                                right: stackWidth * 0.02,
                                                child: AnimatedBuilder(
                                                  animation: _cloudScale,
                                                  builder: (context, _) => Opacity(
                                                    opacity:
                                                        _cloudOpacity.value,
                                                    child: Transform.scale(
                                                      scale: _cloudScale.value,
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Stack(
                                                        children: [
                                                          Image.asset(
                                                            'assets/png/cloud_message.png',
                                                            width:
                                                                stackWidth *
                                                                0.36,
                                                          ),
                                                          Positioned(
                                                            top:
                                                                stackWidth *
                                                                0.06,
                                                            left:
                                                                stackWidth *
                                                                0.06,
                                                            right:
                                                                stackWidth *
                                                                0.06,
                                                            child: CustomText(
                                                              text: CharacterGifMap.quoteForCharacterId(
                                                                state
                                                                    .dashboardInfo
                                                                    ?.characterId,
                                                              ),
                                                              color:
                                                                  const Color(
                                                                    0xff496DCD,
                                                                  ),
                                                              fontSize:
                                                                  stackWidth *
                                                                  0.03,
                                                              fontFamily:
                                                                  'LuckiestGuy',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                              Positioned.fill(
                                                child: Transform.translate(
                                                  offset: const Offset(0, 20),
                                                  child: Center(
                                                    child: FadeTransition(
                                                      opacity:
                                                          _characterFadeAnimation,
                                                      child: Lottie.asset(
                                                        CharacterGifMap.lottieForCharacterId(
                                                          state
                                                                  .dashboardInfo
                                                                  ?.characterId ??
                                                              '',
                                                        ),
                                                        repeat: true,
                                                        animate: true,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                            );
                          },
                        ),
                        Stack(
                          children: [
                            const SizedBox(height: 35, width: double.infinity),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color(
                                        0xffF5F8FC,
                                      ).withValues(alpha: 0.0),
                                      const Color(
                                        0xffF5F8FC,
                                      ).withValues(alpha: 1.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ── White content ──
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPadding,
                            vertical: AppSizes.verticalPadding,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xffF5F8FC),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              state.isLoading
                                  ? _buildMoodCardSkeleton()
                                  : _buildMoodCard(context, state),

                              const SizedBox(height: 35),

                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  HeadingText(
                                    text: 'Explore The Kingdom',
                                    fontSize: 24,
                                    color: const Color(0xff645973),
                                    shadowColor: Colors.white,
                                    lineSpacing: 1,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),

                              state.isLoading
                                  ? _buildGamesSkeleton()
                                  : _buildGamesGrid(context),

                              const SizedBox(height: 15),
                              state.isLoading
                                  ? ShimmerBox(
                                      width: double.infinity,
                                      height: 100,
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                  : Image.asset(
                                      'assets/png/child_dashboard_banner.png',
                                    ),
                              const SizedBox(height: 15),

                              CommonButton(
                                title: 'Switch to parent Mode',
                                bgColor: AppColors.blueColor,
                                shadowColor: AppColors.textShadowBlue,
                                borderColor: AppColors.textShadowBlue,
                                onPressed: () =>
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.parentDashboard,
                                      (route) => false,
                                    ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Header card
  Widget _buildHeaderCard(ChildDashboardStates state) {
    final info = state.dashboardInfo;
    final progress = ((info?.progressPercent ?? 0) / 100).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 25, right: 20, top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingText(
                      text: info?.name ?? '',
                      fontSize: 18,
                      color: const Color(0xff645973),
                      shadowColor: Colors.transparent,
                      lineSpacing: 0,
                    ),
                    CustomText(
                      text: info?.age ?? '',
                      fontSize: 12,
                      weight: FontWeight.bold,
                      color: const Color(0xff585959),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Image.asset('assets/png/star.png', height: 18),
                  const SizedBox(width: 2),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: HeadingText(
                      text: '${info?.stars ?? 0}',
                      fontSize: 14,
                      color: const Color(0xff645973),
                      shadowColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Row(
                children: [
                  Image.asset('assets/png/coin.png', height: 18),
                  const SizedBox(width: 2),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: HeadingText(
                      text: '${info?.points ?? 0} PTS',
                      fontSize: 14,
                      color: const Color(0xff645973),
                      shadowColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 30),
                  height: 25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffDEE9F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    height: 25,
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    child: HeadingText(
                      text: '${info?.progressPercent ?? 0}%',
                      fontSize: 12,
                      shadowColor: const Color(0xff594FAD),
                      color: Colors.white,
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

  // ── Header card skeleton ──
  Widget _buildHeaderSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 25, right: 20, top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: 80,
                      height: 16,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 6),
                    ShimmerBox(
                      width: 60,
                      height: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),
              ShimmerBox(
                width: 40,
                height: 18,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(width: 20),
              ShimmerBox(
                width: 50,
                height: 18,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(width: 15),
              ShimmerBox(
                width: 28,
                height: 28,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: ShimmerBox(
              width: double.infinity,
              height: 25,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mood card (real) ──
  Widget _buildMoodCard(BuildContext context, ChildDashboardStates state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff178BD1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeadingText(
            text: 'How Is Your Heart Feeling Today?',
            fontSize: 18,
            color: Colors.white,
            textAlign: TextAlign.center,
            shadowColor: Colors.transparent,
            lineSpacing: 1,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffECF3F6),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(state.moods.length, (index) {
                final mood = state.moods[index];
                final isSelected = state.selectedMoodIndex == index;
                return MoodChip(
                  label: mood.label,
                  imagePath: mood.imagePath,
                  bgColor: mood.bgColor,
                  selectedBgColor: mood.selectedBgColor,
                  isSelected: isSelected,
                  onTap: () {
                    if (isSelected) return;

                    showCommonDialog(
                      context: context,
                      child: confirmationDialog(
                        context,
                        'Are you sure you want to\nchange your mood?',
                        onConfirm: () {
                          context.read<ChildDashboardBloc>().add(
                            SelectMoodEvent(context, _resolvedChildId, index),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mood card skeleton ──
  Widget _buildMoodCardSkeleton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff178BD1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeadingText(
            text: 'How Is Your Heart Feeling Today?',
            fontSize: 18,
            color: Colors.white,
            textAlign: TextAlign.center,
            shadowColor: Colors.transparent,
            lineSpacing: 1,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffECF3F6),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    5,
                    (i) => ShimmerBox(
                      width: 55,
                      height: 55,
                      borderRadius: BorderRadius.circular(19),
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

  // ── Games grid (real) ──
  Widget _buildGamesGrid(BuildContext context) {
    return BlocBuilder<ChildDashboardBloc, ChildDashboardStates>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = (constraints.maxWidth - 10) / 2;
            final double itemHeight = itemWidth * 1.3;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.breathOfKingdomOnboarding,
                      ),
                      child: Image.asset(
                        'assets/png/breath_of_kingdom_banner.png',
                        width: itemWidth,
                        height: itemHeight,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KingdomWorkshopView(
                            childId: _resolvedChildId,
                            characterId: state.dashboardInfo?.characterId ?? '',
                          ),
                        ),
                      ),
                      child: Image.asset(
                        'assets/png/kingdom_workshop_banner.png',
                        width: itemWidth,
                        height: itemHeight,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      // onTap: () => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (ctx) => MelodyIntroView(
                      //       backgroundAsset:
                      //           'assets/png/melody_mixer/backgrounds/music_hall.png',
                      //       characterId: state.dashboardInfo?.characterId ?? '',
                      //       onReturnToKingdom: () => Navigator.pop(ctx),
                      //       onTapAnywhere: () {
                      //         Navigator.push(
                      //           ctx,
                      //           MaterialPageRoute(
                      //             builder: (_) => MelodyPlayRoomView(
                      //               backgroundAsset:
                      //                   'assets/png/melody_mixer/backgrounds/music_hall.png',
                      //               instruments: age1to2MusicHallInstruments,
                      //               onBack: () {
                      //                 Navigator.pushReplacement(
                      //                   ctx,
                      //                   MaterialPageRoute(
                      //                     builder: (_) => MelodyCelebrationView(
                      //                       backgroundAsset:
                      //                           'assets/png/melody_mixer/backgrounds/winning_background.png',
                      //                       podiumAsset:
                      //                           'assets/png/melody_mixer/ui/winning_stage.png',
                      //                        headingText:'Yay!' ,
                      //                        headingSubText: 'Beautiful\nsounds!',
                      //                       characterId: state.dashboardInfo?.characterId ?? '',
                      //                      onExit: () =>
                      //                           Navigator.pushAndRemoveUntil(
                      //                             ctx,
                      //                             MaterialPageRoute(
                      //                               builder: (_) =>
                      //                                   ChildDashboardView(
                      //                                     childId:
                      //                                         widget.childId,
                      //                                   ),
                      //                             ),
                      //                             (route) => false,
                      //                           ),
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // ),
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => MelodyMoodSelectView(
                      //         backgroundAsset:
                      //             'assets/png/melody_mixer/backgrounds/mood_select_bg.png',
                      //         characterId:
                      //             state.dashboardInfo?.characterId ?? '',
                      //         moods: age3to4Config.moods,
                      //         onMoodSelected: (mood) {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (_) => MelodyIntroView(
                      //                 backgroundAsset: mood.roomBackgroundAsset,
                      //                 characterId:
                      //                     state.dashboardInfo?.characterId ??
                      //                     '',
                      //                 onReturnToKingdom: () =>
                      //                     Navigator.pop(context),
                      //                 onBack: () => Navigator.pop(context),
                      //                 onTapAnywhere: () {
                      //                   // 👇 guide play room (star wala)
                      //                   Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                       builder: (_) => MelodyPlayRoomView(
                      //                         instruments: mood.instruments,
                      //                         badgeColor: mood.badgeColor,
                      //                         backgroundAsset:
                      //                             mood.roomBackgroundAsset,
                      //                         showGuide: true,
                      //                         moodBadgeLabel: mood.label,
                      //                         moodBadgeIcon: mood.iconAsset,
                      //                         onBack: () {
                      //                           Navigator.pushReplacement(
                      //                             context,
                      //                             MaterialPageRoute(
                      //                               builder: (_) => MelodyCelebrationView(
                      //                                 backgroundAsset:
                      //                                     'assets/png/melody_mixer/backgrounds/winning_background.png',
                      //                                 podiumAsset:
                      //                                     'assets/png/melody_mixer/ui/winning_stage.png',
                      //                                 headingText:'Hooray!' ,
                      //                                 headingSubText: 'You created\njoyful sounds!',
                      //                                 characterId:
                      //                                     state
                      //                                         .dashboardInfo
                      //                                         ?.characterId ??
                      //                                     '',
                      //                                 onExit: () =>
                      //                                     Navigator.pushAndRemoveUntil(
                      //                                       context,
                      //                                       MaterialPageRoute(
                      //                                         builder: (_) =>
                      //                                             ChildDashboardView(
                      //                                               childId: widget
                      //                                                   .childId,
                      //                                             ),
                      //                                       ),
                      //                                       (route) => false,
                      //                                     ),
                      //                               ),
                      //                             ),
                      //                           );
                      //                         },
                      //                       ),
                      //                     ),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   );
                      // },
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MelodyHubView(
//                             showPlaylistButton: true,
//                               backgroundAsset:
//                                   'assets/png/melody_mixer/backgrounds/hub_room.png',
//                               characterId:
//                                   state.dashboardInfo?.characterId ?? '',
//                               cards: age5to6HubCards,
//                               onReturnToKingdom: () => Navigator.pop(context),
//                               onPlaylistIconTap: () {
//   Navigator.push(context, MaterialPageRoute(
//     builder: (_) => MelodyPlaylistView(
//       moods: age5to6Config.moods,
//       initialMoodId: 'calm',
//       songs: const [   // static abhi — API baad mein
//         PlaylistSong(id: '1', title: 'Calm Song 3', duration: '00:10', group: 'today', progress: 0.5),
//         PlaylistSong(id: '2', title: 'Calm Song 2', duration: '00:09', group: 'today', progress: 0.25),
//         PlaylistSong(id: '3', title: 'Calm Song 1', duration: '00:16', group: 'yesterday', progress: 0.5),
//       ],
//       onBack: () => Navigator.pop(context),
//       onSearch: () {},
//       onStartNewSong: () {
//         // create flow — mood select se shuru
//       },
//       onMoodChanged: (mood) {
//         // mood badla → us mood ke songs load (API baad mein)
//       },
//     ),
//   ));
// },
//                               onCardTap: (card) {
//                                 switch (card.flow) {
//                                   case MixerFlowId.createSong:
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => MelodyMoodSelectView(
//                                           backgroundAsset:
//                                               'assets/png/melody_mixer/backgrounds/mood_select_bg.png',
//                                           characterId: state.dashboardInfo?.characterId??'',
//                                           moods: age5to6Config.moods,
//                                           onBack: () => Navigator.pop(context),
//                                           onMoodSelected: (mood) {
//                                              Navigator.push(context, MaterialPageRoute(
//               builder: (_) => MelodyPlayRoomView(
//                 backgroundAsset: mood.roomBackgroundAsset,
//                 showSongsOnExit: true, 
//                 instruments: mood.instruments, 
//                 moodBadgeLabel: mood.label,
//                 moodBadgeIcon: mood.iconAsset,
//                 badgeColor: mood.badgeColor,
//                 showGuide: false, 
//                 showRecordButton: true, 
//                 onRecordTap: () {
//                 },
//                 onBack: () => Navigator.of(context)..pop()..pop(),
//               ),
//             ));
//                                           },
//                                         ),
//                                       ),
//                                     );
//                                     break;

//                                   case MixerFlowId.quest:
//                                     Navigator.push(context, MaterialPageRoute(
//     builder: (_) => MelodyQuestIntroView(
//       quest: dummyDragonQuest,          // 👈 abhi static; API se aayega
//       onBack: () => Navigator.pop(context),
//      continueQuiz: () {
//   Navigator.push(context, MaterialPageRoute(
//     builder: (_) => MelodyQuestRoomView(
//       quest: dummyDragonQuest,
//       onBack: () => Navigator.pop(context),
//       onReadyToCreate: () {
//         // 👇 making magic ke baad → result screen (room replace)
//         Navigator.pushReplacement(context, MaterialPageRoute(
//           builder: (_) => MelodyQuestResultView(
//             quest: dummyDragonQuest,
//             backgroundAsset: dummyDragonQuest.questResultBackground,
//             onContinue: () {
//               Navigator.pushReplacement(context, MaterialPageRoute(
//     builder: (_) => MelodyQuestRewardView(
//       quest: dummyDragonQuest,
//       backgroundAsset: 'assets/png/melody_mixer/backgrounds/winning_background.png', // jo pehle dala tha
//       dragonLottieAsset: 'assets/lotties/dragon_winning_lottie.json',
//       stars: 3,
//       coins: 15,
//       energy: 0.9,              // quest se jo bani (abhi static)
//       songDuration: '00:10',
//       onSaveToPlaylist: () {
//       },
//       onReturnToMusicHall: () {
//         // seedha hub (music hall) — quest ki saari screens stack se hatao
        
//   Navigator.of(context)..pop()..pop();   // reward + intro pop → hub

//         // ya agar hub named nahi, to hub tak jo bhi tumhara tareeqa ho
//       },
//     ),
//   ));
//             },
//           ),
//         ));
//       },
//     ),
//   ));
// },
//     ),
//   ));
//                                     break;

//                                   default:
//                                     break;
//                                 }
//                               },
//                         )));
//                       },
onTap: (){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> MelodyHubView(
  backgroundAsset: 'assets/png/melody_mixer/backgrounds/hub_room.png',
  characterId: state.dashboardInfo?.characterId??'',
  cards: age7to8HubCards,          // 👈 teen cards (7-8)
  onReturnToKingdom: () => Navigator.pop(context),
  onPlaylistIconTap: () {
    // playlist screen
  },
  onCardTap: (card) {
    switch (card.flow) {
      case MixerFlowId.createSong:
  Navigator.push(context, MaterialPageRoute(
    builder: (ctx) => MelodyCreateIntroView(
      backgroundAsset: 'assets/png/melody_mixer/backgrounds/melody_create_bg.png',  // ye bg
      characterId: state.dashboardInfo?.characterId,
      onBack: () => Navigator.pop(ctx),
        onStartCreating: () {
  Navigator.push(ctx, MaterialPageRoute(
    builder: (_) => MelodyMoodSelectGridView(
      backgroundAsset: 'assets/png/melody_mixer/backgrounds/mood_select_bg.png',
      moods: age7to8Config.moods,
      onBack: () => Navigator.pop(ctx),
      onContinue: (mood) {
        // record wala play room (5-6 jaisa)
        Navigator.push(ctx, MaterialPageRoute(
          builder: (_) => MelodyPlayRoomView(
            backgroundAsset: mood.roomBackgroundAsset,
            instruments: mood.instruments,
            moodBadgeLabel: mood.label,
            moodBadgeIcon: mood.iconAsset,
            badgeColor: mood.badgeColor,
            showRecordButton: true,
            showSongsOnExit: true,
            onBack: () => Navigator.of(ctx)..pop()..pop(),
          ),
        ));
      },
    ),
  ));
      },
    ),
  ));
  break;





        
        break;
case MixerFlowId.quest:
  Navigator.push(context, MaterialPageRoute(
    builder: (_) => MelodyQuestIntroView(
      quest: dummyBraveQuest,                 // 👈 7-8 ka quest
      onBack: () => Navigator.pop(context),
      continueQuiz: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MelodyQuestRoomView(
  quest: dummyBraveQuest,
  tapBeforeRender: true,   // 👈 7-8
  onBack: () => Navigator.pop(context),
  onReadyToCreate: () {
  Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (resultCtx) => MelodyQuestResultView(   // 👈 is builder ka context
      quest: dummyBraveQuest,
      backgroundAsset: dummyBraveQuest.questResultBackground,
      onContinue: () {
        Navigator.pushReplacement(resultCtx, MaterialPageRoute(  // 👈 resultCtx, dashboard wala nahi
          builder: (rewardCtx) => MelodyQuestRewardView(
            quest: dummyBraveQuest,
            backgroundAsset: 'assets/png/melody_mixer/backgrounds/winning_background.png',
            dragonLottieAsset: 'assets/lotties/dragon_winning_lottie.json',
            stars: 3,
            coins: 15,
            energy: 0.8,
            songDuration: '00:10',
            onSaveToPlaylist: () {},
            onReturnToMusicHall: () {
              Navigator.of(rewardCtx)..pop()..pop();
            },
          ),
        ));
      },
    ),
  ));
},
),));
      },
    ),
  ));
  break;
      case MixerFlowId.playlist:
         Navigator.push(context, MaterialPageRoute(
    builder: (_) => MelodyPlaylistView(
      moods: age7to8Config.moods,        // 👈 7-8 ke moods (Magical waghera)
      initialMoodId: 'magical',          // 👈 jo pehle selected ho
      songs: const [                     // static abhi — API baad mein
        PlaylistSong(id: '1', title: 'Magical Song 2', duration: '00:10', group: 'today', progress: 0.9),
        PlaylistSong(id: '2', title: 'My Magical Song', duration: '00:09', group: 'today', progress: 0.3),
        PlaylistSong(id: '3', title: 'Magical Song 1', duration: '00:16', group: 'yesterday', progress: 0.9),
      ],
      onBack: () => Navigator.pop(context),
      onSearch: () {},
      onStartNewSong: () {
        // create flow se shuru (create intro ya mood select)
      },
      onMoodChanged: (mood) {
        // mood badla → us mood ke songs load (API baad mein)
      },
    ),
  ));
        break;
      default:
        break;
    }
  },
),));
},

// onTap: () {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       settings: const RouteSettings(name: 'melody_hub'),
//       builder: (ctx) => MelodyHubView(
//         backgroundAsset: 'assets/png/melody_mixer/backgrounds/9plus_hub_room.png',
//         characterId: state.dashboardInfo?.characterId ?? '',
//         cards: age9plusHubCards,
//         showBlackLayout: true,
//         welcomeName: state.dashboardInfo?.name,
//         onReturnToKingdom: () => Navigator.pop(ctx),
//         onPlaylistIconTap: () {
//         },
//         onCardTap: (card) {
//           switch (card.flow) {
//             case MixerFlowId.createSong:
//               // 9+ create → create intro → mood grid → generate (agli screens)
//               Navigator.push(ctx, MaterialPageRoute(
//                 builder: (_) => MelodyMoodSelectGridView(
//                    backgroundAsset: 'assets/png/melody_mixer/backgrounds/mood_select_bg.png',
//       moods: age9plusConfig.moods,
//       onBack: () => Navigator.pop(ctx),
//      onContinue: (mood) {
//   Navigator.push(ctx, MaterialPageRoute(
//     builder: (_) => MelodyCreateGenerateView(
//       backgroundAsset: mood.roomBackgroundAsset,
//       instruments: mood.instruments,
//       moodBadgeLabel: mood.label,
//       moodBadgeIcon: mood.iconAsset,
//       badgeColor: mood.badgeColor,
//       onBack: () => Navigator.pop(ctx),
//     ),
//   ));
// },
//                 ),
//               ));
//               break;

//             case MixerFlowId.playlist:
//               // // same as playlist icon
//               // Navigator.push(ctx, MaterialPageRoute(
//               //   builder: (_) => MelodyPlaylistView(
//               //     moods: age9plusConfig.moods,
//               //     initialMoodId: age9plusConfig.moods.first.id,
//               //     songs: const [],
//               //     onBack: () => Navigator.pop(ctx),
//               //     onSearch: () {},
//               //     onStartNewSong: () {},
//               //     onMoodChanged: (mood) {},
//               //   ),
//               // ));
//               // break;

//             case MixerFlowId.reflect:
//               // reflect/journal screen (9+ naya) — abhi khali
//               break;

//             default:
//               break;
//           }
//         },
//       ),
//     ),
//   );
// },


                      child: Image.asset(
                        'assets/png/melody_mixer_banner.png',
                        width: itemWidth,
                        height: itemHeight,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/png/gratitude_garden_banner.png',
                      width: itemWidth,
                      height: itemHeight,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ── Games grid skeleton ──
  Widget _buildGamesSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - 10) / 2;
        final double itemHeight = itemWidth * 1.3;

        return Column(
          children: [
            Row(
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
            ),
            const SizedBox(height: 10),
            Row(
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
            ),
          ],
        );
      },
    );
  }
}
