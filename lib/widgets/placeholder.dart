import 'package:flutter/material.dart';

class MoviePlaceholder extends StatelessWidget {
  final double? height;
  final BoxFit fit;

  const MoviePlaceholder({
    super.key,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[900],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            color: Colors.white24,
            size: 40,
          ),
          const SizedBox(height: 8),
          const Text(
            'No Image Available',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}