import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/advice.dart';
import '../../../domain/usecases/get_advice.dart';
import 'advice_state.dart';

/// Cubit for managing advice fetching state
/// Handles periodic API calls with 3-second intervals
class AdviceCubit extends Cubit<AdviceState> {
  final GetAdvice getAdvice;
  Timer? _timer;

  AdviceCubit({required this.getAdvice}) : super(AdviceInitial());

  /// Fetch multiple advices (5 times with 3-second interval)
  /// Emits loading state during fetch and loaded/error state when complete
  Future<void> fetchMultipleAdvices() async {
    const int totalCalls = 5;
    const int intervalSeconds = 3;
    List<Advice> advices = [];
    int currentCall = 0;

    // Cancel old timer if exists
    _timer?.cancel();

    // Make first call immediately
    currentCall++;
    emit(AdviceLoading(currentCall: currentCall, totalCalls: totalCalls, advices: advices));

    final result = await getAdvice();
    result.fold(
      (failure) {
        emit(AdviceError(message: failure.message, advices: advices));
        return;
      },
      (advice) {
        advices.add(advice);
      },
    );

    // Stop if error occurred
    if (state is AdviceError) return;

    // Make subsequent calls with 3-second interval
    _timer = Timer.periodic(const Duration(seconds: intervalSeconds), (timer) async {
      if (currentCall >= totalCalls) {
        timer.cancel();
        emit(AdviceLoaded(advices));
        return;
      }

      currentCall++;
      emit(AdviceLoading(currentCall: currentCall, totalCalls: totalCalls, advices: advices));

      final result = await getAdvice();
      result.fold(
        (failure) {
          timer.cancel();
          emit(AdviceError(message: failure.message, advices: advices));
        },
        (advice) {
          advices.add(advice);

          // Complete if reached total calls
          if (currentCall >= totalCalls) {
            timer.cancel();
            emit(AdviceLoaded(advices));
          }
        },
      );
    });
  }

  /// Reset cubit to initial state and cancel timer
  void reset() {
    _timer?.cancel();
    emit(AdviceInitial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
