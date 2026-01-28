import '../repositories/gps_repository.dart';

/// Stop GPS Use Case
/// Stops GPS location tracking
class StopGps {
  final GpsRepository repository;

  StopGps(this.repository);

  Future<void> call() async {
    await repository.stopGps();
  }
}
