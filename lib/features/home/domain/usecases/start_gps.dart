import '../repositories/gps_repository.dart';

/// Start GPS Use Case
/// Initiates GPS location tracking
class StartGps {
  final GpsRepository repository;

  StartGps(this.repository);

  Future<bool> call() async {
    return await repository.startGps();
  }
}
