import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/datasource/remote/dio/dio_client.dart';
import 'package:com.jewelmitra.jewel_mitra/data/datasource/remote/exception/api_error_handler.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/base/api_response.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/app_constants.dart';

class SellerRepo {
  final DioClient dioClient;
  SellerRepo({@required this.dioClient});

  Future<ApiResponse> getSeller(String sellerId) async {
    try {
      final response = await dioClient.get(AppConstants.SELLER_URI+sellerId);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}