import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/child_dashboard/presentation/widgets/mood_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChildDashboardView extends StatelessWidget {
  const ChildDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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

            // ── Content ──
            SafeArea(
              child: Column(
                children: [
                  // ── Header card ──
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPadding,
                      vertical: AppSizes.verticalPadding,
                    ),
                    child: Container(
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
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 20,
                        top: 15,
                        bottom: 15,
                      ),
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
                                      text: 'Jason',
                                      fontSize: 18,
                                      color: const Color(0xff645973),
                                      shadowColor: Colors.transparent,
                                      lineSpacing: 0,
                                    ),
                                    CustomText(
                                      text: '4-5 Years',
                                      fontSize: 12,
                                      weight: FontWeight.bold,
                                      color: const Color(0xff585959),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/png/star.png',
                                    height: 18,
                                  ),
                                  const SizedBox(width: 2),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: HeadingText(
                                      text: '5',
                                      fontSize: 14,
                                      color: const Color(0xff645973),
                                      shadowColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/png/coin.png',
                                    height: 18,
                                  ),
                                  const SizedBox(width: 2),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: HeadingText(
                                      text: '120 PTS',
                                      fontSize: 14,
                                      color: const Color(0xff645973),
                                      shadowColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 15),
                              GestureDetector(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  'assets/svg/setting.svg',
                                  height: 28,
                                  width: 28,
                                ),
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
                                  widthFactor: 0.6,
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 10),
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.purple,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: HeadingText(
                                      text: '60%',
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
                    ),
                  ),

                  // ── Character ──
                  SizedBox(
                    height: screenHeight * 0.4,
                    child: Center(
                      child: Image.asset(
                        'assets/png/prince_character.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Stack(
                    children: [
                      SizedBox(height: 35, width: double.infinity),
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
                                const Color(0xffF5F8FC).withValues(alpha:0.0),
                                const Color(0xffF5F8FC).withValues(alpha:1.0),
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
                    decoration: BoxDecoration(color: const Color(0xffF5F8FC)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xff178BD1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.only(top:14),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MoodChip(
                                      label: 'Happy',
                                      imagePath: 'assets/png/happy_mood.png',
                                      bgColor: const Color(0xffEFEAD3),
                                    ),
                                    MoodChip(
                                      label: 'Calm',
                                      imagePath: 'assets/png/calm_mood.png',
                                      bgColor: const Color(0xffD6E4F0),
                                    ),
                                    MoodChip(
                                      label: 'Sleepy',
                                      imagePath: 'assets/png/sleepy_mood.png',
                                      bgColor: const Color(0xffDCE6F2),
                                    ),
                                    MoodChip(
                                      label: 'Angry',
                                      imagePath: 'assets/png/angry_mood.png',
                                      bgColor: const Color(0xffEEDFDF),
                                    ),
                                    MoodChip(
                                      label: 'Sad',
                                      imagePath: 'assets/png/sad_mood.png',
                                      bgColor: const Color(0xffD9E1E4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),
                        Row(
                          children: [
                            SizedBox(width: 10),
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
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final double itemWidth =
                                (constraints.maxWidth - 10) / 2;
                            final double itemHeight = itemWidth * 1.3;

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: ()=> Navigator.pushNamed(context, AppRoutes.selectCharacterForBreath),
                                      child: Image.asset(
                                        'assets/png/breath_of_kingdom_banner.png',
                                        width: itemWidth,
                                        height: itemHeight,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: ()=> Navigator.pushNamed(context, AppRoutes.kingdomWorkShop),
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
                                    Image.asset(
                                      'assets/png/melody_mixer_banner.png',
                                      width: itemWidth,
                                      height: itemHeight,
                                      fit: BoxFit.fill,
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
                        ),
                        const SizedBox(height: 15),
                        Image.asset('assets/png/child_dashboard_banner.png'),
                        const SizedBox(height: 15),
                        CommonButton(
                          title: 'Switch to parent Mode',
                          bgColor: AppColors.blueColor,
                          shadowColor: AppColors.textShadowBlue,
                          borderColor: AppColors.textShadowBlue,
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.parentDashboard,
                            (route) => false,
                          ),
                        ),
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
  }
}
