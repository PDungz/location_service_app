import 'package:equatable/equatable.dart';

import '../../../domain/entities/location.dart';


/// Base class for GPS states
abstract class GpsState extends Equatable {
  const GpsState();

  @override
  List<Object?> get props => [];
}

/// Initial state - GPS not started yet
class GpsInitial extends GpsState {}

/// GPS is disabled on the device
class GpsDisabled extends GpsState {}

/// GPS is actively tracking location
class GpsTracking extends GpsState {
  final Location location;
  final DateTime lastUpdated;

  const GpsTracking({
    required this.location,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [location, lastUpdated];
}

/// GPS tracking stopped by user
class GpsStopped extends GpsState {
  final Location? lastLocation;

  const GpsStopped({this.lastLocation});

  @override
  List<Object?> get props => [lastLocation];
}

/// GPS error state
class GpsError extends GpsState {
  final String message;

  const GpsError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Waiting for permission
class GpsPermissionRequired extends GpsState {}
