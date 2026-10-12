import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/common_dialog.dart';
import 'package:chirp_up_app/core/widgets/confirmation_dialog.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/glow_image.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/config/instrument_patterns.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/instrument_placement_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/services/beat_clock.dart';
import 'package:chirp_up_app/features/child/melody_mixer/services/melody_recorder.dart';
import 'package:chirp_up_app/features/child/melody_mixer/services/melody_sequencer.dart';
import 'package:chirp_up_app/features/child/melody_mixer/services/soloud_audio_engine.dart';
import 'package:flutter/material.dart';

class MelodyPlayRoomView extends StatefulWidget {
  final String backgroundAsset;
  final List<InstrumentPlacement> instruments;
  final bool showGuide;
  final String moodBadgeLabel;
  final String? moodBadgeIcon;
  final Color badgeColor;
  final VoidCallback? onBack;
  final bool showRecordButton;
  final VoidCallback? onRecordTap;
  final bool showSongsOnExit;

  const MelodyPlayRoomView({
    super.key,
    required this.backgroundAsset,
    required this.instruments,
    this.showGuide = false,
    this.moodBadgeLabel = '',
    this.moodBadgeIcon,
    this.badgeColor = Colors.white,
    this.onBack,
    this.showRecordButton = false,
    this.onRecordTap,
    this.showSongsOnExit = false,
  });

  @override
  State<MelodyPlayRoomView> createState() => _MelodyPlayRoomViewState();
}

