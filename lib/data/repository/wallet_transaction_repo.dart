import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:com.jewelmitra.jewel_mitra/data/datasource/remote/dio/dio_client.dart';
import 'package:com.jewelmitra.jewel_mitra/data/datasource/remote/exception/api_error_handler.dart';
import 'package:com.jewelmitra.jewel_mitra/data/model/response/base/api_response.dart';
import 'package:com.jewelmitra.jewel_mitra/utill/app_constants.dart';

class WalletTransactionRepo {
  final DioClient dioClient;
  WalletTransactionRepo({@required this.dioClient});

  Future<ApiResponse> getWalletTransactionList(int offset) async {
    try {
      Response response = await dioClient.get('${AppConstants.WALLET_TRANSACTION_URI}$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLoyaltyPointList(int offset) async {
    try {
      Response response = await dioClient.get('${AppConstants.LOYALTY_POINT_URI}$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> convertPointToCurrency(int point) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOYALTY_POINT_CONVERT_URI,
        data: {"point": point},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}