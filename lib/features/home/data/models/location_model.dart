import '../../domain/entities/location.dart';

/// Location model for data layer
/// Handles serialization from native platform data
class LocationModel {
  final double latitude;
  final double longitude;
  final int timestamp;
  final double? accuracy;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
  });

  /// Factory constructor from native platform map data
  factory LocationModel.fromMap(Map<dynamic, dynamic> map) {
    return LocationModel(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      timestamp: (map['timestamp'] as num).toInt(),
      accuracy: map['accuracy'] != null ? (map['accuracy'] as num).toDouble() : null,
    );
  }

  /// Convert to domain entity
  Location toEntity() {
    return Location(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
      accuracy: accuracy,
    );
  }

  /// Convert to map for native platform
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
      'accuracy': accuracy,
    };
  }
}
