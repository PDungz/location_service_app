// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/advice_model.dart';

abstract class AdviceRemoteDataSource {
  Future<AdviceModel> getAdvice();
}

class AdviceRemoteDataSourceImpl implements AdviceRemoteDataSource {
  final Dio dio;

  AdviceRemoteDataSourceImpl({required this.dio});

  @override
  Future<AdviceModel> getAdvice() async {
    try {
      print('[API REQUEST] GET https://api.adviceslip.com/advice');

      final response = await dio.get('https://api.adviceslip.com/advice');

      print('[API RESPONSE] Status: ${response.statusCode}');
      print('[API DATA] ${response.data}');
      print('[DATA TYPE] ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            response.data is String ? jsonDecode(response.data) : response.data;

        return AdviceModel.fromJson(jsonData);
      } else {
        print('[API ERROR] Failed with status: ${response.statusCode}');
        throw ServerException('Failed to fetch advice: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('[DIO ERROR] Type: ${e.type}, Message: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('[UNEXPECTED ERROR] $e');
      throw ServerException('Unexpected error: $e');
    }
  }
}
