class ChildDashboardModel {
    ChildDashboardModel({
        required this.statusCode,
        required this.id,
        required this.name,
        required this.age,
        required this.characterId,
        required this.stars,
        required this.points,
        required this.level,
        required this.progressPercent,
    });

    final int? statusCode;
    final String? id;
    final String? name;
    final String? age;
    final String? characterId;
    final int? stars;
    final int? points;
    final int? level;
    final int? progressPercent;

    factory ChildDashboardModel.fromJson(Map<String, dynamic> json){ 
        return ChildDashboardModel(
            statusCode: json["statusCode"],
            id: json["id"],
            name: json["name"],
            age: json["age"],
            characterId: json["characterId"],
            stars: json["stars"],
            points: json["points"],
            level: json["level"],
            progressPercent: json["progressPercent"] is int
                ? json["progressPercent"]
                : int.tryParse('${json["progressPercent"]}'), // 👈 string ho ya int, dono handle
        );
    }

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "id": id,
        "name": name,
        "age": age,
        "characterId": characterId,
        "stars": stars,
        "points": points,
        "level": level,
        "progressPercent": progressPercent,
    };
}