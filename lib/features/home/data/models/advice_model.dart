import 'package:equatable/equatable.dart';

import '../../domain/entities/advice.dart';

class AdviceModel extends Equatable {
  final int id;
  final String advice;

  const AdviceModel({required this.id, required this.advice});

  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    return AdviceModel(id: json['slip']['id'] as int, advice: json['slip']['advice'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'slip': {'id': id, 'advice': advice},
    };
  }

  Advice toEntity() {
    return Advice(id: id, advice: advice);
  }

  @override
  List<Object?> get props => [id, advice];
}
