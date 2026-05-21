import 'package:chirp_up_app/features/parent/dashboard/data/models/child_model.dart';
import 'package:flutter/material.dart';

class ChildrenRow extends StatelessWidget {
  final List<ChildModel> children;
  final int selectedIdx;
  final double availableWidth;
  final Function(int) onSelect;

  const ChildrenRow({
    required this.children,
    required this.selectedIdx,
    required this.availableWidth,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox();

    final double w = availableWidth;
    final double selectedSize = w * 0.80;
    final double unselectedSize = w * 0.70;
    final double totalHeight = selectedSize;
    final double selectedLeft = (w - selectedSize) / 2;

    final renderOrder = [
      ...List.generate(
        children.length,
        (i) => i,
      ).where((i) => i != selectedIdx),
      selectedIdx,
    ];

    return SizedBox(
      height: totalHeight,
      width: w,
      child: Stack(
        clipBehavior: Clip.none,
        children: renderOrder.map((index) {
          final child = children[index];
          final bool isSelected = index == selectedIdx;
          final int diff = index - selectedIdx;

          double left;
          double top;
          double size;
          bool _isDragon(String path) => path.contains('baby_dragon');

          if (isSelected) {
            size = _isDragon(child.imagePath)
                ? selectedSize * 0.62
                : selectedSize;
            top = _isDragon(child.imagePath) ? (selectedSize - size) / 2 : 0;
            left = _isDragon(child.imagePath)
                ? selectedLeft + (selectedSize - size) / 2
                : selectedLeft;
          } else {
            size = _isDragon(child.imagePath)
                ? unselectedSize * 0.62
                : unselectedSize;
            final double step = unselectedSize * 0.35;
            if (diff < 0) {
              left =
                  selectedLeft +
                  (diff * step) -
                  (_isDragon(child.imagePath) ? -30 : 20);
            } else {
              left =
                  selectedLeft +
                  selectedSize -
                  unselectedSize +
                  (diff * step) +
                  (_isDragon(child.imagePath) ? 40 : 10);
            }
            top = _isDragon(child.imagePath)
                ? selectedSize - unselectedSize * 0.9
                : selectedSize - unselectedSize;
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
                    onSelect(newIndex); // ✅ callback call karo
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
    );
  }
}
