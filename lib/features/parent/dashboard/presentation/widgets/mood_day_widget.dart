import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class MoodDayItem extends StatefulWidget {
  final MoodItem mood;

  const MoodDayItem({required this.mood});

  @override
  State<MoodDayItem> createState() => _MoodDayItemState();
}

class _MoodDayItemState extends State<MoodDayItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 150),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_visible) {
      await _controller.reverse();
      if (mounted) setState(() => _visible = false);
    } else {
      setState(() => _visible = true);
      _controller.forward();
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _visible) {
        await _controller.reverse();
        if (mounted) setState(() => _visible = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize =
        (MediaQuery.of(context).size.width -
            (AppSizes.horizontalPadding * 2) -
            32 -
            (6 * 8)) /
        6.5;

    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: iconSize,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff4299D9),
                ),
                padding: const EdgeInsets.all(6),
                child: Image.asset(widget.mood.imagePath, fit: BoxFit.contain),
              ),

              // ✅ Animated cloud tooltip
              if (_visible)
                Positioned(
                  bottom: 52,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/png/cloud.png',
                            width: 70,
                            height: 44,
                            fit: BoxFit.contain,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: HeadingText(
                              text: 'Calm',
                              fontSize: 14,
                              weight: FontWeight.w400,
                              shadowColor: AppColors.textShadowDarkBlue,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          CustomText(
            text: widget.mood.day,
            fontSize: 14,
            textAlign: TextAlign.center,
            fontFamily: 'LuckiestGuy',
          ),
        ],
      ),
    );
  }
}

class MoodItem {
  final String day;
  final String imagePath;

  const MoodItem({required this.day, required this.imagePath});
}