class CharacterModel {
  final int id;
  final String name;
  final String slug;
  final String speciality;   // API ke "description" se aayega
  final String imagePath;    // API ke "image_url" se aayega (network image)
  final String avatarImage;  // API mein nahi hai — slug se local asset map kiya
  final String status;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.speciality,
    required this.imagePath,
    required this.avatarImage,
     required this.status,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    final String slug = json['slug']?.toString() ?? '';
    return CharacterModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: slug,
      speciality: json['description']?.toString() ?? '',
      imagePath: json['image_url']?.toString() ?? '',
      avatarImage: _avatarForSlug(slug),
      status: json['status']?.toString() ?? '',
    );
  }

  // 👇 API response mein avatar nahi aata — agli screen (jahan chhota
  // avatar chahiye) ke liye slug ke hisab se local bundled asset use
  // karte hain, taake us flow ko chhedna na pade
  static String _avatarForSlug(String slug) {
    const Map<String, String> avatarBySlug = {
      'prince': 'assets/png/prince_avatar.png',
      'princess': 'assets/png/princess_avatar.png',
      'knight': 'assets/png/knight_avatar.png',
      'baby-dragon': 'assets/png/baby_dragon_avatar.png',
    };
    return avatarBySlug[slug] ?? 'assets/png/prince_avatar.png';
  }
}