import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_bloc.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_events.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_states.dart';
import 'package:chirp_up_app/features/auth/presentation/widgets/characters_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PickYourMagicalFriendView extends StatefulWidget {
  const PickYourMagicalFriendView({super.key});

  @override
  State<PickYourMagicalFriendView> createState() =>
      _PickYourMagicalFriendViewState();
}

class _PickYourMagicalFriendViewState extends State<PickYourMagicalFriendView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const CharactersRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/child_selection_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.verticalPadding,
                horizontal: AppSizes.horizontalPadding,
              ),
              child: BlocBuilder<AuthBloc, AuthStates>(
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      HeadingText(
                        text: "Pick your\nMagical friend",
                        fontSize: 28,
                        color: AppColors.textYellow,
                        textAlign: TextAlign.center,
                        lineSpacing: 0,
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        text:
                            "Pick a magical friend to begin your\njourney through the kingdom",
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                      Spacer(flex: 1),
                      if (state.isCharactersLoading)
                        Column(
                          children: [
                            Image.asset(
                              'assets/png/character_loading.png',
                              color: Colors.blue.withValues(alpha: 0.45),
                            ),
                            const SizedBox(height: 16),
                            _shimmerBox(width: 160, height: 28),
                          ],
                        )
                      else if (state.characters.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CustomText(
                              text: 'Could not load characters.',
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        )
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return CharactersRowWidget(
                              characters: state.characters,
                              selectedIdx: state.selectedCharacterIndex,
                              availableWidth: constraints.maxWidth,
                              onSelect: (index) {
                                context.read<AuthBloc>().add(
                                  SelectCharacterEvent(index),
                                );
                              },
                            );
                          },
                        ),
                      Spacer(),
                      CommonButton(
                        title: 'Continue journey',
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.createYourChildProfile,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _shimmerBox({double? width, required double height, double radius = 8}) {
  return Shimmer.fromColors(
    baseColor: Colors.white.withValues(alpha: 0.15),
    highlightColor: Colors.white.withValues(alpha: 0.60),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
