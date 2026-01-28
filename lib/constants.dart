import 'package:flutter_dotenv/flutter_dotenv.dart';

class TMDBConstants {
  static final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  static final String baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '';
  static final String imageBase = dotenv.env['TMDB_IMAGE_BASE'] ?? '';

  static const Map<String, String> sortOptions = {
    'Latest Release': 'primary_release_date.desc',
    'Oldest Release': 'primary_release_date.asc',
    'Most Popular': 'popularity.desc',
    'Highest Rated': 'vote_average.desc',
  };
}