class _MelodyPlayRoomViewState extends State<MelodyPlayRoomView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  late AnimationController _guideController;
  late Animation<double> _guideScale;

  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  bool _guideDismissed = false;
  bool _isRecording = false;
  bool _showSongs = false;

  final Set<int> _glowing = {};

  // audio + beat clock
  final SoLoudAudioEngine _engine = SoLoudAudioEngine();
  final BeatClock _clock = BeatClock(bpm: 100);
  late final InstrumentPlayer _player = InstrumentPlayer(_engine, _clock);

  // recording
  final MelodyRecorder _recorder = MelodyRecorder();
  late final MelodySequencer _sequencer = MelodySequencer(_player);
  List<RecordedEvent> _recordedSong = [];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _guideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _guideScale = CurvedAnimation(
      parent: _guideController,
      curve: Curves.elasticOut,
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _engine.preload(allSoundAssets);
    _clock.start();

    if (widget.showGuide) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _guideController.forward(),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _guideController.dispose();
    _floatController.dispose();
    _sequencer.stop();
    _clock.stop();
    _engine.dispose();
    super.dispose();
  }

  void _onBackPressed() {
    showCommonDialog(
      context: context,
      child: confirmationDialog(
        context,
        'Are you sure you want\nto leave?',
        onConfirm: () {
          if (widget.showSongsOnExit) {
            setState(() => _showSongs = true);
          } else {
            widget.onBack?.call();
          }
        },
        headingText: 'Leave',
        buttonBgColor: AppColors.buttonRed,
        showCloseButton: false,
      ),
    );
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      _recorder.start(); // recording shuru
    } else {
      _recordedSong = _recorder.stop(); // band + events save
    }
    widget.onRecordTap?.call();
  }

  void _tapInstrument(int index) {
    final id = widget.instruments[index].id;
    if (_isRecording) _recorder.capture(id); // record ho raha to capture
    _player.playPhrase(
      id,
      onStart: () {
        if (mounted) setState(() => _glowing.add(index));
      },
      onEnd: () {
        if (mounted) setState(() => _glowing.remove(index));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) _onBackPressed();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background
            Image.asset(widget.backgroundAsset, fit: BoxFit.cover),

            // 2. Instruments — tap pe glow + gif + sound + record
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                return Stack(
                  clipBehavior: Clip.none,
                  children: List.generate(widget.instruments.length, (i) {
                    final p = widget.instruments[i];
                    final isGlowing = _glowing.contains(i);
                    final iw = w * p.widthFactor;
                    return Positioned(
                      left: p.left != null ? w * p.left! : null,
                      right: p.right != null ? w * p.right! : null,
                      top: h * p.top,
                      child: GestureDetector(
                        onTap: () => _tapInstrument(i),
                        child: SizedBox(
                          width: iw,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              if (isGlowing)
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
                              isGlowing
                                  ? GlowImage(assetPath: p.assetPath, width: iw)
                                  : Image.asset(p.assetPath, width: iw),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),

            // 3. Mood badge
            if (widget.moodBadgeLabel.isNotEmpty)
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

            // 4. Back button
            if (widget.onBack != null)
              Positioned(
                top: topInset + 8,
                left: 12,
                child: GestureDetector(
                  onTap: _onBackPressed,
                  child: Image.asset(
                    'assets/png/back_button.png',
                    height: 48,
                    width: 48,
                  ),
                ),
              ),

            // 5. Guide overlay
            if (widget.showGuide && !_guideDismissed)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _guideDismissed = true),
                  child: Stack(
                    children: [
                      Container(color: Colors.black.withValues(alpha: 0.55)),
                      ScaleTransition(
                        scale: _guideScale,
                        child: Column(
                          children: [
                            SizedBox(height: topInset + size.height * 0.10),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: _GuideCloud(),
                            ),
                            AnimatedBuilder(
                              animation: _floatAnim,
                              builder: (context, child) => Transform.translate(
                                offset: Offset(0, _floatAnim.value),
                                child: child,
                              ),
                              child: Image.asset(
                                'assets/png/melody_mixer/ui/guide_star.png',
                                height: size.height * 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 6. Record button
            if (widget.showRecordButton)
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).padding.bottom,
                child: SafeArea(
                  child: Center(
                    child: GestureDetector(
                      onTap: _toggleRecording,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 71,
                        height: 71,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(5),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5E5E),
                            borderRadius: BorderRadius.circular(
                              _isRecording ? 14 : 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // 7. "Your {mood} Songs" overlay — asli recorded song
            if (_showSongs)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.70),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const Spacer(flex: 1),
                          CustomText(
                            text: 'Your ${widget.moodBadgeLabel}\nSongs',
                            fontSize: 28,
                            fontFamily: 'LuckiestGuy',
                            color: AppColors.textYellow,
                            textAlign: TextAlign.center,
                            lineSpacing: 0,
                          ),
                          const Spacer(flex: 3),
                          if (_recordedSong.isNotEmpty)
                            _RecordedSongTile(
                              durationMs: _recorder.durationMs,
                              onPlay: () => _sequencer.play(
                                _recordedSong,
                                durationMs: _recorder.durationMs,
                              ),
                              onStop: () => _sequencer.stop(),
                            )
                          else
                            CustomText(
                              text: 'No song recorded yet',
                              fontSize: 16,
                              color: Colors.white,
                              textAlign: TextAlign.center,
                            ),
                          const Spacer(flex: 3),
                          CommonButton(
                            title: 'Return to Music Hall',
                            onPressed: widget.onBack,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // 8. White fade
            Positioned.fill(
              child: IgnorePointer(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(color: Colors.white),
                ),
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

class _RecordedSongTile extends StatefulWidget {
  final int durationMs;
  final VoidCallback onPlay; // sequencer play
  final VoidCallback onStop; // sequencer stop
  const _RecordedSongTile({
    required this.durationMs,
    required this.onPlay,
    required this.onStop,
  });

  @override
  State<_RecordedSongTile> createState() => _RecordedSongTileState();
}

class _RecordedSongTileState extends State<_RecordedSongTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _progress;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _progress =
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: widget.durationMs),
        )..addStatusListener((s) {
          if (s == AnimationStatus.completed) {
            // song khatam → reset
            setState(() => _playing = false);
            _progress.reset();
          }
        });
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_playing) {
      // pause → stop
      widget.onStop();
      _progress.stop();
      setState(() => _playing = false);
    } else {
      // play → 0 se shuru
      widget.onPlay();
      _progress.forward(from: 0);
      setState(() => _playing = true);
    }
  }

  String _fmt(int ms) {
    final s = (ms / 1000).round();
    return '00:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EDEC),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // play / pause toggle (asset change)
          GestureDetector(
            onTap: _toggle,
            child: Image.asset(
              _playing
                  ? 'assets/png/melody_mixer/ui/pause_button.png'
                  : 'assets/png/melody_mixer/ui/play_button.png',
              width: 53,
              height: 53,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: _progress,
              builder: (context, _) {
                // current time = progress × duration; playing nahi to poori duration dikhe
                final elapsedMs = _playing || _progress.value > 0
                    ? (_progress.value * widget.durationMs).round()
                    : widget.durationMs;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progress.value, // 👈 waqt ke saath bharta
                        minHeight: 6,
                        backgroundColor: const Color(0xFFCCC8D0),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF645973),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: _fmt(elapsedMs), // 👈 time count
                      fontSize: 16,
                      fontFamily: 'LuckiestGuy',
                      weight: FontWeight.w400,
                      color: const Color(0xFF645973),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
