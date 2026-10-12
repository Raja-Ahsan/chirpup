enum MixerStage {
  moodSelect, intro, play, review, celebration,
  hub, instrumentPick, renderMelody, melodyReady,
  reflect, journeyComplete,
  questIntro, questPick, questPlay, questRender, questResult, questReward,
  playlistCategory, playlistSongs,
}

enum InteractionMode { tapAnywhere, freePlay, generate, guidedQuest }

enum MixerEntry { direct, hub }

enum MixerFlowId { createSong, quest, playlist, reflect }