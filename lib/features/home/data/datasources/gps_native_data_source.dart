import 'dart:async';

import 'package:flutter/services.dart';

import '../models/location_model.dart';

/// GPS Native Data Source interface
/// Defines the contract for communicating with native GPS implementations
abstract class GpsNativeDataSource {
  /// Check if GPS is enabled on the device
  Future<bool> isGpsEnabled();

  /// Check if app has location permission
  Future<bool> hasPermission();

  /// Request location permission from user
  Future<bool> requestPermission();

  /// Start GPS location updates (Polling every 2 seconds)
  Future<bool> startGps();

  /// Stop GPS location updates
  Future<void> stopGps();

  /// Stream of location updates from native platform
  Stream<LocationModel> get locationStream;
}

/// Implementation of GPS Native Data Source using MethodChannel Polling
class GpsNativeDataSourceImpl implements GpsNativeDataSource {
  static const String _channelName = 'com.example.location_service_app/gps';

  final MethodChannel _methodChannel;
  
  StreamController<LocationModel>? _locationController;
  Timer? _pollingTimer;

  GpsNativeDataSourceImpl({
    MethodChannel? methodChannel,
  })  : _methodChannel = methodChannel ?? const MethodChannel(_channelName);

  @override
  Future<bool> isGpsEnabled() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('isGpsEnabled');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> hasPermission() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('hasPermission');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('requestPermission');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> startGps() async {
    try {
      _locationController ??= StreamController<LocationModel>.broadcast();
      
      // Stop any existing timer
      _pollingTimer?.cancel();
      
      // Start polling every 2 seconds
      _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        await _pollLocation();
      });
      
      // Initial poll
      await _pollLocation();
      
      return true;
    } on PlatformException {
      return false;
    }
  }

  Future<void> _pollLocation() async {
    try {
      print('DEBUG: Flutter requesting GPS update from native...');
      final result = await _methodChannel.invokeMethod('getLocation');
      
      if (result != null && result is Map) {
        print('DEBUG: Received location from native: $result');
        final locationModel = LocationModel.fromMap(result);
        _locationController?.add(locationModel);
      } else {
        print('DEBUG: Received empty or invalid location from native');
      }
    } on PlatformException catch (e) {
      print('DEBUG: Error polling GPS: ${e.message}');
      _locationController?.addError(e);
    }
  }

  @override
  Future<void> stopGps() async {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    print('DEBUG: GPS Polling stopped');
  }

  @override
  Stream<LocationModel> get locationStream {
    _locationController ??= StreamController<LocationModel>.broadcast();
    return _locationController!.stream;
  }
  
  /// Dispose resources when no longer needed
  void dispose() {
    _pollingTimer?.cancel();
    _locationController?.close();
    _locationController = null;
  }
}
