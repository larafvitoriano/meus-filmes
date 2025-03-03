class Movie {
  int? id;
  String title;
  int year;
  String director;
  String synopsis;
  double rating;
  String? posterUrl;

  Movie({
    this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.synopsis,
    required this.rating,
    this.posterUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'director': director,
      'year': year,
      'synopsis': synopsis,
      'rating': rating,
      'posterUrl': posterUrl,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      director: map['director'],
      year: map['year'],
      synopsis: map['synopsis'],
      rating: map['rating'],
      posterUrl: map['posterUrl'],
    );
  }
}
