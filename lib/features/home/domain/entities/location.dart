import 'package:equatable/equatable.dart';

/// Location entity representing GPS coordinates
/// This is the domain layer representation of location data
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
  });

  /// Formatted coordinates string for display
  String get formattedCoordinates =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

  /// Formatted latitude for display
  String get formattedLatitude => latitude.toStringAsFixed(6);

  /// Formatted longitude for display
  String get formattedLongitude => longitude.toStringAsFixed(6);

  @override
  List<Object?> get props => [latitude, longitude, timestamp, accuracy];
}
