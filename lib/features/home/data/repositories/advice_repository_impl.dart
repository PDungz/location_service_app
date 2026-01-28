import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/advice.dart';
import '../../domain/repositories/advice_repository.dart';
import '../datasources/advice_remote_data_source.dart';

class AdviceRepositoryImpl implements AdviceRepository {
  final AdviceRemoteDataSource remoteDataSource;

  AdviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Advice>> getAdvice() async {
    try {
      final adviceModel = await remoteDataSource.getAdvice();
      return Right(adviceModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
