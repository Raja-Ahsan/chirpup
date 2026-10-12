import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/mood_config_model.dart';
import 'package:flutter/material.dart';

class MelodyMoodSelectGridView extends StatefulWidget {
  final String backgroundAsset;
  final List<MoodConfig> moods;
  final ValueChanged<MoodConfig> onContinue;
  final VoidCallback? onBack;

  const MelodyMoodSelectGridView({
    super.key,
    required this.backgroundAsset,
    required this.moods,
    required this.onContinue,
    this.onBack,
  });

  @override
  State<MelodyMoodSelectGridView> createState() =>
      _MelodyMoodSelectGridViewState();
}

class _MelodyMoodSelectGridViewState extends State<MelodyMoodSelectGridView> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B3A6B), Color(0xFF2E5C9E)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(widget.backgroundAsset, fit: BoxFit.cover),

            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: topInset + 50,
                  bottom: bottomInset + 90,
                ),

                child: Column(
                  children: [
                    // title
                    HeadingText(
                      text: 'How does your\nsong feel?',
                      fontSize: 28,
                      fontFamily: 'LuckiestGuy',
                      color: AppColors.textYellow,
                      shadowColor: Colors.black,
                      textAlign: TextAlign.center,
                      lineSpacing: 0,
                    ),
                    // mood grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 5,
                        childAspectRatio: 1.1,
                        physics: const NeverScrollableScrollPhysics(),
                        children: widget.moods.map((m) {
                          final isSelected = m.id == _selectedId;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedId = m.id),
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 200),
                              scale: isSelected ? 1.04 : 1.0,
                              child: Opacity(
                                opacity: isSelected ? 1.0 : 0.9,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.asset(
                                        m.cardBgAsset ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                        horizontal: 10,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            m.iconAsset,
                                            width: 72,
                                            height: 76,
                                          ),
                                          const SizedBox(height: 8),
                                          HeadingText(
                                            text: m.label.toUpperCase(),
                                            fontSize: 18,
                                            color: m.labelColor,
                                            shadowColor: Colors.white,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Continue button — bottom fixed
            Positioned(
              left: 15,
              right: 15, // 👈 right add (poori width)
              bottom: bottomInset + 16, // 👈 bottom se, topInset nahi
              child: CommonButton(
                title: 'Continue Creating',
                bgColor: AppColors.blueColor,
                shadowColor: AppColors.textShadowBlue,
                onPressed: _selectedId == null
                    ? null
                    : () {
                        final mood = widget.moods.firstWhere(
                          (m) => m.id == _selectedId,
                        );
                        widget.onContinue(mood);
                      },
              ),
            ),

            // back
            if (widget.onBack != null)
              Positioned(
                top: topInset + 8,
                left: 15,
                child: GestureDetector(
                  onTap: widget.onBack,
                  child: Image.asset(
                    'assets/png/back_button.png',
                    height: 45,
                    width: 45,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
