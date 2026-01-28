import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/home/data/datasources/advice_remote_data_source.dart';
import '../../features/home/data/repositories/advice_repository_impl.dart';
import '../../features/home/domain/repositories/advice_repository.dart';
import '../../features/home/domain/usecases/get_advice.dart';
import '../../features/home/presentation/cubit/advice_cubit.dart';

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
