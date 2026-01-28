import '../entities/location.dart';
import '../repositories/gps_repository.dart';

/// Check GPS Status Use Case
/// Checks if GPS is enabled on the device
class CheckGpsStatus {
  final GpsRepository repository;

  CheckGpsStatus(this.repository);

  Future<bool> call() async {
    return await repository.isGpsEnabled();
  }
}

/// Get Location Stream Use Case
/// Gets the stream of location updates
class GetLocationStream {
  final GpsRepository repository;

  GetLocationStream(this.repository);

  Stream<Location> call() {
    return repository.locationStream;
  }
}
