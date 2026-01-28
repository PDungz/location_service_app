import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/home/data/datasources/advice_remote_data_source.dart';
import '../../features/home/data/datasources/gps_native_data_source.dart';
import '../../features/home/data/repositories/advice_repository_impl.dart';
import '../../features/home/data/repositories/gps_repository_impl.dart';
import '../../features/home/domain/repositories/advice_repository.dart';
import '../../features/home/domain/repositories/gps_repository.dart';
import '../../features/home/domain/usecases/get_advice.dart';
import '../../features/home/domain/usecases/start_gps.dart';
import '../../features/home/domain/usecases/stop_gps.dart';
import '../../features/home/presentation/cubit/advice/advice_cubit.dart';
import '../../features/home/presentation/cubit/gps/gps_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Advice
  // Cubit
  sl.registerFactory(() => AdviceCubit(getAdvice: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAdvice(sl()));

  // Repository
  sl.registerLazySingleton<AdviceRepository>(() => AdviceRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<AdviceRemoteDataSource>(() => AdviceRemoteDataSourceImpl(dio: sl()));

  // Features - GPS
  // Cubit
  sl.registerFactory(() => GpsCubit(
        repository: sl(),
        startGpsUseCase: sl(),
        stopGpsUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => StartGps(sl()));
  sl.registerLazySingleton(() => StopGps(sl()));

  // Repository
  sl.registerLazySingleton<GpsRepository>(() => GpsRepositoryImpl(nativeDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<GpsNativeDataSource>(() => GpsNativeDataSourceImpl());

  // External
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // Thêm interceptor để log request/response
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );

    return dio;
  });
}
