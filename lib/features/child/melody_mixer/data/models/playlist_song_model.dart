class PlaylistSong {
  final String id;
  final String title;
  final String duration;
  final double progress;
  final String group; 

  const PlaylistSong({
    required this.id,
    required this.title,
    required this.duration,
    required this.group,
    this.progress = 0.0,
  });
}