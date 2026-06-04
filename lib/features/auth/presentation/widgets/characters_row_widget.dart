import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/auth/data/models/character_model.dart';
import 'package:flutter/material.dart';

class CharactersRowWidget extends StatelessWidget {
  final List<CharacterModel> characters;
  final int selectedIdx;
  final double availableWidth;
  final Function(int) onSelect;
  final bool isFromBreathKingdom;

  const CharactersRowWidget({
    required this.characters,
    required this.selectedIdx,
    required this.availableWidth,
    required this.onSelect,
    this.isFromBreathKingdom = false,
  });

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) return const SizedBox();

    final double w = availableWidth;
    final double selectedSize = w * 0.8;
    final double unselectedSize = w * 0.7;
    final double totalHeight = selectedSize*0.9;
    final double selectedLeft = (w - selectedSize) / 2;

    final renderOrder = [
      ...List.generate(
        characters.length,
        (i) => i,
      ).where((i) => i != selectedIdx),
      selectedIdx,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: totalHeight,
          width: w,
          child: Stack(
            clipBehavior: Clip.none,
            children: renderOrder.map((index) {
              final child = characters[index];
              final bool isSelected = index == selectedIdx;
              final int diff = index - selectedIdx;

              double left;
              double top;
              double size;

              if (isSelected) {
                left = selectedLeft;
                top = 0;
                size = selectedSize;
              } else {
                size = unselectedSize;
                final double step = unselectedSize * 0.4;
                if (diff < 0) {
                  left = selectedLeft + (diff * step)-60;
                } else {
                  left =
                      selectedLeft +
                      selectedSize -
                      unselectedSize +
                      (diff * step)+60;
                }
                top = (selectedSize - unselectedSize)/2;
              }

              return AnimatedPositioned(
                key: ValueKey('child_$index'),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: left,
                top: top,
                width: size,
                height: size,
                child: IgnorePointer(
                  ignoring: isSelected,
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerUp: (_) {
                      if (selectedIdx != index) {
                        final int newIndex = index > selectedIdx
                            ? selectedIdx + 1
                            : selectedIdx - 1;
                        onSelect(newIndex);
                      }
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isSelected ? 1.0 : 0.45,
                      child: Image.asset(child.imagePath, fit: BoxFit.contain),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: isFromBreathKingdom?  60 : 40),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: HeadingText(
            text: characters[selectedIdx].name.toUpperCase(),
            key: ValueKey('name_$selectedIdx'),
            fontSize: 28,
            color: AppColors.textYellow,
            shadowColor: AppColors.textShadowDarkBlue,
            lineSpacing: 0,
            textAlign: TextAlign.center,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: CustomText(
            text: characters[selectedIdx].speciality.toUpperCase(),
            key: ValueKey('speciality_$selectedIdx'),
            textAlign: TextAlign.center,
            fontSize: 14,
            fontFamily: 'LuckiestGuy',
            lineSpacing: 0,
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
