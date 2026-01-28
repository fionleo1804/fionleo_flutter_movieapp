class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) =>
      Genre(id: json['id'], name: json['name'] ?? '');

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class ReleaseDate {
  final String certification;
  ReleaseDate({required this.certification});

  factory ReleaseDate.fromJson(Map<String, dynamic> json) =>
      ReleaseDate(certification: json['certification'] ?? '');

  Map<String, dynamic> toJson() => {'certification': certification};
}

class ReleaseDateResult {
  final String iso3166_1;
  final List<ReleaseDate> releaseDates;

  ReleaseDateResult({required this.iso3166_1, required this.releaseDates});

  factory ReleaseDateResult.fromJson(Map<String, dynamic> json) {
    final list = (json['release_dates'] as List<dynamic>?)
            ?.map((d) => ReleaseDate.fromJson(d))
            .toList() ??
        [];
    return ReleaseDateResult(
      iso3166_1: json['iso_3166_1'] ?? '',
      releaseDates: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'iso_3166_1': iso3166_1,
        'release_dates': releaseDates.map((e) => e.toJson()).toList(),
      };
}

class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final double popularity;
  final String overview;
  final List<Genre>? genres;
  final String originalLanguage;
  final int? runtime;
  final List<ReleaseDateResult>? releaseDates;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.popularity,
    required this.overview,
    this.genres,
    required this.originalLanguage,
    this.runtime,
    this.releaseDates,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      popularity: (json['popularity'] ?? 0).toDouble(),
      overview: json['overview'] ?? '',
      genres: (json['genres'] as List<dynamic>?)
          ?.map((g) => Genre.fromJson(g))
          .toList(),
      originalLanguage: json['original_language'] ?? '',
      runtime: json['runtime'],
      releaseDates: (json['release_dates']?['results'] as List<dynamic>?)
          ?.map((r) => ReleaseDateResult.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'popularity': popularity,
      'overview': overview,
      'original_language': originalLanguage,
      'runtime': runtime,
      'genres': genres?.map((g) => g.toJson()).toList(),
      'release_dates': releaseDates != null 
          ? {'results': releaseDates!.map((r) => r.toJson()).toList()} 
          : null,
    };
  }

  String get posterUrl {
    return posterPath != null && posterPath!.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : '';
  }

  String get backdropUrl {
    return backdropPath != null && backdropPath!.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w780$backdropPath'
        : '';
  }

  bool get hasPoster => 
      posterPath != null && 
      posterPath!.isNotEmpty && 
      posterPath != 'null';

  bool get hasBackdrop => 
      backdropPath != null && 
      backdropPath!.isNotEmpty && 
      backdropPath != 'null';
}
