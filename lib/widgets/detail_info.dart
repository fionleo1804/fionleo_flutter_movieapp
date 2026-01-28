import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'placeholder.dart';

class MovieDetailHeader extends StatelessWidget {
  final Movie movie;
  const MovieDetailHeader({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: movie.hasBackdrop
          ? CachedNetworkImage(
              imageUrl: movie.backdropUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const MoviePlaceholder(),
            )
          : movie.hasPoster
              ? CachedNetworkImage(
                  imageUrl: movie.posterUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const MoviePlaceholder(),
                )
              : const MoviePlaceholder(),
    );
  }
}

class MovieMetadataRow extends StatelessWidget {
  final Movie movie;
  final String certification;

  const MovieMetadataRow({super.key, required this.movie, required this.certification});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text(
          movie.voteAverage.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 15),
        Text('${movie.runtime ?? 0} min'),
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(certification, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}

class MovieGenreChips extends StatelessWidget {
  final Movie movie;
  const MovieGenreChips({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    if (movie.genres == null || movie.genres!.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      children: movie.genres!
          .map((genre) => Chip(
                label: Text(genre.name),
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                side: BorderSide.none,
                labelStyle: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                padding: EdgeInsets.zero,
              ))
          .toList(),
    );
  }
}

class InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  const InfoColumn({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class BookingButton extends StatelessWidget {
  final bool isOffline;
  final VoidCallback onPressed;

  const BookingButton({
    super.key,
    required this.isOffline,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOffline ? Colors.grey : Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: const Text('BOOK NOW', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}