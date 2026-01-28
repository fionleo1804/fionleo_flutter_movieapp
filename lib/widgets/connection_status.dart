import 'package:flutter/material.dart';

class ConnectionStatusBanner extends StatelessWidget {
  final bool isOffline;
  final bool showOnlineBanner;

  const ConnectionStatusBanner({
    super.key,
    required this.isOffline,
    required this.showOnlineBanner,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline && !showOnlineBanner) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      color: isOffline ? Colors.redAccent : Colors.green,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        isOffline 
            ? "You're offline. Using cached data." 
            : "Back Online! Syncing details...",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold, 
          fontSize: 12
        ),
      ),
    );
  }
}