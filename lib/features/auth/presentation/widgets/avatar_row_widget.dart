
import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chirp_up_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:chirp_up_app/features/auth/presentation/bloc/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvatarRow extends StatelessWidget {
  final List<String> avatars;
  const AvatarRow({required this.avatars});

  // Har avatar ka apna background color
  static const List<Color> avatarBgColors = [
    Color(0xffB0CB80),
    Color(0xFFFCE6A9),
    Color(0xffD8C5FF),
    Color(0xffE18F83),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (context, state) {
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: avatars.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              final isSelected = index == state.selectedAvatarIndex;
              final double size = isSelected ? 116 : 82;

              return GestureDetector(
                onTap: () =>
                    context.read<AuthBloc>().add(SelectAvatarEvent(index)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: isSelected ? 0 : 20,
                  ),
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: avatarBgColors[index],
                    border: Border.all(color: AppColors.whiteColor, width: 2),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit
                          .expand, // image hamesha container fill karegi
                      children: [
                        Image.asset(
                          avatars[index],
                          fit: BoxFit.cover, // size argument bilkul nahi
                        ),
                        // Inner shadow overlay
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.topCenter,
                              radius: 0.99,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.4),
                              ],
                              stops: const [0.0, 0.9, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}