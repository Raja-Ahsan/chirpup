import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/mood_config_model.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/playlist_song_model.dart';
import 'package:flutter/material.dart';

class MelodyPlaylistView extends StatefulWidget {
  final List<MoodConfig> moods;
  final String initialMoodId;
  final List<PlaylistSong> songs;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onStartNewSong;
  final ValueChanged<MoodConfig> onMoodChanged;

  const MelodyPlaylistView({
    super.key,
    required this.moods,
    required this.initialMoodId,
    required this.songs,
    required this.onBack,
    required this.onSearch,
    required this.onStartNewSong,
    required this.onMoodChanged,
  });

  @override
  State<MelodyPlaylistView> createState() => _MelodyPlaylistViewState();
}

class _MelodyPlaylistViewState extends State<MelodyPlaylistView> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialMoodId;
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final topInset = MediaQuery.of(context).padding.top;

    // today/yesterday grouping
    final today = widget.songs.where((s) => s.group == 'today').toList();
    final yesterday = widget.songs
        .where((s) => s.group == 'yesterday')
        .toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/png/melody_mixer/backgrounds/winning_background.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(height: 10),

              // ── Top row: back + title + search ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Image.asset(
                        'assets/png/back_button.png',
                        height: 45,
                        width: 45,
                      ),
                    ),
                    Expanded(
                      child: HeadingText(
                        text: 'Your Songs',
                        fontSize: 28,
                        weight: FontWeight.w400,
                        fontFamily: 'LuckiestGuy',
                        color: AppColors.textYellow,
                        shadowColor: Color(0xFF272727),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onSearch,
                      child: Image.asset(
                        'assets/png/melody_mixer/ui/search_button.png',
                        height: 45,
                        width: 45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),
              CustomText(
                text: 'Listen to the melodies you\ncreated for each mood!',
                fontSize: 14,
                weight: FontWeight.w700,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // ── Mood selector: selected center bada, baaki chhote/dim ──
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height:
                        constraints.maxWidth * 0.28 +
                        40, // selectedSize + label
                    child: _MoodSelector(
                      moods: widget.moods,
                      selectedId: _selectedId,
                      availableWidth: constraints.maxWidth, // 👈 width do
                      onSelect: (m) {
                        setState(() => _selectedId = m.id);
                        widget.onMoodChanged(m);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // ── Songs sheet (white, rounded top) ──
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 12),
                          children: [
                            if (today.isNotEmpty) ...[
                              _groupLabel('today'),
                              ...today.map((s) => _SongTile(song: s)),
                            ],
                            if (yesterday.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _groupLabel('yesterday'),
                              ...yesterday.map((s) => _SongTile(song: s)),
                            ],
                          ],
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: CommonButton(
                            title: 'Add Song',
                            onPressed: widget.onBack,
                            borderColor: AppColors.textshadowGreen,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _groupLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 6, bottom: 8),
    child: CustomText(
      text: text,
      fontSize: 16,
      weight: FontWeight.w700,
      color: AppColors.dialogGreyTextColor,
    ),
  );
}

class _MoodSelector extends StatelessWidget {
  final List<MoodConfig> moods;
  final String selectedId;
  final ValueChanged<MoodConfig> onSelect;
  final double availableWidth;
  const _MoodSelector({
    required this.moods,
    required this.selectedId,
    required this.onSelect,
    required this.availableWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (moods.isEmpty) return const SizedBox();

    final selectedIdx = moods.indexWhere((m) => m.id == selectedId);
    final selectedMood = moods[selectedIdx];
    final w = availableWidth;
    final double selectedSize = w * 0.28;
    final double unselectedSize = w * 0.20;
    final double selectedLeft = (w - selectedSize) / 2;

    final renderOrder = [
      ...List.generate(moods.length, (i) => i).where((i) => i != selectedIdx),
      selectedIdx,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── icons (slide) ──
        SizedBox(
          height: selectedSize,
          width: w,
          child: Stack(
            clipBehavior: Clip.none,
            children: renderOrder.map((index) {
              final mood = moods[index];
              final isSelected = index == selectedIdx;
              final diff = index - selectedIdx;
              final size = isSelected ? selectedSize : unselectedSize;

              double left;
              if (isSelected) {
                left = selectedLeft;
              } else {
                final step = unselectedSize * 1.15;
                if (diff < 0) {
                  left = selectedLeft + (diff * step);
                } else {
                  left =
                      selectedLeft +
                      (selectedSize - unselectedSize) +
                      (diff * step);
                }
              }

              return AnimatedPositioned(
                key: ValueKey('mood_$index'),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: left,
                top: isSelected
                    ? 0
                    : (selectedSize - unselectedSize) / 2, // bottom-ish align
                width: size,
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerUp: (_) {
                    if (!isSelected) onSelect(mood);
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isSelected ? 1.0 : 0.45,
                    child: Image.asset(mood.iconAsset, height: size),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 8),

        // ── label (FIXED jagah, sirf text change — no slide) ──
        HeadingText(
          text: selectedMood.label.toUpperCase(),
          fontSize: 22,
          fontFamily: 'LuckiestGuy',
          color: AppColors.textYellow,
          shadowColor: Colors.black,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Song tile ──
class _SongTile extends StatelessWidget {
  final PlaylistSong song;
  const _SongTile({required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EDEC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/png/melody_mixer/ui/play_button.png',
              width: 53,
              height: 53,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                HeadingText(
                  text: song.title.toUpperCase(),
                  fontSize: 14,
                  weight: FontWeight.w400,
                  shadowColor: Colors.transparent,
                  color: const Color(0xFF645973),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: song.progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFCCC8D0),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF645973)),
                  ),
                ),
                const SizedBox(height: 8),
                HeadingText(
                  text: song.duration,
                  fontSize: 14,
                  shadowColor: Colors.transparent,
                  fontFamily: 'LuckiestGuy',
                  color: const Color(0xFF645973),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.more_vert, color: Color(0xFF645973), size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
