import '../entities/location.dart';

/// GPS Repository interface
/// Defines the contract for GPS operations that will be implemented by data layer
abstract class GpsRepository {
  /// Check if GPS is enabled on the device
  Future<bool> isGpsEnabled();

  /// Check if app has location permission
  Future<bool> hasPermission();

  /// Request location permission from user
  Future<bool> requestPermission();

  /// Start GPS tracking
  Future<bool> startGps();

  /// Stop GPS tracking
  Future<void> stopGps();

  /// Stream of location updates (every 2 seconds)
  Stream<Location> get locationStream;
}
