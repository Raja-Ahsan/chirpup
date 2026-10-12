import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/common_dialog.dart';
import 'package:chirp_up_app/core/widgets/glow_image.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/age_9plus_config.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/instrument_placement_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/create/melody_ready_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/reflect/journey_complete_view.dart';
import 'package:chirp_up_app/features/child/melody_mixer/presentation/views/reflect/reflect_view.dart';
import 'package:flutter/material.dart';

class MelodyCreateGenerateView extends StatefulWidget {
  final String backgroundAsset;
  final List<InstrumentPlacement> instruments;
  final String moodBadgeLabel;
  final String? moodBadgeIcon;
  final Color badgeColor;
  final int maxSelect;
  final VoidCallback? onBack;

  const MelodyCreateGenerateView({
    super.key,
    required this.backgroundAsset,
    required this.instruments,
    this.moodBadgeLabel = '',
    this.moodBadgeIcon,
    this.badgeColor = Colors.white,
    this.maxSelect = 3,
    this.onBack,
  });

  @override
  State<MelodyCreateGenerateView> createState() =>
      _MelodyCreateGenerateViewState();
}

class _MelodyCreateGenerateViewState extends State<MelodyCreateGenerateView> {
  final List<String> _selected = [];
  bool _showGuide = true;
  bool _rendering = false;
  bool _showStar = false;
  double _renderProgress = 0.0;

  bool get _allSelected => _selected.length >= widget.maxSelect;

