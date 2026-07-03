class ChildWeekStatusModel {
    ChildWeekStatusModel({
        required this.statusCode,
        required this.weeklyJourney,
        required this.moodThisWeek,
        required this.moodSummary,
    });

    final num? statusCode;
    final WeeklyJourney? weeklyJourney;
    final MoodThisWeek? moodThisWeek;
    final String? moodSummary;

    factory ChildWeekStatusModel.fromJson(Map<String, dynamic> json){ 
        return ChildWeekStatusModel(
            statusCode: json["statusCode"],
            weeklyJourney: json["weeklyJourney"] == null ? null : WeeklyJourney.fromJson(json["weeklyJourney"]),
            moodThisWeek: json["moodThisWeek"] == null ? null : MoodThisWeek.fromJson(json["moodThisWeek"]),
            moodSummary: json["moodSummary"],
        );
    }

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "weeklyJourney": weeklyJourney?.toJson(),
        "moodThisWeek": moodThisWeek?.toJson(),
        "moodSummary": moodSummary,
    };

}

class MoodThisWeek {
    MoodThisWeek({
        required this.mon,
        required this.tue,
        required this.wed,
        required this.thu,
        required this.fri,
        required this.sat,
        required this.sun,
    });

    final dynamic mon;
    final dynamic tue;
    final dynamic wed;
    final dynamic thu;
    final dynamic fri;
    final dynamic sat;
    final dynamic sun;

    factory MoodThisWeek.fromJson(Map<String, dynamic> json){ 
        return MoodThisWeek(
            mon: json["mon"],
            tue: json["tue"],
            wed: json["wed"],
            thu: json["thu"],
            fri: json["fri"],
            sat: json["sat"],
            sun: json["sun"],
        );
    }

    Map<String, dynamic> toJson() => {
        "mon": mon,
        "tue": tue,
        "wed": wed,
        "thu": thu,
        "fri": fri,
        "sat": sat,
        "sun": sun,
    };

}

class WeeklyJourney {
    WeeklyJourney({
        required this.breathing,
        required this.creative,
        required this.gratitude,
        required this.music,
    });

    final num? breathing;
    final num? creative;
    final num? gratitude;
    final num? music;

    factory WeeklyJourney.fromJson(Map<String, dynamic> json){ 
        return WeeklyJourney(
            breathing: json["breathing"],
            creative: json["creative"],
            gratitude: json["gratitude"],
            music: json["music"],
        );
    }

    Map<String, dynamic> toJson() => {
        "breathing": breathing,
        "creative": creative,
        "gratitude": gratitude,
        "music": music,
    };

}
