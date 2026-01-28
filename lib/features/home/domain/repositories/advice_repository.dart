import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/advice.dart';

abstract class AdviceRepository {
  Future<Either<Failure, Advice>> getAdvice();
}