  void _toggle(String id) {
    if (_rendering) return;
    setState(() {
      if (_showGuide) _showGuide = false;
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < widget.maxSelect) {
        _selected.add(id);
      }
    });
  }

  void _createMelody() {
    setState(() => _rendering = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _showStar = true);
      _runProgress();
    });
  }

  void _runProgress() {
    const steps = [0.10, 0.30, 0.60, 0.90, 1.0];
    const stepDelays = [
      Duration(milliseconds: 500),
      Duration(seconds: 2),
      Duration(seconds: 2),
      Duration(seconds: 3),
      Duration(milliseconds: 2500),
    ];
    int i = 0;
    void next() {
      if (!mounted) return;
      if (i >= steps.length) {
        _openMelodyReady();
        return;
      }
      setState(() => _renderProgress = steps[i]);
      final d = stepDelays[i];
      i++;
      Future.delayed(d, next);
    }

    next();
  }

  void _openMelodyReady() {
    // selected 3 instruments
    final selected = widget.instruments
        .where((p) => _selected.contains(p.id))
        .toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (readyCtx) => MelodyReadyView(
          backgroundAsset:
              'assets/png/melody_mixer/backgrounds/winning_background.png',
          instruments: selected,
          moodLabel: widget.moodBadgeLabel,
          moodBadgeAsset: widget.moodBadgeIcon,
          stars: 3,
          coins: 15,

          // Save Melody → Reflect
          onSave: () {
            Navigator.push(
              readyCtx,
              MaterialPageRoute(
                builder: (reflectCtx) => MelodyReflectView(
                  backgroundAsset:
                      'assets/png/melody_mixer/backgrounds/winning_background.png',
                  tags: reflectionTags,

                  // Save Reflection → Journey Complete
                  // Save Reflection → Journey Complete
                  onSave: (tagId, note) {
                    final tag = reflectionTags.firstWhere((t) => t.id == tagId);
                    Navigator.pushReplacement(
                      reflectCtx,
                      MaterialPageRoute(
                        builder: (journeyCtx) => MelodyJourneyCompleteView(
                          // 👈 journeyCtx
                          backgroundAsset:
                              'assets/png/melody_mixer/backgrounds/winning_background.png',
                          instruments: selected,
                          moodLabel: widget.moodBadgeLabel,
                          moodBadgeAsset: widget.moodBadgeIcon,
                          inspiration: tag,
                          starsEarned: 2,
                          onReturn: () => Navigator.popUntil(
                            journeyCtx,
                            (r) => r.settings.name == 'melody_hub',
                          ),
                          onCreateAnother: () => Navigator.popUntil(
                            journeyCtx,
                            (r) => r.settings.name == 'melody_hub',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },

          onReturn: () => Navigator.of(readyCtx)
            ..pop()
            ..pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final selectedPlacements = widget.instruments
        .where((p) => _selected.contains(p.id))
        .toList();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) widget.onBack?.call();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background
            Image.asset(widget.backgroundAsset, fit: BoxFit.cover),

            // 2. Instruments — room mein fix, tap to select (glow jab selected)
            if (!_rendering)
              ...widget.instruments.map((p) {
                final isSelected = _selected.contains(p.id);
                final iw = size.width * p.widthFactor;
                return Positioned(
                  left: p.left != null ? size.width * p.left! : null,
                  right: p.right != null ? size.width * p.right! : null,
                  top: size.height * p.top,
                  child: GestureDetector(
                    onTap: () => _toggle(p.id),
                    child: isSelected
                        ? GlowImage(assetPath: p.assetPath, width: iw)
                        : Image.asset(p.assetPath, width: iw),
                  ),
                );
              }),

            // 3. Mood badge — top center
            if (widget.moodBadgeLabel.isNotEmpty && !_rendering)
              Positioned(
                top: topInset + 12,
                left: 0,
                right: 0,
                child: Center(
                  child: CommonButton(
                    title: widget.moodBadgeLabel,
                    horizontalPadding: 18,
                    bgColor: widget.badgeColor,
                    borderRadius: 24,
                    borderColor: Colors.transparent,
                    icon: Image.asset(
                      '${widget.moodBadgeIcon}',
                      width: 35,
                      height: 35,
                    ),
                    verticalPadding: 2,
                    shadowColor: const Color(0xFF6E613E),
                  ),
                ),
              ),

            // 4. Notes indicator — 3 notes, fill on select
            if (!_rendering)
              Positioned(
                top: topInset + 80,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff34251D),
                      border: Border.all(color: Color(0xffAB9993), width: 0),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(widget.maxSelect, (i) {
                        final filled = i < _selected.length;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Image.asset(
                            'assets/png/melody_mixer/ui/lyrics_icon.png',
                            width: 18,
                            height: 18,
                            color: filled
                                ? AppColors.textYellow
                                : Color(0xffA5A7A3),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),

            // 5. Back
            if (widget.onBack != null && !_rendering)
              Positioned(
                top: topInset + 4,
                left: 12,
                child: GestureDetector(
                  onTap: widget.onBack,
                  child: Image.asset(
                    'assets/png/back_button.png',
                    height: 45,
                    width: 45,
                  ),
                ),
              ),

            // 6. Guide — "Pick up to 3 sounds" (dim + cloud + floating star)
            if (_showGuide && !_rendering)
              Positioned.fill(
                child: IgnorePointer(
                  child: Stack(
                    children: [
                      Container(color: Colors.black.withValues(alpha: 0.55)),
                      Column(
                        children: [
                          SizedBox(height: topInset + size.height * 0.10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: const _GenerateGuideCloud(),
                          ),
                          _FloatingStar(height: size.height * 0.3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // 7. "Create My Melody" button — bottom
            if (!_rendering)
              Positioned(
                left: 16,
                right: 16,
                bottom: bottomInset + 16,
                child: CommonButton(
                  title: 'Create My Melody',
                  onPressed: _allSelected ? _createMelody : null,
                ),
              ),

            // 8. Making Magic overlay
            if (_rendering)
              Positioned.fill(
                child: Stack(
                  children: [
                    Container(color: Colors.black.withValues(alpha: 0.88)),

                    // music gif — instruments ke peeche, center
                    Align(
                      alignment: const Alignment(0, 0.15),
                      child: Image.asset(
                        'assets/gifs/music_animation.gif',
                        width: size.width * 0.7,
                      ),
                    ),

                    // selected instruments — apni room position pe glow
                    ...selectedPlacements.map((p) {
                      return Positioned(
                        left: p.left != null ? size.width * p.left! : null,
                        right: p.right != null ? size.width * p.right! : null,
                        top: size.height * p.top,
                        child: GlowImage(
                          assetPath: p.assetPath,
                          width: size.width * p.widthFactor,
                        ),
                      );
                    }),

                    // star — floating
                    Positioned(
                      top: topInset + size.height * 0.04,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: _showStar ? 1 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: _FloatingStar(height: size.height * 0.20),
                        ),
                      ),
                    ),

                    // loader
                    if (_showStar)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: bottomInset + 40,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _MagicBar(percent: _renderProgress),
                            const SizedBox(height: 10),
                            HeadingText(
                              text: 'Making Magic',
                              fontSize: 14,
                              fontFamily: 'LuckiestGuy',
                              color: Colors.white,
                              shadowColor: Colors.transparent,
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

class _GenerateGuideCloud extends StatelessWidget {
  const _GenerateGuideCloud();
  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      borderRadius: 24,
      child: HeadingText(
        text: 'Pick up to 3\nsounds for your\nMelody',
        fontSize: 18,
        fontFamily: 'LuckiestGuy',
        color: AppColors.dialogHeadingColor,
        shadowColor: Colors.white,
        textAlign: TextAlign.center,
        lineSpacing: 0,
      ),
    );
  }
}

// floating star — up/down loop
class _FloatingStar extends StatefulWidget {
  final double height;
  const _FloatingStar({required this.height});

  @override
  State<_FloatingStar> createState() => _FloatingStarState();
}

class _FloatingStarState extends State<_FloatingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _a = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, _a.value), child: child),
      child: Image.asset(
        'assets/png/melody_mixer/ui/guide_star.png',
        height: widget.height,
      ),
    );
  }
}

class _MagicBar extends StatelessWidget {
  final double percent;
  const _MagicBar({required this.percent});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width * 0.62;
    return SizedBox(
      width: w,
      height: 24,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF868381),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            width: w * percent,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.greenColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
