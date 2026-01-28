import '../../domain/entities/location.dart';
import '../../domain/repositories/gps_repository.dart';
import '../datasources/gps_native_data_source.dart';

/// GPS Repository Implementation
/// Bridges the data layer (native GPS) with the domain layer
class GpsRepositoryImpl implements GpsRepository {
  final GpsNativeDataSource nativeDataSource;

  GpsRepositoryImpl({required this.nativeDataSource});

  @override
  Future<bool> isGpsEnabled() async {
    return await nativeDataSource.isGpsEnabled();
  }

  @override
  Future<bool> hasPermission() async {
    return await nativeDataSource.hasPermission();
  }

  @override
  Future<bool> requestPermission() async {
    return await nativeDataSource.requestPermission();
  }

  @override
  Future<bool> startGps() async {
    return await nativeDataSource.startGps();
  }

  @override
  Future<void> stopGps() async {
    await nativeDataSource.stopGps();
  }

  @override
  Stream<Location> get locationStream {
    return nativeDataSource.locationStream.map((model) => model.toEntity());
  }
}
