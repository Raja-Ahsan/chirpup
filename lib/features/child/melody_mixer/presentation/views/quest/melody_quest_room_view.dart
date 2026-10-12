import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_dialog.dart';
import 'package:chirp_up_app/core/widgets/glow_image.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/quest_config_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/quiz_instrument_model.dart';
import 'package:flutter/material.dart';

class MelodyQuestRoomView extends StatefulWidget {
  final QuestConfig quest;
  final bool tapBeforeRender;
  final VoidCallback? onBack;
  final VoidCallback? onReadyToCreate;

  const MelodyQuestRoomView({
    super.key,
    required this.quest,
    this.tapBeforeRender = false,
    this.onBack,
    this.onReadyToCreate,
  });

  @override
  State<MelodyQuestRoomView> createState() => _MelodyQuestRoomViewState();
}

class _MelodyQuestRoomViewState extends State<MelodyQuestRoomView> {
  final Set<String> _placed = {};
  bool _sheetOpen = true;

  // 7-8 tap phase
  bool _tapPhase = false;
  final Set<String> _tapped = {};

  bool _rendering = false;
  bool _showStar = false;
  double _renderProgress = 0.0;

  bool get _allPlaced => _placed.length >= widget.quest.maxInstruments;
  bool get _allTapped => _tapped.length >= widget.quest.maxInstruments;

  double get _energy {
    if (widget.quest.instruments.isEmpty) return 0;
    double e = 0;
    for (final id in _placed) {
      final inst = widget.quest.instruments.firstWhere((i) => i.id == id);
      e += inst.isMain ? 0.40 : 0.30;
    }
    return e.clamp(0.0, 1.0);
  }

  void _place(String id) {
    if (_placed.length >= widget.quest.maxInstruments) return;
    setState(() => _placed.add(id));
    if (_allPlaced) {
      if (widget.tapBeforeRender) {
        setState(() => _tapPhase = true);
      } else {
        _startRender();
      }
    }
  }

