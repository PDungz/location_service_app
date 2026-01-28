import 'package:equatable/equatable.dart';

class Advice extends Equatable {
  final int id;
  final String advice;

  const Advice({required this.id, required this.advice});

  @override
  List<Object?> get props => [id, advice];
}
