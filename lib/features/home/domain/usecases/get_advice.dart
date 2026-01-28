import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/advice.dart';
import '../repositories/advice_repository.dart';

class GetAdvice {
  final AdviceRepository repository;

  GetAdvice(this.repository);

  Future<Either<Failure, Advice>> call() async {
    return await repository.getAdvice();
  }
}
