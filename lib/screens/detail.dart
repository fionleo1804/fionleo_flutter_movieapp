import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/api_services.dart';
import '../services/connectivity_service.dart';
import '../widgets/detail_info.dart';
import '../widgets/connection_status.dart';
import 'booking_webview.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie initialMovie;
  final int movieId;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    required this.initialMovie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Movie movie;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    movie = widget.initialMovie;
    _loadMovie();
  }

  Future<void> _loadMovie() async {
    try {
      setState(() => loading = true);
      final result = await TMDBApi.fetchMovieDetail(widget.movieId);
      if (mounted) {
        setState(() {
          movie = result;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  String get certification {
    if (movie.releaseDates == null || movie.releaseDates!.isEmpty) return 'N/A';
    try {
      final usRating = movie.releaseDates!.firstWhere(
        (e) => e.iso3166_1 == 'US',
        orElse: () => movie.releaseDates!.first,
      );
      return usRating.releaseDates.first.certification.isNotEmpty 
          ? usRating.releaseDates.first.certification : 'N/A';
    } catch (_) { return 'N/A'; }
  }

  @override
  Widget build(BuildContext context) {
    final conn = Provider.of<ConnectivityService>(context);

    if (conn.showOnlineBanner && movie.runtime == null && !loading) {
      Future.microtask(() => _loadMovie());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        centerTitle: kIsWeb,
      ),
      body: Column(
        children: [
          ConnectionStatusBanner(
            isOffline: conn.isOffline,
            showOnlineBanner: conn.showOnlineBanner,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MovieDetailHeader(movie: movie),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title, 
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
                            ),
                            const SizedBox(height: 12),
                            MovieMetadataRow(movie: movie, certification: certification),
                            const SizedBox(height: 20),
                            MovieGenreChips(movie: movie),
                            const Divider(height: 48),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InfoColumn(label: 'Release Date', value: movie.releaseDate),
                                InfoColumn(label: 'Rating', value: movie.popularity.toInt().toString()),
                                InfoColumn(label: 'Language', value: movie.originalLanguage.toUpperCase()),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Text('Synopsis', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Text(
                              movie.overview, 
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8), 
                                height: 1.6, 
                                fontSize: 16
                              )
                            ),
                            const SizedBox(height: 40),
                            
                            SizedBox(
                              width: double.infinity,
                              child: BookingButton(
                                isOffline: conn.isOffline,
                                onPressed: () async {
                                  if (conn.isOffline) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Internet required for booking.")));
                                    return;
                                  }

                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (_) => BookingWebViewPage(url: 'https://www.google.com'),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}