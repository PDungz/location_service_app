import 'package:equatable/equatable.dart';

import '../../domain/entities/advice.dart';

/// Base class for advice states
abstract class AdviceState extends Equatable {
  const AdviceState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any advice is fetched
class AdviceInitial extends AdviceState {}

/// Loading state while fetching advices
/// Contains current progress and previously fetched advices
class AdviceLoading extends AdviceState {
  final int currentCall;
  final int totalCalls;
  final List<Advice> advices;

  const AdviceLoading({
    required this.currentCall,
    required this.totalCalls,
    required this.advices,
  });

  @override
  List<Object?> get props => [currentCall, totalCalls, advices];
}

/// Success state with all fetched advices
class AdviceLoaded extends AdviceState {
  final List<Advice> advices;

  const AdviceLoaded(this.advices);

  @override
  List<Object?> get props => [advices];
}

/// Error state with error message
/// Also contains advices fetched before error occurred
class AdviceError extends AdviceState {
  final String message;
  final List<Advice> advices;

  const AdviceError({
    required this.message,
    required this.advices,
  });

  @override
  List<Object?> get props => [message, advices];
}
