import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../services/api_services.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;
  int _page = 1;
  String _sortBy = 'primary_release_date.desc';

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String get sortBy => _sortBy;

  void changeSort(String newSort) {
    if (_sortBy != newSort) {
      _sortBy = newSort;
      _movies.clear();
      _page = 1;
      fetchMovies();
    }
  }

  Future<void> fetchMovies({bool loadMore = false}) async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedMovies = await TMDBApi.fetchMovies(page: _page, sortBy: _sortBy);
    
      if (loadMore) {
        _movies.addAll(fetchedMovies);
      } else {
        _movies = fetchedMovies;
      }
      _page++;
    } catch (_) {

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _movies.clear();
    _page = 1;
    await fetchMovies();
  }
}