  void _tapPlaced(String id) {
    if (!_tapPhase || _tapped.contains(id)) return;
    setState(() => _tapped.add(id));
    if (_allTapped) {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) _startRender();
      });
    }
  }

  void _startRender() {
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
        widget.onReadyToCreate?.call();
        return;
      }
      setState(() => _renderProgress = steps[i]);
      final d = stepDelays[i];
      i++;
      Future.delayed(d, next);
    }

    next();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final trayInstruments = widget.quest.instruments
        .where((i) => !_placed.contains(i.id))
        .toList();
    final placedInstruments = widget.quest.instruments
        .where((i) => _placed.contains(i.id))
        .toList();

    final sheetHeight = size.height * 0.34;
    final sheetHidden = _allPlaced || !_sheetOpen;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) widget.onBack?.call();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Room + DragTarget
            DragTarget<String>(
              onWillAcceptWithDetails: (_) =>
                  _placed.length < widget.quest.maxInstruments,
              onAcceptWithDetails: (d) => _place(d.data),
              builder: (context, _, __) => Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Image.asset(widget.quest.backgroundAsset, fit: BoxFit.cover),
                  if (!_rendering)
                    ...placedInstruments.map((p) {
                      final isTapped = _tapped.contains(p.id);
                      final iw = size.width * p.widthFactor;
                      return Positioned(
                        left: p.left != null ? size.width * p.left! : null,
                        right: p.right != null ? size.width * p.right! : null,
                        top: size.height * p.top,
                        child: GestureDetector(
                          onTap: _tapPhase ? () => _tapPlaced(p.id) : null,
                          child: SizedBox(
                            width: iw,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                if (isTapped)
                                  Positioned.fill(
                                    child: OverflowBox(
                                      minWidth: 0,
                                      maxWidth: double.infinity,
                                      minHeight: 0,
                                      maxHeight: double.infinity,
                                      child: Transform.translate(
                                        offset: Offset(0, -iw * 0.35),
                                        child: Image.asset(
                                          'assets/gifs/music_animation.gif',
                                          width: iw * 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                isTapped
                                    ? GlowImage(
                                        assetPath: p.roomAsset,
                                        width: iw,
                                      )
                                    : Image.asset(p.roomAsset, width: iw),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),

            // 2. Energy bar
            Positioned(
              top: topInset + 8,
              left: 50,
              right: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeadingText(
                    text: widget.quest.energyLabel,
                    fontSize: 14,
                    fontFamily: 'LuckiestGuy',
                    color: Colors.white,
                    shadowColor: Colors.transparent,
                  ),
                  const SizedBox(height: 6),
                  HorizontalLevelBar(percent: _energy),
                ],
              ),
            ),

            // 3. Back
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

            // 3b. Tap-phase guide — dim + cloud + floating star (create-room jaisa)
            if (_tapPhase && _tapped.isEmpty && !_rendering)
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
                            child: _GuideCloud(),
                          ),
                          _FloatingStar(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // 4. Tray sheet
            // 4. Tray sheet — height content ke hisaab se (fixed nahi)
            SafeArea(
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                offset: sheetHidden ? const Offset(0, 1.4) : Offset.zero,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
                      child: GridView.count(
                        shrinkWrap: true, // 👈 content jitni height
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.0,
                        children: trayInstruments
                            .map((inst) => _DraggableTile(instrument: inst))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 5. Music icon (tray toggle)
            if (!_allPlaced)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                left: 0,
                right: 0,
                bottom: _sheetOpen ? sheetHeight - 0 : bottomInset + 20,
                child: Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _sheetOpen = !_sheetOpen),
                    child: Image.asset(
                      'assets/png/melody_mixer/ui/music_icon.png',
                      width: 65,
                      height: 65,
                    ),
                  ),
                ),
              ),

            // 6. Making Magic overlay
            if (_rendering)
              Positioned.fill(
                child: Stack(
                  children: [
                    Container(color: Colors.black.withValues(alpha: 0.88)),

                    Align(
                      alignment: const Alignment(0, 0.15),
                      child: Image.asset(
                        'assets/gifs/music_animation.gif',
                        width: size.width * 0.7,
                      ),
                    ),

                    ...placedInstruments.map((p) {
                      return Positioned(
                        left: p.left != null ? size.width * p.left! : null,
                        right: p.right != null ? size.width * p.right! : null,
                        top: size.height * p.top,
                        child: GlowImage(
                          assetPath: p.roomAsset,
                          width: size.width * p.widthFactor,
                        ),
                      );
                    }),

                    Positioned(
                      top: topInset + size.height * 0.04,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: _showStar ? 1 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: _FloatingStar(),
                        ),
                      ),
                    ),

                    if (_showStar)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: bottomInset + 40,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _MakingMagicBar(percent: _renderProgress),
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

class _GuideCloud extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return CommonDialog(
      borderRadius: 24,
      child: Padding(
        padding: EdgeInsets.only(bottom: w * 0),
        child: HeadingText(
          text: 'Tap an instrument to\nplay a sound!',
          fontSize: 18,
          fontFamily: 'LuckiestGuy',
          color: AppColors.dialogHeadingColor,
          shadowColor: Colors.white,
          textAlign: TextAlign.center,
          lineSpacing: 0,
        ),
      ),
    );
  }
}

class _DraggableTile extends StatelessWidget {
  final QuestInstrument instrument;
  const _DraggableTile({required this.instrument});

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      decoration: BoxDecoration(
        color: const Color(0xFFECF3F6),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(14),
      child: Image.asset(instrument.trayAsset, fit: BoxFit.contain),
    );

    return Draggable<String>(
      data: instrument.id,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(instrument.trayAsset, fit: BoxFit.contain),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: tile),
      child: tile,
    );
  }
}

class _FloatingStar extends StatefulWidget {
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
    final h = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: _a,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, _a.value), child: child),
      child: Image.asset(
        'assets/png/melody_mixer/ui/guide_star.png',
        height: h * 0.25,
      ),
    );
  }
}

class _MakingMagicBar extends StatelessWidget {
  final double percent;
  const _MakingMagicBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width * 0.62;
    const h = 24.0;
    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF868381),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              width: w * percent,
              height: h,
              decoration: BoxDecoration(
                color: AppColors.greenColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalLevelBar extends StatelessWidget {
  final double percent;

  const HorizontalLevelBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double barWidth = screenWidth * 0.55;
    const double barHeight = 23.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: barWidth,
          height: barHeight,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: barWidth,
                height: barHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF8E8780),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                width: barWidth * percent,
                height: barHeight,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.whiteColor, width: 1.5),
                ),
              ),
              Positioned(
                left: (barWidth * percent) / 1.8,
                child: SizedBox(
                  width: 40,
                  child: HeadingText(
                    text: '${(percent * 100).toInt()}%',
                    fontSize: 14,
                    shadowColor: const Color(0xff594FAD),
                    textAlign: TextAlign.center,
                    lineSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
