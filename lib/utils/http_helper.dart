import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpHelper {
  // base url
  static const String movieNightBaseUrl =
      'https://movie-night-api.onrender.com';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // api Key
  static final String _tmdbApiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  static Future<Map<String, dynamic>> voteMovie(
      String sessionId, int movieId, bool vote) async {
    final response = await http.get(
      Uri.parse(
          '$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote'),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> joinSession(
      String? deviceId, String code) async {
    final response = await http.get(
      Uri.parse(
          '$movieNightBaseUrl/join-session?device_id=$deviceId&code=$code'),
    );
    return jsonDecode(response.body);
  }

  // movie night api Methods
  static Future<Map<String, dynamic>> startSession(String? deviceId) async {
    final response = await http.get(
      Uri.parse('$movieNightBaseUrl/start-session?device_id=$deviceId'),
    );
    return jsonDecode(response.body);
  }

  // tmdb api methods
  static Future<List<Map<String, dynamic>>> fetchMovies(int page) async {
    final response = await http.get(
      Uri.parse('$tmdbBaseUrl/movie/popular?api_key=$_tmdbApiKey&page=$page'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Whoops, failed to load movies!');
    }
  }
}
