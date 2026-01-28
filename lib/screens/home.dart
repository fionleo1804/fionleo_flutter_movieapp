import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/movie.dart';
import '../services/api_services.dart';
import '../services/connectivity_service.dart';
import '../widgets/connection_status.dart';
import '../widgets/movie_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  int _page = 1;
  bool _hasMore = true;
  bool _loading = false;
  bool _isOffline = false;
  bool _showOnlineBanner = false;
  String _sortBy = TMDBConstants.sortOptions.values.first;

  final ScrollController _scrollController = ScrollController();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Box _movieBox = Hive.box('movie_cache');

  @override
  void initState() {
    super.initState();
    _loadMovies();

    _scrollController.addListener(() {
      final conn = Provider.of<ConnectivityService>(context, listen: false);
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 
          && !_loading && _hasMore && !conn.isOffline) {
        _loadMovies();
      }
    });
  }

  Future<void> _loadMovies({bool refresh = false}) async {
    if (_loading) return;

    setState(() => _loading = true);

    if (refresh) {
      _page = 1;
      _hasMore = true;
      movies.clear();
    }

    try {
      final results = await TMDBApi.fetchMovies(page: _page, sortBy: _sortBy);

      setState(() {
        movies.addAll(results);
        _hasMore = results.isNotEmpty;
        _page++;
      });

      if (_page == 2) { 
        await _movieBox.put('cached_movies', results.map((m) => m.toJson()).toList());
      }

    } catch (e) {
      debugPrint("Error loading movies: $e");
      
      if (movies.isEmpty && _movieBox.containsKey('cached_movies')) {
        final List cachedData = _movieBox.get('cached_movies');
        setState(() {
          movies = cachedData.map((e) => Movie.fromJson(Map<String, dynamic>.from(e))).toList();
          _hasMore = false;
        });
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<bool?> _showExitConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Exit App?', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to exit the app?', 
          style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('EXIT', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        final shouldExit = await _showExitConfirmation(context);
        if (shouldExit == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Discover Movies'),
          actions: [
            DropdownButton<String>(
              value: _sortBy,
              underline: const SizedBox(),
              icon: const Icon(Icons.sort, color: Colors.white),
              items: TMDBConstants.sortOptions.entries
                  .map((entry) => DropdownMenuItem<String>(
                        value: entry.value,
                        child: Text(entry.key),
                      ))
                  .toList(),
              onChanged: _isOffline ? null : (val) {
                if (val != null) {
                  setState(() => _sortBy = val);
                  _loadMovies(refresh: true);
                }
              },            
            ),
          ],
        ),
        body: Column(
          children: [
            ConnectionStatusBanner(
              isOffline: connectivityService.isOffline,
              showOnlineBanner: connectivityService.showOnlineBanner,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _loadMovies(refresh: true),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: movies.isEmpty && !_loading
                          ? const SliverToBoxAdapter(child: Center(child: Text("No movies available offline.")))
                          : SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.65,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => MovieCard(movie: movies[index]),
                                childCount: movies.length,
                              ),
                            ),
                    ),
                    if (_hasMore && !_isOffline)
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}