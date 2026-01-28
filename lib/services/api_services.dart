import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../constants.dart';

class TMDBApi {
  static Future<List<Movie>> fetchMovies({int page = 1, String sortBy = 'release_date.desc'}) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final url = 
      '${TMDBConstants.baseUrl}/discover/movie?api_key=${TMDBConstants.apiKey}&page=$page&sort_by=$sortBy&primary_release_date.lte=$today';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  static Future<Movie> fetchMovieDetail(int id) async {
    final url = '${TMDBConstants.baseUrl}/movie/$id?api_key=${TMDBConstants.apiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Movie not found');
    }
  }
}