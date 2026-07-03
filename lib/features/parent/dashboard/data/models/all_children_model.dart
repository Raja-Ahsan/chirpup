class AllChildrenModel {
    AllChildrenModel({
        required this.statusCode,
        required this.children,
    });

    final num? statusCode;
    final List<Child> children;

    factory AllChildrenModel.fromJson(Map<String, dynamic> json){ 
        return AllChildrenModel(
            statusCode: json["statusCode"],
            children: json["children"] == null ? [] : List<Child>.from(json["children"]!.map((x) => Child.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "children": children.map((x) => x?.toJson()).toList(),
    };

}

class Child {
    Child({
        required this.id,
        required this.name,
        required this.age,
        required this.characterId,
        required this.stars,
        required this.ponums,
        required this.level,
        required this.progressPercent,
    });

    final String? id;
    final String? name;
    final String? age;
    final String? characterId;
    final num? stars;
    final num? ponums;
    final num? level;
    final String? progressPercent;

    factory Child.fromJson(Map<String, dynamic> json){ 
        return Child(
            id: json["id"],
            name: json["name"],
            age: json["age"],
            characterId: json["characterId"],
            stars: json["stars"],
            ponums: json["ponums"],
            level: json["level"],
            progressPercent: json["progressPercent"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "age": age,
        "characterId": characterId,
        "stars": stars,
        "ponums": ponums,
        "level": level,
        "progressPercent": progressPercent,
    };

}
