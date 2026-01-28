import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOffline = false;
  bool _showOnlineBanner = false;
  
  bool get isOffline => _isOffline;
  bool get showOnlineBanner => _showOnlineBanner;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
    final result = await Connectivity().checkConnectivity();
    _isOffline = result.contains(ConnectivityResult.none);
    notifyListeners();

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final bool currentlyOffline = results.contains(ConnectivityResult.none);
      
      if (_isOffline && !currentlyOffline) {
        _isOffline = false;
        _showOnlineBanner = true;
        notifyListeners();

        Future.delayed(const Duration(seconds: 3), () {
          _showOnlineBanner = false;
          notifyListeners();
        });
      } else {
        _isOffline = currentlyOffline;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}