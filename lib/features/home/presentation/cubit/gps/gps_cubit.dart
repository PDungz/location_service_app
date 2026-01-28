import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_service_app/features/home/presentation/cubit/gps/gps_state.dart';

import '../../../domain/repositories/gps_repository.dart';
import '../../../domain/usecases/start_gps.dart';
import '../../../domain/usecases/stop_gps.dart';

/// GPS Cubit for managing GPS tracking state
/// Handles starting/stopping GPS and receiving location updates
class GpsCubit extends Cubit<GpsState> {
  final GpsRepository repository;
  final StartGps startGpsUseCase;
  final StopGps stopGpsUseCase;

  StreamSubscription? _locationSubscription;

  GpsCubit({
    required this.repository,
    required this.startGpsUseCase,
    required this.stopGpsUseCase,
  }) : super(GpsInitial());

  /// Check if GPS is enabled and has permission
  Future<void> checkGpsStatus() async {
    final isEnabled = await repository.isGpsEnabled();
    if (!isEnabled) {
      emit(GpsDisabled());
      return;
    }

    final hasPermission = await repository.hasPermission();
    if (!hasPermission) {
      emit(GpsPermissionRequired());
      return;
    }

    emit(GpsInitial());
  }

  /// Start GPS tracking
  Future<void> startTracking() async {
    // Check GPS status first
    final isEnabled = await repository.isGpsEnabled();
    if (!isEnabled) {
      emit(GpsDisabled());
      return;
    }

    // Check/request permission
    var hasPermission = await repository.hasPermission();
    if (!hasPermission) {
      hasPermission = await repository.requestPermission();
      if (!hasPermission) {
        emit(GpsPermissionRequired());
        return;
      }
    }

    // Start GPS
    final started = await startGpsUseCase();
    if (!started) {
      emit(const GpsError(message: 'Failed to start GPS'));
      return;
    }

    // Listen to location updates
    _locationSubscription?.cancel();
    _locationSubscription = repository.locationStream.listen(
      (location) {
        emit(GpsTracking(
          location: location,
          lastUpdated: DateTime.now(),
        ));
      },
      onError: (error) {
        emit(GpsError(message: error.toString()));
      },
    );
  }

  /// Stop GPS tracking
  Future<void> stopTracking() async {
    _locationSubscription?.cancel();
    _locationSubscription = null;

    await stopGpsUseCase();

    // Get last location if available from current state
    final currentState = state;
    if (currentState is GpsTracking) {
      emit(GpsStopped(lastLocation: currentState.location));
    } else {
      emit(const GpsStopped());
    }
  }

  /// Reset to initial state
  void reset() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    emit(GpsInitial());
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
